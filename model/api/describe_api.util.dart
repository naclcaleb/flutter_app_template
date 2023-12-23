import 'requests.dart';


class RequestDescriptor {
  List<Request> requests = [
    Requests.testRequest('test')
  ];

  String describe() {

    var description = '';
    for (var request in requests) {
      description += request.describe();
    }

    return description;
  }

  String routes() {

    var httpMethodStrings = {
      HttpMethod.get: 'GET   ',
      HttpMethod.post: 'POST  ',
      HttpMethod.put: 'PUT   ',
      HttpMethod.delete: 'DELETE'
    };

    return requests.map((request) {
      return '${httpMethodStrings[request.method]}\t${request.route}\n${request.describe()}';
    }).join('\n\n');
  }
}

var requestDescriptor = RequestDescriptor();

void main() {
  print('API Routes:');
  print(requestDescriptor.routes());
}