// To parse this JSON data, do
//
//     final staffAttendanceResponse = staffAttendanceResponseFromJson(jsonString);

import 'dart:convert';

StaffAttendanceResponse staffAttendanceResponseFromJson(String str) => StaffAttendanceResponse.fromJson(json.decode(str));

String staffAttendanceResponseToJson(StaffAttendanceResponse data) => json.encode(data.toJson());

class StaffAttendanceResponse {
  StaffAttendanceResponse({
    this.success,
    this.message,
    this.attendanceData,
  });

  bool ? success;
  String ? message;
  List<dynamic> ? attendanceData;

  factory StaffAttendanceResponse.fromJson(Map<String, dynamic> json) => StaffAttendanceResponse(
    success: json["success"],
    message: json["message"],
    attendanceData: List<dynamic>.from(json["attendanceData"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "attendanceData": List<dynamic>.from(attendanceData!.map((x) => x)),
  };
}

