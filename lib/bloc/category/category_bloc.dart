import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:saasify/bloc/category/category_event.dart';
import 'package:saasify/bloc/category/category_services.dart';
import 'package:saasify/bloc/category/category_state.dart';
import 'package:saasify/models/category/categories_model.dart';
import 'package:saasify/services/firebase_services.dart';
import 'package:saasify/services/service_locator.dart';
import 'package:saasify/utils/global.dart';
import 'package:saasify/services/hive_box_service.dart';
import 'package:saasify/utils/retrieve_image_from_firebase.dart';
import 'package:saasify/utils/unique_id.dart';
import '../../enums/hive_boxes_enum.dart';
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
  String? selectedCategory;

  FutureOr<void> _addCategory(
      AddCategory event, Emitter<CategoryState> emit) async {
    try {
      emit(AddingCategory());
      event.categoriesModel.categoryId = IDUtil.generateUUID();
      bool isNamePresent =
          await isCategoryNamePresent(event.categoriesModel.name!);
      if (!isNamePresent) {
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
        String imagePath = categoriesModel.localImagePath ?? '';

        String serverImagePath = await RetrieveImageFromFirebase()
            .uploadImageAndGetUrl(imagePath, 'categories');

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
        if (attempt >= maxRetries - 1) {
          rethrow;
        }

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
    List<CategoriesModel> categories;
    try {
      categories = Hive.box<CategoriesModel>(HiveBoxes.categories.boxName)
          .values
          .toList();
      if (categories.isNotEmpty) {
        emit(CategoriesWithProductsFetched(categories: categories));
      } else {
        await CategoryService().fetchAndStoreCategoriesFromFirestore(
            emit: emit, fromCategory: true);
      }
    } catch (e) {
      emit(CategoriesWithProductsNotFetched(
          errorMessage: 'Error fetching categories: $e'));
    }
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
