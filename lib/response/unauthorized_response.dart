// To parse this JSON data, do
//
//     final unauthorizedResponse = unauthorizedResponseFromJson(jsonString);

import 'dart:convert';

UnauthorizedResponse unauthorizedResponseFromJson(String str) => UnauthorizedResponse.fromJson(json.decode(str));

String unauthorizedResponseToJson(UnauthorizedResponse data) => json.encode(data.toJson());

class UnauthorizedResponse {
  UnauthorizedResponse({
    this.success,
    this.status,
    this.message,
  });

  bool ? success;
  int ? status;
  String  ? message;

  factory UnauthorizedResponse.fromJson(Map<String, dynamic> json) => UnauthorizedResponse(
    success: json["success"],
    status: json["status"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "status": status,
    "message": message,
  };
}
