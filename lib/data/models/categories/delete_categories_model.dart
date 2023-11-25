import 'dart:convert';

DeleteCategoriesModel deleteCategoriesModelFromJson(String str) =>
    DeleteCategoriesModel.fromJson(json.decode(str));

String deleteCategoriesModelToJson(DeleteCategoriesModel data) =>
    json.encode(data.toJson());

class DeleteCategoriesModel {
  final int status;
  final Data data;
  final String message;

  DeleteCategoriesModel({
    required this.status,
    required this.data,
    required this.message,
  });

  factory DeleteCategoriesModel.fromJson(Map<String, dynamic> json) =>
      DeleteCategoriesModel(
        status: json["status"],
        data: Data.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data.toJson(),
        "message": message,
      };
}

class Data {
  Data();

  factory Data.fromJson(Map<String, dynamic> json) => Data();

  Map<String, dynamic> toJson() => {};
}
