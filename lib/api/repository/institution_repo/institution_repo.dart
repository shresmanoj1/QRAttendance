import 'dart:convert';

import 'package:qr_attendance/api/endpoints.dart';
import 'package:qr_attendance/request/login_request.dart';
import 'package:qr_attendance/response/institution_response.dart';
import 'package:qr_attendance/response/login_response.dart';

import '../../api.dart';

class InstitutionRepo {
  Future<InstitutionResponse> getInstitution() async {
    API api = API();

    dynamic response;
    InstitutionResponse res;
    try {
      response = await api.getWithToken(Endpoints.kInstitution);

      res = InstitutionResponse.fromJson(response);
    } catch (e) {
      print(e.toString());
      res = InstitutionResponse.fromJson(response);
      print(res.toJson().toString());
    }
    return res;
  }
}
