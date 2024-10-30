import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:qr_attendance/api/repository/attendance_repo.dart';
import 'package:qr_attendance/api/repository/institution_repo/institution_repo.dart';
import 'package:qr_attendance/api/repository/user_repo.dart';
import 'package:qr_attendance/components/constants.dart';
import 'package:qr_attendance/components/snack.dart';
import 'package:qr_attendance/pager_view.dart';
import 'package:qr_attendance/request/date_request.dart';
import 'package:qr_attendance/request/login_request.dart';
import 'package:qr_attendance/response/batch_course_response.dart';
import 'package:qr_attendance/response/course_response.dart';
import 'package:qr_attendance/response/encryp_student_qr_response.dart';
import 'package:qr_attendance/response/institution_response.dart';
import 'package:qr_attendance/response/login_response.dart';
import 'package:qr_attendance/response/routine_preference_response.dart';
import 'package:qr_attendance/response/staff_attendanceresponse.dart';
import 'package:qr_attendance/response/student_daily_attendance_response.dart';
import 'package:qr_attendance/services/student_attendance_report.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api/api_response.dart';
import 'components/custom_loader.dart';
import 'config/preference_utils.dart';

class CommonViewModel extends ChangeNotifier {
  ApiResponse _classApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get classApiResponse => _classApiResponse;
  SharedPreferences preferences = PreferenceUtils.instance;

