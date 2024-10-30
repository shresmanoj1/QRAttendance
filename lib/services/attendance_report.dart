import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qr_attendance/components/constants.dart';
import 'package:qr_attendance/request/date_request.dart';
import 'package:qr_attendance/response/staff_attendanceresponse.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../response/staff_response.dart';

class StaffAttendanceService extends ChangeNotifier {
  Future<StaffAttendanceResponse> getstats(DateRequest request) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString('token');
    try {
      return await http
          .post(Uri.parse(api_url2 + 'staffAttendance/getAttendance/'),
              headers: {
                'Authorization': 'Bearer $token',
                'Content-Type': 'application/json',
                'accept': 'application/json',
              },
              body: json.encode(request.toJson()))
          .then((data) {
        if (data.statusCode == 200) {
          final response =
              StaffAttendanceResponse.fromJson(jsonDecode(data.body));

          return response;
        } else if (data.statusCode == 404 || data.statusCode == 401) {
          return StaffAttendanceResponse(
            success: false,
          );
        } else {
          return StaffAttendanceResponse(
            success: false,
          );
        }
      }).catchError((e) {
        return StaffAttendanceResponse(
            success: false,
            attendanceData: null,
            message: "some error has occured");
      });
    } on SocketException catch (e) {
      // ignore: avoid_print
      // print(e);
      return StaffAttendanceResponse(
          success: false,
          attendanceData: null,
          message: "some error has occured");
    } on HttpException {
      return StaffAttendanceResponse(
          success: false,
          attendanceData: null,
          message: "some error has occured");
    } on FormatException {
      return StaffAttendanceResponse(
          success: false,
          attendanceData: null,
          message: "some error has occured");
    }
  }

  Future<StaffResponse> getStaff() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString('token');
    try {
      return await http.get(
        Uri.parse(api_url2 + 'users/all-staff-data'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'accept': 'application/json',
        },
      ).then((data) {
        if (data.statusCode == 200) {
          final response = StaffResponse.fromJson(jsonDecode(data.body));

          return response;
        } else if (data.statusCode == 404 || data.statusCode == 401) {
          return StaffResponse(
            success: false,
          );
        } else {
          return StaffResponse(
            success: false,
          );
        }
      }).catchError((e) {
        return StaffResponse(
          success: false,
        );
      });
    } on SocketException catch (e) {
      // ignore: avoid_print
      // print(e);
      return StaffResponse(
        success: false,
      );
    } on HttpException {
      return StaffResponse(
        success: false,
      );
    } on FormatException {
      return StaffResponse(
        success: false,
      );
    }
  }
}
