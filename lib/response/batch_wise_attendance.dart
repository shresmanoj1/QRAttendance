// To parse this JSON data, do
//
//     final batchWiseAttendanceResponse = batchWiseAttendanceResponseFromJson(jsonString);

import 'dart:convert';

BatchWiseAttendanceResponse batchWiseAttendanceResponseFromJson(String str) => BatchWiseAttendanceResponse.fromJson(json.decode(str));

String batchWiseAttendanceResponseToJson(BatchWiseAttendanceResponse data) => json.encode(data.toJson());

class BatchWiseAttendanceResponse {
  BatchWiseAttendanceResponse({
    this.success,
    this.allAttendance,
    this.moduleLength,
  });

  bool? success;
  List<dynamic>? allAttendance;
  int? moduleLength;

  factory BatchWiseAttendanceResponse.fromJson(Map<String, dynamic> json) => BatchWiseAttendanceResponse(
    success: json["success"],
    allAttendance: List<dynamic>.from(json["allAttendance"].map((x) => x)),
    moduleLength: json["moduleLength"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "allAttendance": List<dynamic>.from(allAttendance!.map((x) => x.toJson())),
    "moduleLength": moduleLength,
  };
}

