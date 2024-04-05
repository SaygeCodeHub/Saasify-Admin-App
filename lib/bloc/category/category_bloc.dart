import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:saasify/bloc/category/category_event.dart';
import 'package:saasify/bloc/category/category_state.dart';
import 'package:saasify/models/category/product_categories.dart';
import 'package:saasify/models/product/product_variant.dart';
import 'package:saasify/models/product/products.dart';
import 'package:saasify/services/firebase_services_two.dart';
import 'package:saasify/services/service_locator.dart';
import 'package:saasify/utils/global.dart';
import 'package:saasify/utils/retrieve_image_from_firebase.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  CategoryState get initialState => CategoryInitial();
  final ProductCategories productCategories = getIt<ProductCategories>();
  final firebaseService = getIt<FirebaseServices>();

  CategoryBloc() : super(CategoryInitial()) {
    on<AddCategory>(_addCategory);
    on<FetchCategoriesWithProducts>(_fetchCategoriesWithProducts);
    on<FetchProductsForSelectedCategory>(_fetchProductForCategory);
  }

  String selectedCategory = '';

  FutureOr<void> _addCategory(
      AddCategory event, Emitter<CategoryState> emit) async {
    try {
      if (kIsOfflineModule) {
        final categoriesBox = Hive.box<ProductCategories>('categories');
        await categoriesBox.add(productCategories).whenComplete(() {
          emit(CategoryAdded(successMessage: 'Category added successfully'));
        });
      } else {
        emit(AddingCategory());
        productCategories.imagePath = await RetrieveImageFromFirebase()
            .getImage(productCategories.imagePath ?? '');
        final categoriesRef = firebaseService.getCategoriesCollectionRef();
        QuerySnapshot categorySnapshot = await categoriesRef
            .where('name', isEqualTo: productCategories.name)
            .get();
        if (categorySnapshot.docs.isNotEmpty) {
          emit(CategoryNotAdded(
              errorMessage:
                  'Category already exists. Please add another category!'));
        } else {
          DocumentReference categoryDocRef =
              await categoriesRef.add(productCategories.toMap());
          if (categoryDocRef.id.isNotEmpty) {
            emit(CategoryAdded(successMessage: 'Category added successfully'));
          } else {
            emit(CategoryNotAdded(
                errorMessage: 'Could not add category. Please try again!'));
          }
        }
      }
    } catch (e) {
      emit(CategoryNotAdded(errorMessage: 'Error adding category: $e'));
    }
  }

  FutureOr<void> _fetchCategoriesWithProducts(
      FetchCategoriesWithProducts event, Emitter<CategoryState> emit) async {
    List<ProductCategories> categories = [];
    try {
      if (kIsOfflineModule) {
        categories = Hive.box<ProductCategories>('categories').values.toList();
        if (categories.isNotEmpty) {
          emit(CategoriesWithProductsFetched(categories: categories));
        }
      } else {
        emit(FetchingCategoriesWithProducts());
        QuerySnapshot querySnapshot =
            await firebaseService.getCategoriesCollectionRef().get();
        for (var doc in querySnapshot.docs) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          ProductCategories category = ProductCategories(
              name: data['name'],
              imagePath: data['image_path'] ?? '',
              categoryId: doc.id);
          categories.add(category);
        }
        selectedCategory = querySnapshot.docs.first.id;
        if (selectedCategory.isNotEmpty) {
          categories
                  .where((element) => element.categoryId == selectedCategory)
                  .first
                  .products =
              await fetchProductsByCategory(selectedCategory).whenComplete(() =>
                  emit(CategoriesWithProductsFetched(categories: categories)));
        }
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
