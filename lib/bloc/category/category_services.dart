import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';

import '../../models/category/categories_model.dart';
import '../../services/firebase_services.dart';
import '../../services/hive_box_service.dart';
import '../../services/safe_hive_operations.dart';
import '../../services/service_locator.dart';
import 'category_state.dart';
import 'package:path/path.dart' as path;

class CategoryService {
  final firebaseService = getIt<FirebaseServices>();

  Future<void> fetchAndStoreCategoriesFromFirestore({
    Emitter<CategoryState>? emit,
    bool fromCategory = false,
  }) async {
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
          await updateLocalImages(firestoreData);
          if (emit != null && fromCategory) {
            emit(CategoriesWithProductsFetched(categories: firestoreData));
          }
        });
      }
    } catch (e) {
      emit?.call(CategoriesWithProductsNotFetched(
          errorMessage: 'Error fetching categories: $e'));
    }
  }

  Future<void> updateLocalImages(List<CategoriesModel> categories) async {
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
}
