// To parse this JSON data, do
//
//     final punchResponse = punchResponseFromJson(jsonString);

import 'dart:convert';

PunchResponse punchResponseFromJson(String str) => PunchResponse.fromJson(json.decode(str));

String punchResponseToJson(PunchResponse data) => json.encode(data.toJson());

class PunchResponse {
  PunchResponse({
    this.success,
    this.message,
  });

  bool ? success;
  String ? message;

  factory PunchResponse.fromJson(Map<String, dynamic> json) => PunchResponse(
    success: json["success"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
  };
}
