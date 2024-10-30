import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../config/environment.config.dart';
import '../config/preference_utils.dart';
import 'api_exception.dart';

String api_url2 = EnvironmentConfig.url;

// String IMAGE_DOMAIN = domain.split("/api")[0];
// String WEB_URL = domain.split("/api")[0];
//
// const String api_url = "https://api-campus.softwarica.edu.np/";
//
// const String api_url2 = "https://api.schoolworkspro.com/";
//
// String IMAGE_api_url2 = api_url.split("/api")[0];
// const String domain = "http://172.25.0.143:5210/api";
// // const String domain = "https://dev.gyapu.com/varshaapi";
// // const String domain = "http://192.168.1.216:5210./api";
// // const String domain = "http://192.168.1.216:5210/api";
// final String IMAGE_DOMAIN = domain.split("/api")[0];
// final String WEB_URL = domain.split("/api")[0];
// const String domain = "https://dev.gyapu.com/api";
// const String staging_domainapi = "https://staging.gyapu.com/api";
// final String staging_imageapi = staging_domainapi.split("/api")[0];

class API {
  final SharedPreferences localStorage = PreferenceUtils.instance;
  Future getData(String apiUrl) async {
    dynamic responseJson;
    try {
      final response =
          await http.get(Uri.parse(api_url2 + apiUrl), headers: _setHeader());
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  Future getWithToken(apiUrl) async {
    print("[GET] :: " + api_url2 + apiUrl);
    dynamic responseJson;
    var token = localStorage.getString('token');

    try {
      final response = await http.get(Uri.parse(api_url2 + apiUrl), headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'platform': EnvironmentConfig.platform,
      });
      print("TOKEN :: " + token.toString());
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } catch (e) {
      print("RESPOSE ERR :: " + e.toString());
    }
    return responseJson;
  }

  Future putWithToken(apiUrl) async {
    print("[PUT] :: " + api_url2 + apiUrl);
    dynamic responseJson;
    var token = localStorage.getString('token');

    try {
      final response = await http.put(Uri.parse(api_url2 + apiUrl), headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'platform': EnvironmentConfig.platform,
      });
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } catch (e) {
      print("RESPOSE ERR :: " + e.toString());
    }
    return responseJson;
  }

