// To parse this JSON data, do
//
//     final staffResponse = staffResponseFromJson(jsonString);

import 'dart:convert';

StaffResponse staffResponseFromJson(String str) => StaffResponse.fromJson(json.decode(str));

String staffResponseToJson(StaffResponse data) => json.encode(data.toJson());

class StaffResponse {
  bool? success;
  List<String>? staffs;

  StaffResponse({
    this.success,
    this.staffs,
  });

  factory StaffResponse.fromJson(Map<String, dynamic> json) => StaffResponse(
    success: json["success"],
    staffs: List<String>.from(json["staffs"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "staffs": List<dynamic>.from(staffs!.map((x) => x)),
  };
}
