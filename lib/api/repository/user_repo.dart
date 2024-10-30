import 'dart:convert';

import 'package:qr_attendance/api/endpoints.dart';
import 'package:qr_attendance/request/login_request.dart';
import 'package:qr_attendance/response/login_response.dart';

import '../api.dart';

class UserRepo {
  Future<LoginResponse> login(LoginRequest datas) async {
    API api = API();

    dynamic response;
    LoginResponse res;
    try {
      response = await api.postData(jsonEncode(datas),Endpoints.login);

      res = LoginResponse.fromJson(response);
    } catch (e) {
      print(e.toString());

      // print("asas"+response.toString());
      res = LoginResponse.fromJson(response);
      print(res.toJson().toString());
    }
    return res;
  }
}
