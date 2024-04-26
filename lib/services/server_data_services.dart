import 'dart:io';

import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:saasify/models/product/product_variant.dart';
import 'package:saasify/services/safe_hive_operations.dart';
import 'package:saasify/services/service_locator.dart';

import '../enums/hive_boxes_enum.dart';
import '../models/category/categories_model.dart';
import '../models/product/product_model.dart';
import 'firebase_services.dart';
import 'hive_box_service.dart';
import 'package:path/path.dart' as path;

class ServerDataServices {
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

  Future<bool> checkIfProductVariantExists() async {
    final productVariantBox =
        Hive.box<ProductVariant>(HiveBoxes.productVariants.boxName);
    return productVariantBox.isNotEmpty;
  }

  Future<void> fetchAndStoreCategoriesFromServer() async {
    try {
      var querySnapshot =
          await firebaseService.getCategoriesCollectionRef().get();
      var firestoreData = querySnapshot.docs
          .map((doc) =>
              CategoriesModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();

      if (HiveBoxService.categoryBox.isOpen) {
        await safeHiveOperation(HiveBoxService.categoryBox, (box) async {
          for (var category in firestoreData) {
            if (!box.containsKey(category.categoryId)) {
              await box.put(category.categoryId, category);
            }
          }
          await updateCategoryLocalImages(firestoreData);
        });
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchAndStoreProductsFromServer() async {
    try {
      final categoriesBox =
          Hive.box<CategoriesModel>(HiveBoxes.categories.boxName);
      await Future.forEach(categoriesBox.toMap().entries, (entry) async {
        var querySnapshot =
            await firebaseService.getProductsCollectionRef(entry.key).get();
        var firestoreData = querySnapshot.docs
            .map((doc) =>
                ProductsModel.fromMap(doc.data() as Map<String, dynamic>))
            .toList();
        if (HiveBoxService.productsBox.isOpen) {
          await safeHiveOperation(HiveBoxService.productsBox, (box) async {
            for (var products in firestoreData) {
              if (!box.containsKey(products.productId)) {
                await box.put(products.productId, products);
              }
            }
            await updateProductsLocalImages(firestoreData);
          });
        }
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchAndStoreVariantsFromServer() async {
    try {
      final productsBox = Hive.box<ProductsModel>(HiveBoxes.products.boxName);
      await Future.forEach(productsBox.toMap().entries, (entry) async {
        var querySnapshot = await firebaseService
            .getVariantsCollectionRef(
                entry.value.categoryId!, entry.value.productId!)
            .get();
        var firestoreData = querySnapshot.docs
            .map((doc) =>
                ProductVariant.fromMap(doc.data() as Map<String, dynamic>))
            .toList();

        if (HiveBoxService.productVariantBox.isOpen) {
          await safeHiveOperation(HiveBoxService.productVariantBox,
              (box) async {
            for (var variants in firestoreData) {
              if (!box.containsKey(variants.variantId)) {
                await box.put(variants.variantId, variants);
              } else {}
            }
          });
        } else {}
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateProductsLocalImages(
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

  Future<void> updateCategoryLocalImages(
      List<CategoriesModel> categories) async {
    final directory = await getApplicationDocumentsDirectory();
    Dio dio = Dio();
    for (var category in categories) {
      if (category.serverImagePath != null) {
        final filename = path.basename(category.serverImagePath!);
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
                category.serverImagePath!, localPath,
                onReceiveProgress: (received, total) {});
            if (response.statusCode == 200) {
              category.localImagePath = localPath;
              await safeHiveOperation(HiveBoxService.categoryBox, (box) async {
                await box.put(category.categoryId, category);
              });
            } else {}
          } catch (e) {
            rethrow;
          }
        } else {}
      }
    }
  }

  Future<ProductsModel> searchProductById(String productId) async {
    final productsBox = Hive.box<ProductsModel>(HiveBoxes.products.boxName);
    ProductsModel? product = productsBox.values
        .firstWhere((product) => product.productId == productId);
    return product;
  }

  Future<List<ProductVariant>> searchProductVariantsByProductId(
      String productId) async {
    final productVariantBox =
        Hive.box<ProductVariant>(HiveBoxes.productVariants.boxName);

    List<ProductVariant> variants = productVariantBox.values
        .where((variant) => variant.productId == productId)
        .toList();

    return variants;
  }
}
