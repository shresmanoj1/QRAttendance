// To parse this JSON data, do
//
//     final dateRequest = dateRequestFromJson(jsonString);

import 'dart:convert';

DateRequest dateRequestFromJson(String str) => DateRequest.fromJson(json.decode(str));

String dateRequestToJson(DateRequest data) => json.encode(data.toJson());

class DateRequest {
  DateRequest({
    this.date,
    this.batch, this.course
  });

  DateTime ? date;
  String? course;
  String? batch;

  factory DateRequest.fromJson(Map<String, dynamic> json) => DateRequest(
    date: DateTime.parse(json["date"]),
    course: json["course"],
    batch: json["batch"],
  );

  Map<String, dynamic> toJson() => {
    "date": date?.toIso8601String(),
    "course": course,
    "batch": batch,
  };
}
