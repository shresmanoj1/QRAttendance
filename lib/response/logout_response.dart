// To parse this JSON data, do
//
//     final logoutResponse = logoutResponseFromJson(jsonString);

import 'dart:convert';

LogoutResponse logoutResponseFromJson(String str) => LogoutResponse.fromJson(json.decode(str));

String logoutResponseToJson(LogoutResponse data) => json.encode(data.toJson());

class LogoutResponse {
  LogoutResponse({
    this.success,
  });

  bool ? success;

  factory LogoutResponse.fromJson(Map<String, dynamic> json) => LogoutResponse(
    success: json["success"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
  };
}