  Future deleteWithToken(apiUrl) async {
    print("[DELETE] :: " + api_url2 + apiUrl);
    dynamic responseJson;
    print(api_url2 + apiUrl);

    print(api_url2 + apiUrl);
    var token = localStorage.getString('token');
    try {
      final response =
          await http.delete(Uri.parse(api_url2 + apiUrl), headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'platform': EnvironmentConfig.platform,
      });
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  Future postDataAsWeb(data, apiUrl) async {
    print("[POST WEB] :: " + api_url2 + apiUrl);
    dynamic responseJson;
    try {
      final response = await http
          .post(Uri.parse(api_url2 + apiUrl),
              body: data, headers: _setHeaderAsWeb())
          .timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          // Time has run out, do what you wanted to do.
          throw FetchDataException('No Internet Connection');
        },
      );
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  Future postData(data, apiUrl) async {
    print("[POST] :: " + api_url2 + apiUrl);
    dynamic responseJson;
    try {
      final response = await http
          .post(Uri.parse(api_url2 + apiUrl), body: data, headers: _setHeader())
          .timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          // Time has run out, do what you wanted to do.
          throw FetchDataException('No Internet Connection');
        },
      );
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  Future<dynamic> postChat(dynamic map) async {
    try {
      return await http
          .post(Uri.parse('http://103.90.85.91:5006/webhooks/rest/webhook'),
              headers: {
                'Content-Type': 'application/json; charset=utf-8',
              },
              body: jsonEncode(map))
          .then((data) {
        if (data.statusCode == 200) {
          print("200");
          final response = jsonDecode(data.body);

          return response;
        } else {
          return "n/a";
        }
      }).catchError((e) {
        print(e.toString());
        return "n/a";
      });
    } on SocketException catch (e) {
      print(e);
      return "n/a";
    } on HttpException {
      return "n/a";
    } on FormatException {
      return "n/a";
    }
  }

  Future putData(data, apiUrl) async {
    print("[POST] :: " + api_url2 + apiUrl);
    dynamic responseJson;
    try {
      final response = await http
          .put(Uri.parse(api_url2 + apiUrl), body: data, headers: _setHeader())
          .timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          // Time has run out, do what you wanted to do.
          throw FetchDataException('No Internet Connection');
        },
      );
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  Future postDataFast(data, apiUrl) async {
    print("[POST] :: " + api_url2 + apiUrl);
    dynamic responseJson;
    try {
      final response = await http
          .post(Uri.parse(api_url2 + apiUrl), body: data, headers: _setHeader())
          .timeout(
        const Duration(seconds: 2),
        onTimeout: () {
          // Time has run out, do what you wanted to do.
          throw FetchDataException('No Internet Connection');
        },
      );
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  Future postDataWithHeader(data, apiUrl) async {
    print("[POST] :: " + api_url2 + apiUrl);
    dynamic responseJson;
    try {
      final response = await http.post(Uri.parse(api_url2 + apiUrl),
          body: data, headers: _setHeaders());
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  Future postDataWithToken(data, apiUrl) async {
    dynamic responseJson;

    print("[POST] :::: " + api_url2 + apiUrl);
    if (localStorage.containsKey('token')) {
      var token = localStorage.getString('token');
      print(token.toString());
      try {
        final response = await http.post(
          Uri.parse(api_url2 + apiUrl),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
            'platform': EnvironmentConfig.platform,
          },
          body: data,
        );

        print("STATUS:::${response}");

        responseJson = returnResponse(response);
      } on SocketException {
        throw FetchDataException('No Internet Connection');
      }

      return responseJson;
    } else {
      return postData(data, apiUrl);
    }
  }

  Future postDataWithTokenAsWeb(data, apiUrl) async {
    dynamic responseJson;

    print("[POST] :: " + api_url2 + apiUrl);
    if (localStorage.containsKey('token')) {
      var token = localStorage.getString('token');
      print(token.toString());
      try {
        final response = await http.post(
          Uri.parse(api_url2 + apiUrl),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: data,
        );

        responseJson = returnResponse(response);
      } on SocketException {
        throw FetchDataException('No Internet Connection');
      }
      return responseJson;
    } else {
      return postData(data, apiUrl);
    }
  }

  Future putDataWithToken(data, apiUrl) async {
    dynamic responseJson;

    print("[PUTTT] :: " + api_url2 + apiUrl);
    if (localStorage.containsKey('token')) {
      var token = localStorage.getString('token');

      try {
        final response = await http.put(
          Uri.parse(api_url2 + apiUrl),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
            'platform': EnvironmentConfig.platform,
          },
          body: data,
        );

        responseJson = returnResponse(response);
      } on SocketException {
        throw FetchDataException('No Internet Connection');
      }
      return responseJson;
    } else {
      return putData(data, apiUrl);
    }
  }

  Future postDataWithTokenAndFiles(
      data, apiUrl, List<Map<String, List<String>>> images) async {
    dynamic responseJson;
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    print(token);

    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': "Bearer " + token.toString(),
      'platform': EnvironmentConfig.platform,
    };
    var request = http.MultipartRequest("POST", Uri.parse(api_url2 + apiUrl));

    print("\n\n");
    var _image = File(images[0]['files']![0].toString());

    String name = images[0].toString().split("/").last.toString();
    String name1 = name.split("]").first.toString();

    request.fields.addAll(data);

    request.files.add(http.MultipartFile.fromBytes(
        'file',
        await File.fromUri(Uri.parse(images[0]['files']![0].toString()))
            .readAsBytes(),
        contentType: MediaType(
          'pdf',
          'doc',
        ),
        filename: name1));

    request.headers.addAll(headers);
    try {
      final response = await request.send();
      responseJson = await http.Response.fromStream(response);
      responseJson = returnResponse(responseJson);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  Future postDataWithTokenAndOnlyFiles(String images, String filename) async {
    dynamic responseJson;
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    print(token);

    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': "Bearer " + token.toString(),
      'platform': EnvironmentConfig.platform,
    };
    var request = http.MultipartRequest("POST",
        Uri.parse("https://api.schoolworkspro.com/contents/upload-file"));

    print("IMage" + images.toString());
    print("\n\n");

    request.files.add(http.MultipartFile.fromBytes(
        'file', await File.fromUri(Uri.parse(images)).readAsBytes(),
        contentType: MediaType('pdf', 'doc'), filename: filename));

    request.headers.addAll(headers);
    try {
      final response = await request.send();
      responseJson = await http.Response.fromStream(response);
      responseJson = returnResponse(responseJson);
      print("RESPONSE:::${responseJson.toString()}");
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  // Future postDataWithTokenAndFiles(
  //     data,
  //     is_available,
  //     stock_status,
  //     min_order,
  //     max_order,
  //     sales_price,
  //     price,
  //     Sku_seller,
  //     height,
  //     length,
  //     width,
  //     apiUrl,
  //     List<Map<String, List<dynamic>>> files) async {
  //   dynamic responseJson;
  //   var token = localStorage.getString('token');
  //
  //   Map<String, String> headers = {
  //     'Content-type': 'application/json',
  //     'Accept': 'application/json',
  //     'Authorization': token.toString()
  //   };
  //
  //   var request = http.MultipartRequest("POST", Uri.parse(domain + apiUrl));
  //
  //   request.fields.addAll(data);
  //   request.fields['volume[height]'] = height;
  //   request.fields['volume[width]'] = width;
  //   request.fields['volume[length]'] = length;
  //
  //   files.forEach((element) {
  //     element.values.first.forEach((i) {
  //       var _image = File(i);
  //       request.files.add(
  //         http.MultipartFile(
  //           element.keys.first,
  //           _image.readAsBytes().asStream(),
  //           _image.lengthSync(),
  //           filename: "image.jpg",
  //           contentType: MediaType('image', 'jpeg'),
  //         ),
  //       );
  //     });
  //   });
  //
  //   for (int i = 0; i < 1; i++) {
  //     request.fields['variant[$i][is_available]'] = json.encode(is_available);
  //     request.fields['variant[$i][stock_status]'] = stock_status;
  //     request.fields['variant[$i][min_order]'] = min_order;
  //     request.fields['variant[$i][max_order]'] = max_order;
  //     request.fields['variant[$i][sales_price]'] = sales_price;
  //     request.fields['variant[$i][price]'] = price;
  //     request.fields['variant[$i][sku_of_seller]'] = Sku_seller;
  //     //   "variant": [{
  //     //     "is_available": true,
  //     //     "stock_status": "5df61e4017bcc76ed4c4a10f",
  //     //     "min_order": "11",
  //     //     "max_order": "12",
  //     //     "sales_price": "11",
  //     //     "price": "12",
  //     //     "sku_of_seller": "taatatt"
  //     //   }],
  //   }
  //
  //   request.headers.addAll(headers);
  //   try {
  //     final response = await request.send();
  //     responseJson = await http.Response.fromStream(response);
  //     responseJson = returnResponse(responseJson);
  //   } on SocketException {
  //     throw FetchDataException('No Internet Connection');
  //   }
  //   return responseJson;
  // }



  Future deleteDataWithToken(apiUrl) async {
    print("[DELETE] :: " + api_url2 + apiUrl);
    dynamic responseJson;
    var token = localStorage.getString('token');
    try {
      final response =
          await http.delete(Uri.parse(api_url2 + apiUrl), headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'platform': EnvironmentConfig.platform,
      });
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  _setHeaders() => {
        'Content-Type': 'application/json;charset=UTF-8',
        'Charset': 'utf-8',
        'platform': EnvironmentConfig.platform,
      };

  _setHeader() => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'platform': EnvironmentConfig.platform,
      };

  _setHeaderAsWeb() => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        "platform": "web"
      };

  logout() async {
    localStorage.remove('user');
    localStorage.remove('token');
    localStorage.remove('displayShowcase');
  }

  @visibleForTesting
  dynamic returnResponse(http.Response response) {
    print("STATUS CODE :: " + response.statusCode.toString());
    switch (response.statusCode) {
      case 200:
        dynamic responseJson = jsonDecode(response.body);
        responseJson["STATUS_CODE"] = response.statusCode.toString();
        return responseJson;
      case 201:
        dynamic responseJson = jsonDecode(response.body);
        responseJson["STATUS_CODE"] = response.statusCode.toString();
        return responseJson;
      case 301:
      case 302:
        dynamic responseJson = jsonDecode(response.body);
        responseJson["STATUS_CODE"] = response.statusCode.toString();
        return responseJson;
      case 400:
        dynamic responseJson = jsonDecode(response.body);
        try {
          if (responseJson["success"] != null ||
              responseJson["message"] != null) {
            return responseJson;
          } else {
            throw BadRequestException(response.body.toString());
          }
        } catch (e) {
          throw BadRequestException(response.body.toString());
        }

      case 401:
      case 403:
        dynamic responseJson = jsonDecode(response.body);
        if (responseJson["errors"] != null || responseJson["msg"] != null) {
          return responseJson;
        } else {
          throw UnauthorisedException(response.body.toString());
        }
      case 404:
        dynamic responseJson = jsonDecode(response.body);
        print("404 ERR :: " + responseJson.toString());
        if (responseJson["errors"] != null || responseJson["msg"] != null) {
          return responseJson;
        } else {
          throw BadRequestException(response.body.toString());
        }
      case 406:
        dynamic responseJson = jsonDecode(response.body);
        responseJson["STATUS_CODE"] = response.statusCode.toString();
        if (responseJson["success"] != null) {
          return responseJson;
        } else {
          throw BadRequestException(response.body.toString());
        }
      case 409:
        dynamic responseJson = jsonDecode(response.body);
        responseJson["STATUS_CODE"] = response.statusCode.toString();
        if (responseJson["msg"] != null || responseJson["success"] != null) {
          return responseJson;
        } else {
          throw BadRequestException(response.body.toString());
        }
      case 429:
        dynamic responseJson = jsonDecode(response.body);
        responseJson["STATUS_CODE"] = response.statusCode.toString();
        if (responseJson["msg"] != null || responseJson["success"] != null) {
          return responseJson;
        } else {
          throw BadRequestException(response.body.toString());
        }
      case 501:
        dynamic responseJson = jsonDecode(response.body);
        responseJson["STATUS_CODE"] = response.statusCode.toString();
        if (responseJson["msg"] != null || responseJson["success"] != null) {
          return responseJson;
        } else {
          throw BadRequestException(response.body.toString());
        }
      case 500:
        dynamic responseJson = jsonDecode(response.body);
        responseJson["STATUS_CODE"] = response.statusCode.toString();
        if (responseJson["message"] != null ||
            responseJson["success"] != null) {
          return responseJson;
        } else {
          throw BadRequestException(response.body.toString());
        }
      default:
        try {
          print(response.body.toString());
        } catch (e) {}
        throw FetchDataException(
            'Error occured while communication with server' +
                ' with status code : ${response.statusCode}');
    }
  }
}
