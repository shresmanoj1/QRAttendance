// To parse this JSON data, do
//
//     final routinePreferenceResponse = routinePreferenceResponseFromJson(jsonString);

import 'dart:convert';

RoutinePreferenceResponse routinePreferenceResponseFromJson(String str) => RoutinePreferenceResponse.fromJson(json.decode(str));

String routinePreferenceResponseToJson(RoutinePreferenceResponse data) => json.encode(data.toJson());

class RoutinePreferenceResponse {
  bool? success;
  int? refreshTime;

  RoutinePreferenceResponse({
    this.success,
    this.refreshTime,
  });

  factory RoutinePreferenceResponse.fromJson(Map<String, dynamic> json) => RoutinePreferenceResponse(
    success: json["success"],
    refreshTime: json["refreshTime"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "refreshTime": refreshTime,
  };
}
