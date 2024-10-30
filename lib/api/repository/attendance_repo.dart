import 'dart:convert';

import 'package:qr_attendance/api/endpoints.dart';
import 'package:qr_attendance/request/login_request.dart';
import 'package:qr_attendance/response/login_response.dart';
import 'package:qr_attendance/response/routine_preference_response.dart';
import 'package:qr_attendance/response/staff_attendanceresponse.dart';

import '../../request/date_request.dart';
import '../../response/batch_course_response.dart';
import '../../response/batch_wise_attendance.dart';
import '../../response/course_response.dart';
import '../../response/encryp_student_qr_response.dart';
import '../../response/get_all_module_response.dart';
import '../api.dart';

class AttendanceRepo {
  Future<StaffAttendanceResponse> getStaffAttendance(
      DateRequest request) async {
    API api = API();

    dynamic response;
    StaffAttendanceResponse res;
    try {
      response = await api.postDataWithToken(jsonEncode(request), Endpoints.kStaffAttendance);

      res = StaffAttendanceResponse.fromJson(response);
    } catch (e) {
      print(e.toString());

      // print("asas"+response.toString());
      res = StaffAttendanceResponse.fromJson(response);
      print(res.toJson().toString());
    }
    return res;
  }

  Future<EncryptStudentQrResponse> postEncryptStudentQr(data) async {
    API api = new API();
    dynamic response;
    EncryptStudentQrResponse res;

    print(data);

    try {
      response = await api.postDataWithToken(jsonEncode(data) ,'/student-attendance/generate-qr');

      res = EncryptStudentQrResponse.fromJson(response);
    } catch (e) {
      res = EncryptStudentQrResponse.fromJson(response);
    }
    return res;
  }

  Future<CourseResponse> getCourse() async {
    API api = API();
    dynamic response;
    CourseResponse res;
    try {
      response = await api.getWithToken('/courses');

      res = CourseResponse.fromJson(response);
    } catch (e) {
      res = CourseResponse.fromJson(response);
    }
    return res;
  }

  // Future<GetAllModulesPrincipalResponse> getAllModules() async {
  //   API api = API();
  //   dynamic response;
  //   GetAllModulesPrincipalResponse res;
  //   try {
  //     response = await api.getWithToken('/modules/all');
  //
  //     res = GetAllModulesPrincipalResponse.fromJson(response);
  //   } catch (e) {
  //     res = GetAllModulesPrincipalResponse.fromJson(response);
  //   }
  //   return res;
  // }

  Future<BatchpercourseResponse> getCourseBatch(String courseSlug) async {
    API api = new API();
    dynamic response;
    BatchpercourseResponse res;
    try {
      response = await api.getWithToken('/batch/$courseSlug');

      res = BatchpercourseResponse.fromJson(response);
    } catch (e) {
      res = BatchpercourseResponse.fromJson(response);
    }
    return res;
  }

  Future<BatchWiseAttendanceResponse> getAllBatchWiseAttendance(data) async {
    API api = API();
    dynamic response;
    BatchWiseAttendanceResponse res;
    try {
      response = await api.postDataWithToken(jsonEncode(data), '/attendance/batch-wise-attendance');

      res = BatchWiseAttendanceResponse.fromJson(response);
      print(res.toJson());
    } catch (e) {
      res = BatchWiseAttendanceResponse.fromJson(response);
    }
    return res;
  }

  Future<RoutinePreferenceResponse> getRoutinePreference() async {
    API api = new API();
    dynamic response;
    RoutinePreferenceResponse res;
    try {
      response = await api.getWithToken('/preference/refresh-time');

      res = RoutinePreferenceResponse.fromJson(response);
    } catch (e) {
      res = RoutinePreferenceResponse.fromJson(response);
    }
    return res;
  }
}
