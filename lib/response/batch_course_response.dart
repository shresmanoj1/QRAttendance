import 'dart:convert';

BatchpercourseResponse batchpercourseResponseFromJson(String str) =>
    BatchpercourseResponse.fromJson(json.decode(str));

String batchpercourseResponseToJson(BatchpercourseResponse data) =>
    json.encode(data.toJson());

class BatchpercourseResponse {
  BatchpercourseResponse({
    this.success,
    this.batches,
  });

  bool? success;
  List<dynamic>? batches;

  factory BatchpercourseResponse.fromJson(Map<String, dynamic> json) =>
      BatchpercourseResponse(
        success: json["success"],
        batches: List<dynamic>.from(json["batches"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "batches": List<dynamic>.from(batches!.map((x) => x)),
  };
}
