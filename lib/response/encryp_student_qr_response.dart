// To parse this JSON data, do
//
//     final encryptStudentQrResponse = encryptStudentQrResponseFromJson(jsonString);

import 'dart:convert';

EncryptStudentQrResponse encryptStudentQrResponseFromJson(String str) => EncryptStudentQrResponse.fromJson(json.decode(str));

String encryptStudentQrResponseToJson(EncryptStudentQrResponse data) => json.encode(data.toJson());

class EncryptStudentQrResponse {
  bool? success;
  QrData? qrData;

  EncryptStudentQrResponse({
    this.success,
    this.qrData,
  });

  factory EncryptStudentQrResponse.fromJson(Map<String, dynamic> json) => EncryptStudentQrResponse(
    success: json["success"],
    qrData: QrData.fromJson(json["qrData"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "qrData": qrData?.toJson(),
  };
}

class QrData {
  String? institution;
  String? token;

  QrData({
    this.institution,
    this.token,
  });

  factory QrData.fromJson(Map<String, dynamic> json) => QrData(
    institution: json["institution"],
    token: json["token"],
  );

  Map<String, dynamic> toJson() => {
    "institution": institution,
    "token": token,
  };
}
