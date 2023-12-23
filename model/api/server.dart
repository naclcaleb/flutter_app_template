import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'response_handler.dart';
import 'responses/basic_response.dart';
import '../error_handlers/network_error_handler.dart';
import '../services/error_service.dart';
import '../../root_app_config.dart';
import '../auth/auth_controller.dart';
import '../../service_locator.dart';
import 'requests.dart';



class ServerConfig {
  static const DEV_URL = 'http://${RootAppConfig.devHost}:8088';
  static const PROD_URL = 'https://${RootAppConfig.prodHost}';
}

class HttpError extends Error {
  final int statusCode;
  final String body;

  HttpError(this.statusCode, this.body);

  @override
  String toString() {
    return 'HttpError: $statusCode $body';
  }
}

class Server {

  final AuthController _authController;
  final ErrorService _errorService = sl();

  static final String _baseUrl = RootAppConfig.environment == ProjectEnvironment.dev ? ServerConfig.DEV_URL : ServerConfig.PROD_URL;
  static const String _appVersion = RootAppConfig.appVersion;

  Server(this._authController);

  //Base request code
  Future<Map<String, dynamic>> makeRequest(String route, HttpMethod method, Map<String, String> headers, Map<String, dynamic>? data) async {
    //Parse the URL
    var httpUrl = Uri.parse('$_baseUrl/$route');
    
    //For get requests, data is given as query parameters
    if (method == HttpMethod.get) {
      Map<String, dynamic> newData = Map.from(data ?? {});
      newData.updateAll((key, value) {
        if (value is! Iterable) {
          return value.toString();
        }
        return value;
      });
      httpUrl = httpUrl.replace(queryParameters: newData);
    }

    //Add version header
    headers['X-App-Version'] = _appVersion;
    headers['Content-type'] = 'application/json';

    //Make the proper request
    http.Response response;
    if (method == HttpMethod.get) { response = await http.get(httpUrl, headers: headers); }
    else if (method == HttpMethod.post) { response = await http.post(httpUrl, headers: headers, body: json.encode(data)); }
    else if (method == HttpMethod.put) { response = await http.put(httpUrl, headers: headers, body: json.encode(data)); }
    else if (method == HttpMethod.delete) { response = await http.delete(httpUrl, headers: headers); }
    else { throw Exception('Invalid HTTP method'); }

    Map<String, dynamic> jsonBody;
    try {
      jsonBody = jsonDecode(response.body);
    } on FormatException catch(error) {
      final newError = FormatException(response.body, error);
      _errorService.receiveError(newError);
      return {};
    }

    //Handle error codes
    if (response.statusCode != 200) {

      if (jsonBody['success'] != null && jsonBody['success'] == false) {

        final String errorMessage = jsonBody['errorMessage'] ?? 'No error message provided';
        throw NetworkException(message: errorMessage, statusCode: response.statusCode);

      }

      if (jsonBody['message'] != null && jsonBody['message'] == 'Invalid token') {
        _authController.signOut();
        throw NetworkException(message: 'Invalid token', statusCode: response.statusCode);
      }
      log(response.body);
      throw NetworkException(message: 'Unknown Error', statusCode: response.statusCode);

    }

    //Format response as JSON
    return jsonBody;
  }

  //For requests that require authentication
  Future<Map<String, dynamic>> makeAuthenticatedRequest(String route, HttpMethod method, Map<String, dynamic>? data) async {
    //First, we need to get the Firebase ID token
    var token = await _authController.getSessionToken();
    
    //Set the token in the Authorization header, and app version header
    var headers = {
      'Authorization': 'Bearer $token',
      'X-App-Version': _appVersion,
    };
    
    //Make the request
    return await makeRequest(route, method, headers, data);
  }

  //For ease of use and error handling
  Future<BasicResponse> perform(Request request) async {
    Map<String, dynamic> responseJson;
    
    if (request.requiresAuth) {
      responseJson = await makeAuthenticatedRequest(request.route, request.method, request.data).catchError((error) {
        _errorService.receiveError(error);
        throw error;
      });
    }
    else {
      responseJson = await makeRequest(request.route, request.method, {}, request.data).catchError((error) {
        _errorService.receiveError(error);
        throw error;
      });
    }

    log('ServerLog: ${responseJson.toString()}');

    //Automatically parse as a BasicResponse
    return ResponseHandler.protectedParse((json) => BasicResponse.fromJson(json), responseJson);

  }

  Future<ResponseType> performAndParse<ResponseType extends BasicResponse>(Request request, ResponseType Function(Map<String, dynamic> json) parseFunc) async {
    Map<String, dynamic> responseJson;
    
    if (request.requiresAuth) {
      responseJson = await makeAuthenticatedRequest(request.route, request.method, request.data).catchError((error) {
        _errorService.receiveError(error);
        throw error;
      });
    }
    else {
      responseJson = await makeRequest(request.route, request.method, {}, request.data).catchError((error) {
        _errorService.receiveError(error);
        throw error;
      });
    }

    return ResponseHandler.protectedParse(parseFunc, responseJson);
  }

}