// To parse this JSON data, do
//
//     final loginResponse = loginResponseFromJson(jsonString);

import 'dart:convert';

LoginResponse loginResponseFromJson(String str) =>
    LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
  LoginResponse({
    this.success,
    this.token,
    this.user,
  });

  bool? success;
  String? token;
  User? user;

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        success: json["success"],
        token: json["token"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "token": token,
        "user": user?.toJson(),
      };
}

class User {
  User({
    this.firstname,
    this.lastname,
    this.username,
    this.type,
    this.institution,
  });

  String? firstname;
  String? lastname;
  String? username;
  String? type;
  String? institution;



  factory User.fromJson(Map<String, dynamic> json) => User(
        firstname: json["firstname"],
        lastname: json["lastname"],
        username: json["username"],
        type: json["type"],

        institution: json["institution"],



      );

  Map<String, dynamic> toJson() => {
        "firstname": firstname,
        "lastname": lastname,
        "username": username,
        "type": type,
        "institution": institution,


      };
}
