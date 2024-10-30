import 'dart:convert';
import 'dart:io';

import 'package:flutter/rendering.dart';
import 'package:qr_attendance/components/constants.dart';
import 'package:qr_attendance/response/idfromqr_response.dart';
import 'package:qr_attendance/response/punch_response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class PunchService {
  // Future<PunchResponse> punchInOut() async {
  //   final SharedPreferences sharedPreferences =
  //       await SharedPreferences.getInstance();
  //
  //   String? token = sharedPreferences.getString('token');
  //   final response = await http.post(
  //     Uri.parse(api_url2 + 'staffAttendance/add-for-mobile'),
  //     headers: {
  //       'Authorization': 'Bearer $token',
  //       'Content-Type': 'application/json; charset=utf-8',
  //     },
  //   );
  //
  //   if (response.statusCode == 200) {
  //     return PunchResponse.fromJson(jsonDecode(response.body));
  //   } else {
  //     // If the server did not return a 200 OK response,
  //     // then throw an exception.
  //     throw Exception('Failed to punch');
  //   }
  // }

  Future<PunchResponse> punchInOut(IdRequestFromQr request) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString('token');
    try {
      return await http
          .post(Uri.parse(api_url2 + 'staffAttendance/add-for-mobile'),
              headers: {
                'Authorization': 'Bearer $token',
                'Content-Type': 'application/json',
                'accept': 'application/json',
              },
              body: json.encode(request.toJson()))
          .then((data) {
        if (data.statusCode == 200) {
          final response = PunchResponse.fromJson(jsonDecode(data.body));

          return response;
        } else if (data.statusCode == 404 || data.statusCode == 401) {
          return PunchResponse(
              success: false, message: "some error has occured");
        } else {
          return PunchResponse(
              success: false, message: "some error has occured");
        }
      }).catchError((e) {
        return PunchResponse(success: false, message: "some error has occured");
      });
    } on SocketException catch (e) {
      // ignore: avoid_print
      return PunchResponse(success: false, message: "some error has occured");
    } on HttpException {
      return PunchResponse(success: false, message: "some error has occured");
    } on FormatException {
      return PunchResponse(success: false, message: "some error has occured");
    }
  }

  Future<PunchResponse> studentAttendance(data2) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString('token');
    try {
      print(token);
      return await http
          .post(Uri.parse(api_url2 + 'student-attendance/scan-student-qr'),
              headers: {
                'Authorization': 'Bearer $token',
                'Content-Type': 'application/json',
                'accept': 'application/json',
                'secret': 'hey!IAmScanningQR'
              },
              body: data2)
          .then((data) {
        if (data.statusCode == 200) {
          final response = PunchResponse.fromJson(jsonDecode(data.body));

          return response;
        } else if (data.statusCode == 404 || data.statusCode == 401) {
          return PunchResponse(
              success: false, message: "some error has occured");
        } else {
          return PunchResponse(
              success: false, message: "some error has occured");
        }
      }).catchError((e) {
        return PunchResponse(success: false, message: "some error has occured");
      });
    } on SocketException catch (e) {
      // ignore: avoid_print
      return PunchResponse(success: false, message: "some error has occured");
    } on HttpException {
      return PunchResponse(success: false, message: "some error has occured");
    } on FormatException {
      return PunchResponse(success: false, message: "some error has occured");
    }
  }
}
