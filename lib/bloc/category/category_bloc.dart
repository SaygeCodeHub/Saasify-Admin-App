import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:saasify/bloc/category/category_event.dart';
import 'package:saasify/bloc/category/category_state.dart';
import 'package:saasify/models/category/categories_model.dart';
import 'package:saasify/models/product/product_variant.dart';
import 'package:saasify/models/product/product_model.dart';
import 'package:saasify/services/firebase_services.dart';
import 'package:saasify/services/service_locator.dart';
import 'package:saasify/utils/global.dart';
import 'package:saasify/services/hive_box_service.dart';
import 'package:saasify/utils/retrieve_image_from_firebase.dart';
import 'package:saasify/utils/unique_id.dart';
import '../../enums/hive_boxes_enum.dart';
import '../../services/safe_hive_operations.dart';
import 'package:path/path.dart' as path;

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  CategoryState get initialState => CategoryInitial();

  final firebaseService = getIt<FirebaseServices>();

  CategoryBloc() : super(CategoryInitial()) {
    on<AddCategory>(_addCategory);
    on<FetchCategoriesWithProducts>(_fetchCategoriesWithProducts);
    on<FetchProductsForSelectedCategory>(_fetchProductForCategory);
  }

  Map<dynamic, dynamic> categoryInputData = {};
  String? selectedCategory;

  FutureOr<void> _addCategory(
      AddCategory event, Emitter<CategoryState> emit) async {
    try {
      print("Starting to add category");
      emit(AddingCategory());

      // Assign category ID
      event.categoriesModel.categoryId = IDUtil.generateUUID();
      print("Generated UUID for category: ${event.categoriesModel.categoryId}");

      // Check if category name is already present
      bool isNamePresent =
          await isCategoryNamePresent(event.categoriesModel.name!);
      print(
          "Is category name '${event.categoriesModel.name}' present? $isNamePresent");

      if (!isNamePresent) {
        print("Adding category to local storage");
        await safeHiveOperation(HiveBoxService.categoryBox, (box) async {
          await box.put(
              event.categoriesModel.categoryId, event.categoriesModel);
        });

        // Emit success state
        emit(CategoryAdded(successMessage: 'Category added successfully'));
        print("Category added to local storage");

        // Check for cloud version
        if (kIsCloudVersion) {
          print("Adding category to cloud");
          bool isUploadedToCloud =
              await _addCategoryToCloud(5, event.categoriesModel);
          print("Is category uploaded to cloud? $isUploadedToCloud");

          if (isUploadedToCloud) {
            print("Updating local and remote flags");
            await _updateLocalAndRemoteFlags(event.categoriesModel);
            print("Updated local and remote flags");
          }
        }
      } else {
        print("Category already exists");
        emit(CategoryNotAdded(errorMessage: 'Category already exists.'));
      }
    } catch (e) {
      print("Error: $e");
      emit(CategoryNotAdded(
          errorMessage: 'Could not add category. Please try again!'));
    }
  }

  Future<bool> isCategoryNamePresent(String categoryName) async {
    final box = HiveBoxService.categoryBox;
    print("Checking if category name '$categoryName' is present in the box");
    return box.values.any((category) => category.name == categoryName);
  }

  Future<bool> _addCategoryToCloud(
      int maxRetries, CategoriesModel categoriesModel) async {
    int attempt = 0;
    print("Starting to add category to cloud with max retries: $maxRetries");

    while (attempt < maxRetries) {
      try {
        print("Attempt $attempt to add category to cloud");
        String imagePath = categoriesModel.localImagePath ?? '';
        print("Local image path: $imagePath");

        // Log before retrieving the image from Firebase
        print("Retrieving image from Firebase");
        String serverImagePath = await RetrieveImageFromFirebase()
            .uploadImageAndGetUrl(imagePath, 'categories');
        print("Server image path retrieved: $serverImagePath");

        categoriesModel.serverImagePath = serverImagePath;

        // Log before adding category to cloud database
        print(
            "Adding category to cloud database with ID: ${categoriesModel.categoryId}");
        final categoriesRef = firebaseService.getCategoriesCollectionRef();
        await categoriesRef
            .doc(categoriesModel.categoryId)
            .set(categoriesModel.toMap());
        print("Category successfully added to cloud database");

        // Check Hive box operation
        if (HiveBoxService.categoryBox.isOpen) {
          print("Updating category in Hive box");
          await safeHiveOperation(HiveBoxService.categoryBox, (box) async {
            await box.put(categoriesModel.categoryId, categoriesModel);
          });
          print("Category successfully updated in Hive box");
        } else {
          print("Hive box is not open");
        }

        return true;
      } catch (e) {
        print("Error on attempt $attempt: $e");

        if (attempt >= maxRetries - 1) {
          print("Max retries reached. Rethrowing exception");
          rethrow;
        }

        attempt++;
        print("Waiting for 5 seconds before next attempt");
        await Future.delayed(const Duration(seconds: 5));
      }
    }

    print("Max retries reached, returning false");
    return false;
  }

  Future<void> _updateLocalAndRemoteFlags(
      CategoriesModel categoriesModel) async {
    print(
        "Updating local and remote flags for category: ${categoriesModel.categoryId}");

    final categoriesRef = firebaseService.getCategoriesCollectionRef();

    if (categoriesModel.categoryId == null ||
        categoriesModel.categoryId!.isEmpty) {
      print("Invalid categoryId. Throwing exception");
      throw Exception(
          'Invalid categoryId. The categoryId must not be null or empty.');
    }

    await categoriesRef
        .doc(categoriesModel.categoryId)
        .update({'isUploadedToServer': true});
    print("Updated category document in cloud");

    if (!HiveBoxService.categoryBox.isOpen) {
      print("Hive box is not open. Throwing exception");
      throw Exception(
          'Hive box is not open. Ensure that Hive is initialized and the box is open.');
    }

    categoriesModel.isUploadedToServer = true;
    print("Updating category in Hive box");

    await safeHiveOperation(HiveBoxService.categoryBox, (box) async {
      await box.put(categoriesModel.categoryId, categoriesModel);
    });

    print("Local and remote flags updated");
  }

  FutureOr<void> _fetchCategoriesWithProducts(
      FetchCategoriesWithProducts event, Emitter<CategoryState> emit) async {
    emit(FetchingCategoriesWithProducts());
    List<CategoriesModel> categories;
    try {
      categories = Hive.box<CategoriesModel>(HiveBoxes.categories.boxName)
          .values
          .toList();
      if (categories.isNotEmpty) {
        print('categories not empty $categories');
        await _updateLocalImages(categories);
        emit(CategoriesWithProductsFetched(categories: categories));
      } else {
        print('categories  empty $categories');
        var querySnapshot =
            await firebaseService.getCategoriesCollectionRef().get();
        var firestoreData = querySnapshot.docs
            .map((doc) =>
                CategoriesModel.fromMap(doc.data() as Map<String, dynamic>))
            .toList();
        print('firestoreData $firestoreData');
        if (HiveBoxService.categoryBox.isOpen) {
          await safeHiveOperation(HiveBoxService.categoryBox, (box) async {
            for (var category in firestoreData) {
              if (!box.containsKey(category.categoryId)) {
                await box.put(category.categoryId, category);
              } else {}
            }
            await _updateLocalImages(firestoreData);
            emit(CategoriesWithProductsFetched(categories: firestoreData));
          });
        } else {}
      }
    } catch (e) {
      emit(CategoriesWithProductsNotFetched(
          errorMessage: 'Error fetching categories: $e'));
    }
  }

  Future<void> _updateLocalImages(List<CategoriesModel> categories) async {
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

  Future<List<ProductsModel>> fetchProductsByCategory(String categoryId) async {
    List<ProductsModel> products = [];
    QuerySnapshot productSnapshot =
        await firebaseService.getProductsCollectionRef(categoryId).get();
    for (var productDoc in productSnapshot.docs) {
      Map<String, dynamic> productData =
          productDoc.data() as Map<String, dynamic>;
      ProductsModel product = ProductsModel(
        productId: productDoc.id,
        name: productData['name'] ?? '',
        categoryId: productData['category'] ?? '',
        description: productData['description'] ?? '',
        soldBy: productData['soldBy'] ?? '',
        unit: productData['unit'] ?? '',
        supplier: productData['supplier'] ?? '',
        minStockLevel: productData['minStockLevel'] ?? 0,
        localImagePath: productData['localImagePath'] ?? '',
      );
      List<ProductVariant> variants = [];
      QuerySnapshot variantSnapshot = await firebaseService
          .getVariantsCollectionRef(categoryId, productDoc.id)
          .where('productId', isEqualTo: productDoc.id)
          .get();
      for (var variantDoc in variantSnapshot.docs) {
        Map<String, dynamic> variantData =
            variantDoc.data() as Map<String, dynamic>;
        ProductVariant variant = ProductVariant(
            variantId: variantDoc.id,
            productId: productDoc.id,
            variantName: variantData['variantName'],
            price: double.parse(variantData['price'].toString()),
            cost: double.parse(variantData['price'].toString()),
            quantityAvailable: variantData['quantityAvailable'] ?? 0,
            isActive: true);
        variants.add(variant);
      }
      product.variants = variants;
      products.add(product);
    }
    return products;
  }

  FutureOr<void> _fetchProductForCategory(
      FetchProductsForSelectedCategory event,
      Emitter<CategoryState> emit) async {
    // for (var item in event.categories) {
    //   item.products?.clear();
    //   if (selectedCategory == item.categoryId) {
    //     item.products = await fetchProductsByCategory(selectedCategory!);
    //     emit(CategoriesWithProductsFetched(categories: event.categories));
    //   }
    // }
  }
}
