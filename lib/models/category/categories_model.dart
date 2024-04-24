import 'package:hive/hive.dart';
import '../../configs/hive_type_ids.dart';

part 'categories_model.g.dart';

@HiveType(typeId: HiveTypeIds.categories)
class CategoriesModel {
  @HiveField(0)
  String? name;

  @HiveField(1)
  String? localImagePath;

  @HiveField(2)
  String? categoryId;
  @HiveField(3)
  bool? isUploadedToServer;
  @HiveField(4)
  String? serverImagePath;

  CategoriesModel({
    this.name = '',
    this.localImagePath,
    this.categoryId = '',
    this.isUploadedToServer = false,
    this.serverImagePath = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'imagePath': localImagePath,
      'categoryId': categoryId,
      'isUploadedToServer': isUploadedToServer,
      'serverImagePath': serverImagePath
    };
  }

  factory CategoriesModel.fromMap(Map<dynamic, dynamic> map) {
    return CategoriesModel(
        categoryId: map['categoryId'] as String?,
        name: map['name'] as String?,
        localImagePath: map['imagePath'] as String?,
        isUploadedToServer: map['isUploadedToServer'] as bool?,
        serverImagePath: map['serverImagePath'] as String?);
  }

  @override
  String toString() {
    return 'CategoriesModel(name: $name, imagePath: $localImagePath, categoryId: $categoryId, isUploadedToServer: $isUploadedToServer, serverImagePath:$serverImagePath)';
  }
}
