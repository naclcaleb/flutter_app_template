class BasicResponse {
  String? errorMessage; 
  bool success;

  BasicResponse({
    this.errorMessage,
    required this.success,
  });

  BasicResponse.fromJson(Map<String, dynamic> json) :
    errorMessage = json['errorMessage'],
    success = json['success'];
}