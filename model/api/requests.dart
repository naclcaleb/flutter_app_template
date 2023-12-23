enum HttpMethod {
  get,
  post,
  put,
  delete,
}

class Request {
  String route;
  String name;
  HttpMethod method;
  bool requiresAuth;
  Map<String, dynamic>? data;

  Request(this.route, this.method, this.requiresAuth, { this.name = 'Untitled', this.data = const {} });

  String describe() {
    var dataString = '';
    
    if (data != null && data!.isNotEmpty) {
      for (var key in data!.keys) {
        dataString += '\t$key: ${data![key].runtimeType}\n';
      }
    }

    var responseString = '''
Request: $name, Route: $route, Method: $method, Requires Auth: $requiresAuth''';

    if (dataString.isNotEmpty) {
      responseString += '\nParameters:\n $dataString';
    }

    return responseString;
  }
}

class Requests {

  static Request testRequest(String param) {
    return Request('route/to/endpoint', HttpMethod.post, true /* Requires Auth */, data: {
      'param': param
    }, name: 'Test');
  }

}