  Future<void> login(BuildContext context, LoginRequest datas) async {
    // context.loaderOverlay.show();
    customLoadStart();
    _classApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      LoginResponse res = await UserRepo().login(datas);
      if (res.success == true) {
        if (res.user?.type != kType) {
          snackThis(
              context: context,
              color: Colors.red,
              content: const Text("You are not allowed to login"));
            customLoadStop();
        }
        else {
          preferences.setString(kUsername, datas.username.toString());
          preferences.setString(kAuth, jsonEncode(res.user));
          preferences.setString(kPassword, datas.password.toString());
          preferences.setString(kToken, res.token.toString());
          customLoadStop();
          snackThis(
              context: context,
              color: Colors.green,
              content: const Text("Login success"));

          Navigator.pushReplacementNamed(context, PagerView.routeName);
        }
      } else {
        snackThis(
            context: context,
            color: Colors.red,
            content: const Text("Please check credentials and try again"));
        customLoadStop();
      }

      customLoadStop();
      _classApiResponse = ApiResponse.completed(res);
      notifyListeners();
    } catch (e) {
      snackThis(
          context: context,
          color: Colors.red,
          content: const Text("An unexpected error occurred. Please try again later."));
        customLoadStop();

      _classApiResponse = ApiResponse.error(e.toString());
    } finally {
      customLoadStop();
    }
    notifyListeners();
    customLoadStop();
  }

  ApiResponse _institutionApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get institutionApiResponse => _institutionApiResponse;
  dynamic _institution;
  dynamic get institution => _institution;

  Future<void> hitApi(BuildContext context) async {

    final datas = LoginRequest(
      password: preferences.getString(kPassword),
      username: preferences.getString(kUsername)
    );
    await login(context, datas);
  }

  void scheduleApiCall(BuildContext context) {
    var now = DateTime.now();
    var scheduledTime = DateTime(now.year, now.month, now.day, 13, 10, 0); // Set the time to 12:00 am
    var duration = scheduledTime.difference(now);
    Timer(duration, () {
      hitApi(context);
      scheduleApiCall(context); // Schedule the next API call
    });
  }
  Future<void> fetchInstitution(BuildContext context) async {
    _institutionApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      InstitutionResponse res = await InstitutionRepo().getInstitution();
      if (res.success == true) {
        _institution = res.institution;
      }

      _institutionApiResponse = ApiResponse.completed(res);
      notifyListeners();
    } catch (e) {
      _institution = null;
      // Navigator.pushReplacementNamed(context, LoginScreen.routeName);
      hitApi(context);
      print(e.toString());
      _institutionApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  ApiResponse _attendanceApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get attendanceApiResponse => _attendanceApiResponse;
  List<dynamic> _attendanceData = <dynamic>[];
  List<dynamic> get attendanceData => _attendanceData;

  Future<void> fetchStaffAttendance(BuildContext context,DateRequest request) async {
    _attendanceApiResponse = ApiResponse.initial("Loading");
    notifyListeners();

    try {
      StaffAttendanceResponse res =
          await AttendanceRepo().getStaffAttendance(request);
      if (res.success == true) {
        _attendanceData = res.attendanceData!;
      }
      _attendanceApiResponse = ApiResponse.completed(res);
      notifyListeners();
    } catch (e) {
      hitApi(context);
      // Navigator.pushReplacementNamed(context, LoginScreen.routeName);
      print(e.toString());
      _attendanceApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  ApiResponse _encryptStudentQrApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get encryptStudentQrApiResponse => _encryptStudentQrApiResponse;
  EncryptStudentQrResponse _encryptStudentQr = EncryptStudentQrResponse();
  EncryptStudentQrResponse get encryptStudentQr => _encryptStudentQr;

  Future<void> fetchEncryptStudentQr(request) async {
    _encryptStudentQrApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      EncryptStudentQrResponse res = await AttendanceRepo().postEncryptStudentQr(request);
      if (res.success == true) {
        _encryptStudentQr = res;

        _encryptStudentQrApiResponse =
            ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _encryptStudentQrApiResponse =
            ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERRee :: " + e.toString());
      _encryptStudentQrApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  // ApiResponse _modulesApiResponse = ApiResponse.initial("Empty Data");
  // ApiResponse get modulesApiResponse => _modulesApiResponse;
  // List<Module> _modules = <Module>[];
  // List<Module> get modules => _modules;
  //
  // Future<void> fetchAllModules() async {
  //   _modulesApiResponse = ApiResponse.initial("Loading");
  //   notifyListeners();
  //   try {
  //     GetAllModulesPrincipalResponse res =
  //     await AttendanceRepo().getAllModules();
  //     if (res.success == true) {
  //       _modules = res.modules!;
  //
  //       _modulesApiResponse = ApiResponse.completed(res.success.toString());
  //       notifyListeners();
  //     } else {
  //       _modulesApiResponse = ApiResponse.error(res.success.toString());
  //     }
  //   } catch (e) {
  //     print("VM CATCH ERR :: " + e.toString());
  //     _modulesApiResponse = ApiResponse.error(e.toString());
  //   }
  //   notifyListeners();
  // }

  ApiResponse _courseApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get courseApiResponse => _courseApiResponse;
  List<Course> _courses = <Course>[];
  List<Course> get courses => _courses;

  Future<void> fetchCourses() async {
    _courseApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      CourseResponse res = await AttendanceRepo().getCourse();
      if (res.success == true) {
        _courses = res.courses!;

        _courseApiResponse = ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _courseApiResponse = ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERR :: " + e.toString());
      _courseApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  ApiResponse _courseBatchApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get courseBatchApiResponse => _courseBatchApiResponse;
  BatchpercourseResponse _courseBatch = BatchpercourseResponse();
  BatchpercourseResponse get courseBatch => _courseBatch;

  Future<void> fetchCourseBatch(String courseSlug) async {
    _courseBatchApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      BatchpercourseResponse res = await AttendanceRepo().getCourseBatch(courseSlug);
      if (res.success == true) {
        _courseBatch = res;
        _courseBatchApiResponse = ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _courseBatchApiResponse = ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERR :: " + e.toString());
      _courseBatchApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  ApiResponse _allStudentAttendanceReportApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get allStudentAttendanceReportApiResponse => _allStudentAttendanceReportApiResponse;
  StudentDailyAttendanceResponse _allStudentAttendanceReport = StudentDailyAttendanceResponse();
  StudentDailyAttendanceResponse get allStudentAttendanceReport => _allStudentAttendanceReport;
  // var studentForDisplay = StudentDailyAttendanceResponse();

  Future<void> fetchAllStudentAttendance(data) async {
    _allStudentAttendanceReportApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      StudentDailyAttendanceResponse res = await StudentAttendanceReportService().studentDailyAttendanceReport(data);
      if (res.success == true) {
        _allStudentAttendanceReport = new StudentDailyAttendanceResponse();
        _allStudentAttendanceReport = res;

        // studentForDisplay = res;

        _allStudentAttendanceReportApiResponse =
            ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _allStudentAttendanceReportApiResponse = ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERR :: " + e.toString());
      _allStudentAttendanceReportApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }


  ApiResponse _routinePreferenceApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get routinePreferenceApiResponse => _routinePreferenceApiResponse;
  RoutinePreferenceResponse _routinePreference = RoutinePreferenceResponse();
  RoutinePreferenceResponse get routinePreference => _routinePreference;

  Future<void> fetchRoutinePreference() async {
    _routinePreferenceApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      RoutinePreferenceResponse res = await AttendanceRepo().getRoutinePreference();
      if (res.success == true) {
        _routinePreference = res;

        _routinePreferenceApiResponse =
            ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _routinePreferenceApiResponse = ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERR :: " + e.toString());
      _routinePreferenceApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }
}
