import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:qr_attendance/components/constants.dart';
import 'package:qr_attendance/response/institution_response.dart';
import 'package:qr_attendance/response/jwt_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InstitutionService {
  Future<InstitutionResponse> getinstitutiondetail() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');

    final response = await http.get(
      Uri.parse(api_url2 + 'institutions/find-one'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=utf-8',
      },
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return InstitutionResponse.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load institution detail');
    }
  }

  Future<JwtResponse> getverification() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');

    final response = await http.get(
      Uri.parse(api_url2 + 'institutions/find-one'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=utf-8',
      },
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return JwtResponse.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('.');
    }
  }
}
