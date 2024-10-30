// To parse this JSON data, do
//
//     final jwtResponse = jwtResponseFromJson(jsonString);

import 'dart:convert';

JwtResponse jwtResponseFromJson(String str) => JwtResponse.fromJson(json.decode(str));

String jwtResponseToJson(JwtResponse data) => json.encode(data.toJson());

class JwtResponse {
  JwtResponse({
    this.success,
    this.status,
    this.message,
  });

  bool ? success;
  int ? status;
  String ? message;

  factory JwtResponse.fromJson(Map<String, dynamic> json) => JwtResponse(
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
