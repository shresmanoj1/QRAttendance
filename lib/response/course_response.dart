// To parse this JSON data, do
//
//     final courseResponse = courseResponseFromJson(jsonString);

import 'dart:convert';

CourseResponse courseResponseFromJson(String str) =>
    CourseResponse.fromJson(json.decode(str));

String courseResponseToJson(CourseResponse data) => json.encode(data.toJson());

class CourseResponse {
  CourseResponse({
    this.success,
    this.courses,
  });

  bool? success;
  List<Course>? courses;

  factory CourseResponse.fromJson(Map<String, dynamic> json) => CourseResponse(
    success: json["success"],
    courses:
    List<Course>.from(json["courses"].map((x) => Course.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "courses": List<dynamic>.from(courses!.map((x) => x.toJson())),
  };
}

class Course {
  Course({
    this.courseName,
    this.courseDesc,
    this.courseShortDesc,
    this.imageUrl,
    this.courseSlug,
    this.institution,
    this.credits,
    this.years,
  });

  String? courseName;
  String? courseDesc;
  String? courseShortDesc;
  String? imageUrl;
  String? courseSlug;
  String? institution;
  String? credits;
  String? years;

  factory Course.fromJson(Map<String, dynamic> json) => Course(
    courseName: json["courseName"],
    courseDesc: json["courseDesc"],
    courseShortDesc: json["courseShortDesc"],
    imageUrl: json["imageUrl"],
    courseSlug: json["courseSlug"],
    institution: json["institution"],
    credits: json["credits"],
    years: json["years"],
  );

  Map<String, dynamic> toJson() => {
    "courseName": courseName,
    "courseDesc": courseDesc,
    "courseShortDesc": courseShortDesc,
    "imageUrl": imageUrl,
    "courseSlug": courseSlug,
    "institution": institution,
    "credits": credits,
    "years": years,
  };
}
