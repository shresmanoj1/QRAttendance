// To parse this JSON data, do
//
//     final getAllModulesPrincipalResponse = getAllModulesPrincipalResponseFromJson(jsonString);

import 'dart:convert';

GetAllModulesPrincipalResponse getAllModulesPrincipalResponseFromJson(
    String str) =>
    GetAllModulesPrincipalResponse.fromJson(json.decode(str));

String getAllModulesPrincipalResponseToJson(
    GetAllModulesPrincipalResponse data) =>
    json.encode(data.toJson());

class GetAllModulesPrincipalResponse {
  GetAllModulesPrincipalResponse({
    this.success,
    this.modules,
  });

  bool? success;
  List<Module>? modules;

  factory GetAllModulesPrincipalResponse.fromJson(Map<String, dynamic> json) =>
      GetAllModulesPrincipalResponse(
        success: json["success"],
        modules:
        List<Module>.from(json["modules"].map((x) => Module.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "modules": List<dynamic>.from(modules!.map((x) => x.toJson())),
  };
}

class Module {
  Module({
    this.moduleTitle,
    this.imageUrl,
    this.moduleSlug,
  });

  String? moduleTitle;
  String? imageUrl;
  String? moduleSlug;

  factory Module.fromJson(Map<String, dynamic> json) => Module(
    moduleTitle: json["moduleTitle"],
    imageUrl: json["imageUrl"],
    moduleSlug: json["moduleSlug"],
  );

  Map<String, dynamic> toJson() => {
    "moduleTitle": moduleTitle,
    "imageUrl": imageUrl,
    "moduleSlug": moduleSlug,
  };
}
