import '../api/requests.dart';
import '../error_handlers/http_error_messages.dart';

class NetworkException implements Exception {
  final String message;
  final int statusCode;

  NetworkException({required this.message, required this.statusCode});

  @override
  String toString() {
    return message;
  }
}

class NetworkErrorHandler {
  static NetworkException error(int statusCode, Request request, String contextMessage) {
    var httpMessage = httpErrorMessages[statusCode];
    var fullMessage = '''
NetworkError
Status Code: $statusCode
HTTP Message: $httpMessage
Request: 
  Route: ${request.route}
  Method: ${request.method.toString()}
  Data: ${request.data}
Additional Context: $contextMessage
''';

  return NetworkException(message: fullMessage, statusCode: statusCode);
  }
}