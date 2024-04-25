import 'dart:io';

import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import '../../enums/hive_boxes_enum.dart';
import '../../models/category/categories_model.dart';
import '../../models/product/product_model.dart';
import '../../services/firebase_services.dart';
import '../../services/hive_box_service.dart';
import '../../services/safe_hive_operations.dart';
import '../../services/service_locator.dart';
import 'package:path/path.dart' as path;

class ProductService {
  final firebaseService = getIt<FirebaseServices>();

  Future<bool> checkIfCategoryExists() async {
    final categoriesBox =
        Hive.box<CategoriesModel>(HiveBoxes.categories.boxName);
    return categoriesBox.isNotEmpty;
  }

  Future<bool> checkIfProductExists() async {
    final productsBox = Hive.box<ProductsModel>(HiveBoxes.products.boxName);
    return productsBox.isNotEmpty;
  }

  Future<Map<String, List<ProductsModel>>> fetchDataFromHive(
      categoriesBox, productsBox) async {
    Map<String, List<ProductsModel>> categoryProductsMap = {};
    for (var category in categoriesBox.values) {
      List<ProductsModel> products = productsBox.values
          .where((product) => product.categoryId == category.categoryId)
          .toList();
      if (products.isNotEmpty) {
        categoryProductsMap[category.name!] = products;
      }
    }
    return categoryProductsMap;
  }

  fetchProductsFromServerAndSave(Box<CategoriesModel> categoriesBox) async {
    List<ProductsModel> fetchedProductsList = [];
    await Future.forEach(categoriesBox.toMap().entries, (entry) async {
      var querySnapshot =
          await firebaseService.getProductsCollectionRef(entry.key).get();
      var firestoreData = querySnapshot.docs
          .map((doc) =>
              ProductsModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
      fetchedProductsList.addAll(firestoreData);
    });
    updateLocalImages(fetchedProductsList);
  }

  Future<void> updateLocalImages(
      List<ProductsModel> fetchedProductsList) async {
    final directory = await getApplicationDocumentsDirectory();
    Dio dio = Dio();

    for (var product in fetchedProductsList) {
      if (product.serverImagePath != null) {
        final filename = path.basename(product.serverImagePath!);
        final localPath = path.join(directory.path, filename);
        File file = File(localPath);
        bool fileExists = false;
        try {
          fileExists = await file.exists();
          if (fileExists && await file.length() == 0) {
            fileExists = false;
          }
        } catch (e) {
          fileExists = false;
        }

        if (!fileExists) {
          try {
            Response response = await dio.download(
                product.serverImagePath!, localPath,
                onReceiveProgress: (received, total) {});
            if (response.statusCode == 200) {
              product.localImagePath = localPath;

              if (HiveBoxService.productsBox.isOpen) {
                await safeHiveOperation(HiveBoxService.productsBox,
                    (box) async {
                  await box.put(product.productId, product);
                });
              }
            } else {}
          } catch (e) {
            rethrow;
          }
        } else {}
      } else {}
    }
  }
}
