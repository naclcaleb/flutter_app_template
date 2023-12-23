abstract class JsonObject {
  Map<String, dynamic> toJson();
}

abstract class JsonDecodable {
  JsonDecodable fromJson(Map<String, dynamic> json) { throw UnimplementedError(); }
}