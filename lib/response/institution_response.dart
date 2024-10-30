// To parse this JSON data, do
//
//     final institutionResponse = institutionResponseFromJson(jsonString);

import 'dart:convert';

InstitutionResponse institutionResponseFromJson(String str) => InstitutionResponse.fromJson(json.decode(str));

String institutionResponseToJson(InstitutionResponse data) => json.encode(data.toJson());

class InstitutionResponse {
  InstitutionResponse({
    this.success,
    this.institution,
  });

  bool ? success;
  dynamic  institution;

  factory InstitutionResponse.fromJson(Map<String, dynamic> json) => InstitutionResponse(
    success: json["success"],
    institution: json["institution"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "institution": institution,
  };
}
