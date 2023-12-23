import 'responses/basic_response.dart';

class ResponseParseException implements Exception {
  final Map<String, dynamic> responseJson;
  final String errorMessage;
  final String targetType;

  ResponseParseException({required this.responseJson, required this.errorMessage, required this.targetType});

  @override
  String toString() {
    return '''
ResponseParseException:
  Target Type: $targetType
  Response JSON: ${responseJson.toString()}
Error Message: 
$errorMessage
''';
  }
}

class ResponseHandler {
  static Type protectedParse<Type extends BasicResponse>(Type Function(Map<String, dynamic>) parse, Map<String, dynamic> json) {
    try {
      return parse(json);
    } on TypeError catch(e) {
      throw ResponseParseException(responseJson: json, errorMessage: e.toString(), targetType: Type.toString());
    }
  }
}