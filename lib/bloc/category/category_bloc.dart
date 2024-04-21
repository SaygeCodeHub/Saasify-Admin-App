import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:saasify/bloc/category/category_event.dart';
import 'package:saasify/bloc/category/category_state.dart';
import 'package:saasify/models/category/categories_model.dart';
import 'package:saasify/models/product/product_variant.dart';
import 'package:saasify/models/product/products.dart';
import 'package:saasify/services/firebase_services.dart';
import 'package:saasify/services/service_locator.dart';
import 'package:saasify/utils/global.dart';
import 'package:saasify/services/hive_box_service.dart';
import 'package:saasify/utils/retrieve_image_from_firebase.dart';
import 'package:saasify/utils/unique_id.dart';
import '../../services/safe_hive_operations.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  CategoryState get initialState => CategoryInitial();

  final firebaseService = getIt<FirebaseServices>();

  CategoryBloc() : super(CategoryInitial()) {
    on<AddCategory>(_addCategory);
    on<FetchCategoriesWithProducts>(_fetchCategoriesWithProducts);
    on<FetchProductsForSelectedCategory>(_fetchProductForCategory);
  }

  Map<dynamic, dynamic> categoryInputData = {};
  String selectedCategory = '';

  FutureOr<void> _addCategory(
      AddCategory event, Emitter<CategoryState> emit) async {
    try {
      emit(AddingCategory());
      event.categoriesModel.categoryId = IDUtil.generateUUID();
      if (!await isCategoryNamePresent(event.categoriesModel.name!)) {
        await safeHiveOperation(HiveBoxService.categoryBox, (box) async {
          await box.put(
              event.categoriesModel.categoryId, event.categoriesModel);
        });
        emit(CategoryAdded(successMessage: 'Category added successfully'));
        if (kIsCloudVersion) {
          bool isUploadedToCloud =
              await _addCategoryToCloud(5, event.categoriesModel);
          if (isUploadedToCloud) {
            await _updateLocalAndRemoteFlags(event.categoriesModel);
          }
        }
      } else {
        emit(CategoryNotAdded(errorMessage: 'Category already exists.'));
      }
    } catch (e) {
      emit(CategoryNotAdded(
          errorMessage: 'Could not add category. Please try again!'));
    }
  }

  Future<bool> isCategoryNamePresent(String categoryName) async {
    final box = HiveBoxService.categoryBox;
    return box.values.any((category) => category.name == categoryName);
  }

  Future<bool> _addCategoryToCloud(
      int maxRetries, CategoriesModel categoriesModel) async {
    int attempt = 0;
    while (attempt < maxRetries) {
      try {
        String imagePath = categoriesModel.imagePath ?? '';
        String serverImagePath =
            await RetrieveImageFromFirebase().getImage(imagePath);
        categoriesModel.serverImagePath = serverImagePath;
        final categoriesRef = firebaseService.getCategoriesCollectionRef();
        await categoriesRef
            .doc(categoriesModel.categoryId)
            .set(categoriesModel.toMap());
        if (HiveBoxService.categoryBox.isOpen) {
          await safeHiveOperation(HiveBoxService.categoryBox, (box) async {
            await box.put(categoriesModel.categoryId, categoriesModel);
          });
        } else {}

        return true;
      } catch (e) {
        if (attempt >= maxRetries - 1) rethrow;
        attempt++;
        await Future.delayed(const Duration(seconds: 5));
      }
    }
    return false;
  }

  Future<void> _updateLocalAndRemoteFlags(
      CategoriesModel categoriesModel) async {
    final categoriesRef = firebaseService.getCategoriesCollectionRef();
    if (categoriesModel.categoryId == null ||
        categoriesModel.categoryId!.isEmpty) {
      throw Exception(
          'Invalid categoryId. The categoryId must not be null or empty.');
    }
    await categoriesRef
        .doc(categoriesModel.categoryId)
        .update({'isUploadedToServer': true});
    if (!HiveBoxService.categoryBox.isOpen) {
      throw Exception(
          'Hive box is not open. Ensure that Hive is initialized and the box is open.');
    }
    categoriesModel.isUploadedToServer = true;
    await safeHiveOperation(HiveBoxService.categoryBox, (box) async {
      await box.put(categoriesModel.categoryId, categoriesModel);
    });
  }

  FutureOr<void> _fetchCategoriesWithProducts(
      FetchCategoriesWithProducts event, Emitter<CategoryState> emit) async {
    emit(FetchingCategoriesWithProducts());
    try {
      List<CategoriesModel> categories =
          Hive.box<CategoriesModel>('categories').values.toList();
      if (categories.isNotEmpty) {
        emit(CategoriesWithProductsFetched(categories: categories));
      }
    } catch (e) {
      emit(CategoriesWithProductsNotFetched(
          errorMessage: 'Error fetching categories: $e'));
    }
  }

  Future<List<Products>> fetchProductsByCategory(String categoryId) async {
    List<Products> products = [];
    QuerySnapshot productSnapshot =
        await firebaseService.getProductsCollectionRef(categoryId).get();
    for (var productDoc in productSnapshot.docs) {
      Map<String, dynamic> productData =
          productDoc.data() as Map<String, dynamic>;
      Products product = Products(
        productId: productDoc.id,
        name: productData['name'] ?? '',
        categoryId: productData['category'] ?? '',
        description: productData['description'] ?? '',
        soldBy: productData['soldBy'] ?? '',
        unit: productData['unit'] ?? '',
        supplier: productData['supplier'] ?? '',
        minStockLevel: productData['minStockLevel'] ?? 0,
        imageUrl: productData['imageUrl'] ?? '',
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
    for (var item in event.categories) {
      item.products?.clear();
      if (selectedCategory == item.categoryId) {
        item.products = await fetchProductsByCategory(selectedCategory);
        emit(CategoriesWithProductsFetched(categories: event.categories));
      }
    }
  }
}
