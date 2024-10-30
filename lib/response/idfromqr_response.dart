// To parse this JSON data, do
//
//     final idRequestFromQr = idRequestFromQrFromJson(jsonString);

import 'dart:convert';

IdRequestFromQr idRequestFromQrFromJson(String str) => IdRequestFromQr.fromJson(json.decode(str));

String idRequestFromQrToJson(IdRequestFromQr data) => json.encode(data.toJson());

class IdRequestFromQr {
  IdRequestFromQr({
    this.username,
    this.institution,
    this.type,
    this.batch,
    this.contact,
  });

  String ? username;
  String ? institution;
  String ? type;
  String ? batch;
  String ? contact;

  factory IdRequestFromQr.fromJson(Map<String, dynamic> json) => IdRequestFromQr(
    username: json["username"],
    institution: json["institution"],
    type: json["type"] ?? "",
    batch: json["batch"] ?? "",
    contact: json["contact"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "username": username,
    "institution": institution,
    "type": type,
    "batch": batch,
    "contact": contact,
  };
}
