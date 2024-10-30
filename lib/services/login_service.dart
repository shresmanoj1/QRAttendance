import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:qr_attendance/components/constants.dart';
import 'package:qr_attendance/request/login_request.dart';
import 'package:qr_attendance/response/login_response.dart';
import 'package:qr_attendance/response/logout_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginService {
  Future<LogoutResponse> logout() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');
    try {
      return await http.get(
        Uri.parse(api_url2 + 'verification/logout'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json; charset=utf-8',
        },
      ).then((data) {
        if (data.statusCode == 200) {
          final response = LogoutResponse.fromJson(jsonDecode(data.body));
          return response;
        } else if (data.statusCode == 404 || data.statusCode == 401) {
          return LogoutResponse(success: false);
        } else {
          return LogoutResponse(success: false);
        }
      }).catchError((e) {
        print(e);
        return LogoutResponse(success: false);
      });
    } on SocketException catch (e) {
      print(e);
      return LogoutResponse(success: false);
    } on HttpException {
      return LogoutResponse(success: false);
    } on FormatException {
      return LogoutResponse(success: false);
    }
  }

  Future<LoginResponse> login(
      LoginRequest loginRequest, String username, String password) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    try {
      return await http
          .post(Uri.parse(api_url2 + 'verification/login'),
              headers: {
                'Content-Type': 'application/json',
                'accept': 'application/json',
              },
              body: json.encode(loginRequest.toJson()))
          .then((data) {
        if (data.statusCode == 200) {
          final response = LoginResponse.fromJson(jsonDecode(data.body));


          sharedPreferences.setString('username', username.toString());
          sharedPreferences.setString('password', password.toString());
          // sharedPreferences.setString('userImage', response.user.userImage);

          return response;
        } else if (data.statusCode == 404 || data.statusCode == 401) {
          print("inside 404");
          return LoginResponse(success: false, user: null);
        } else {
          return LoginResponse(success: false, user: null);
        }
      }).catchError((e) {
        print(e.toString());
        return LoginResponse(success: false, user: null);
      });
    } on SocketException catch (e) {
      // ignore: avoid_print
      print(e);
      return LoginResponse(success: false, user: null);
    } on HttpException {
      return LoginResponse(success: false, user: null);
    } on FormatException {
      return LoginResponse(success: false, user: null);
    }
  }
}
