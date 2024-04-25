import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:saasify/bloc/product/product_event.dart';
import 'package:saasify/bloc/product/product_services.dart';
import 'package:saasify/bloc/product/product_state.dart';
import 'package:saasify/models/product/product_variant.dart';
import 'package:saasify/models/product/product_model.dart';
import 'package:saasify/services/firebase_services.dart';
import 'package:saasify/services/service_locator.dart';
import 'package:saasify/utils/global.dart';
import 'package:saasify/services/hive_box_service.dart';
import 'package:saasify/utils/retrieve_image_from_firebase.dart';
import 'package:saasify/utils/unique_id.dart';

import '../../enums/hive_boxes_enum.dart';
import '../../models/category/categories_model.dart';
import '../../services/safe_hive_operations.dart';
import '../category/category_services.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductState get initialState => ProductInitial();
  final firebaseService = getIt<FirebaseServices>();
  final ProductVariant productVariant = getIt<ProductVariant>();

  ProductBloc() : super(ProductInitial()) {
    on<AddProduct>(_addProduct);
    on<FetchProducts>(_fetchProductsWithCategories);
    on<AddVariant>(_addVariant);
  }

  FutureOr<void> _addProduct(
      AddProduct event, Emitter<ProductState> emit) async {
    emit(AddingProduct());
    try {
      event.products.productId = IDUtil.generateUUID();
      if (!await isProductPresent(event.products.name!)) {
        await _addProductToLocalDatabase(event.products);
        emit(ProductAdded(successMessage: 'Product added successfully'));
        if (kIsCloudVersion) {
          bool isUploadedToCloud = await _addProductToCloud(5, event.products);
          if (isUploadedToCloud) {
            await _updateLocalAndRemoteFlags(event.products);
          }
        }
      }
    } catch (error) {
      if (error is HiveError) {
        emit(ProductNotAdded(
            errorMessage:
                'An error occurred while adding the product. Please try again!'));
      } else {
        rethrow;
      }
    }
  }

  Future<void> _addProductToLocalDatabase(ProductsModel product) async {
    await safeHiveOperation(HiveBoxService.productsBox, (box) async {
      await box.put(product.productId, product);
    });
  }

  Future<bool> isProductPresent(String productName) async {
    final box = HiveBoxService.productsBox;
    return box.values.any((product) => product.name == productName);
  }

  Future<bool> _addProductToCloud(
      int maxRetries, ProductsModel productsModel) async {
    int attempt = 0;
    while (attempt < maxRetries) {
      try {
        String imagePath = productsModel.localImagePath ?? '';
        String serverImagePath = await RetrieveImageFromFirebase()
            .uploadImageAndGetUrl(imagePath, 'products');
        productsModel.serverImagePath = serverImagePath;
        final categoriesRef =
            firebaseService.getProductsCollectionRef(productsModel.categoryId!);
        await categoriesRef
            .doc(productsModel.productId)
            .set(productsModel.toMap());
        if (HiveBoxService.productsBox.isOpen) {
          await safeHiveOperation(HiveBoxService.productsBox, (box) async {
            await box.put(productsModel.productId, productsModel);
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

  Future<void> _updateLocalAndRemoteFlags(ProductsModel productsModel) async {
    final productReference =
        firebaseService.getProductsCollectionRef(productsModel.categoryId!);
    if (productsModel.productId == null || productsModel.productId!.isEmpty) {
      throw Exception(
          'Invalid productId. The productId must not be null or empty.');
    }
    await productReference
        .doc(productsModel.productId)
        .update({'isUploadedToServer': true});
    if (!HiveBoxService.productsBox.isOpen) {
      throw Exception(
          'Hive box is not open. Ensure that Hive is initialized and the box is open.');
    }
    productsModel.isUploadedToServer = true;
    await safeHiveOperation(HiveBoxService.productsBox, (box) async {
      await box.put(productsModel.productId, productsModel);
    });
  }

  Future<void> _fetchProductsWithCategories(
      FetchProducts event, Emitter<ProductState> emit) async {
    emit(FetchingProducts());
    try {
      final categoriesBox =
          Hive.box<CategoriesModel>(HiveBoxes.categories.boxName);
      final productsBox = Hive.box<ProductsModel>(HiveBoxes.products.boxName);
      if (await ProductService().checkIfCategoryExists()) {
        if (await ProductService().checkIfProductExists()) {
          Map<String, List<ProductsModel>> categoryProductsMap =
              await ProductService()
                  .fetchDataFromHive(categoriesBox, productsBox);
          emit(ProductsFetched(categoryWiseProducts: categoryProductsMap));
        } else {
          ProductService().fetchProductsFromServerAndSave(categoriesBox);
        }
      } else {
        await CategoryService()
            .fetchAndStoreCategoriesFromFirestore(fromCategory: false);
        add(FetchProducts());
      }
    } catch (e) {
      emit(ProductNotFetched(errorMessage: e.toString()));
    }
  }

  FutureOr<void> _addVariant(
      AddVariant event, Emitter<ProductState> emit) async {
    try {
      emit(AddingVariant());
      productVariant.productId = event.productsModel.productId;
      productVariant.serverImagePath = event.productsModel.serverImagePath;
      productVariant.localImagePath = event.productsModel.localImagePath;
      event.productVariant.variantId = IDUtil.generateUUID();
      final bool isVariantExists =
          await isVariantPresent(event.productVariant.variantName!);
      if (!isVariantExists) {
        await _addVariantToLocalDatabase(event.productVariant);
        emit(VariantAdded(successMessage: 'Variant added successfully'));
        if (kIsCloudVersion) {
          bool isUploadedToCloud = await _addVariantToCloud(
              5, event.productVariant, event.productsModel);
          if (isUploadedToCloud) {
            await _updateVariantLocalAndRemoteFlags(
                event.productVariant, event.productsModel);
          }
        }
      } else {
        emit(VariantNotAdded(errorMessage: 'Variant already exists.'));
      }
    } catch (e) {
      emit(VariantNotAdded(
          errorMessage: 'Could not add variant: ${e.toString()}'));
    }
  }

  Future<void> _addVariantToLocalDatabase(ProductVariant productVariant) async {
    await safeHiveOperation(HiveBoxService.productVariantBox, (box) async {
      await box.put(productVariant.variantId, productVariant);
    });
  }

  Future<bool> isVariantPresent(String variantName) async {
    final box = HiveBoxService.productVariantBox;
    return box.values.any((variant) => variant.variantName == variantName);
  }

  Future<bool> _addVariantToCloud(int maxRetries, ProductVariant productVariant,
      ProductsModel productsModel) async {
    int attempt = 0;
    while (attempt < maxRetries) {
      try {
        final productDocRef = firebaseService.getProductDocRef(
            productsModel.categoryId!, productsModel.productId!);
        final productDocSnapshot = await productDocRef.get();

        if (!productDocSnapshot.exists) {
          await productDocRef.set(productsModel.toMap());
        }

        final variantRef = firebaseService
            .getVariantsCollectionRef(
                productsModel.categoryId!, productsModel.productId!)
            .doc(productVariant.variantId);
        await variantRef.set(productVariant.toMap());

        if (HiveBoxService.productVariantBox.isOpen) {
          await safeHiveOperation(HiveBoxService.productVariantBox,
              (box) async {
            await box.put(productVariant.variantId, productVariant);
          });
        }
        return true;
      } catch (e) {
        if (attempt >= maxRetries - 1) rethrow;
        attempt++;
        await Future.delayed(const Duration(seconds: 5));
      }
    }
    return false;
  }

  Future<void> _updateVariantLocalAndRemoteFlags(
      ProductVariant productVariant, ProductsModel productsModel) async {
    final productReference = firebaseService.getVariantsCollectionRef(
      productsModel.categoryId!,
      productVariant.productId!,
    );
    await productReference
        .doc(productVariant.variantId)
        .update({'isUploadedToServer': true});
    if (!HiveBoxService.productVariantBox.isOpen) {
      throw Exception(
          'Hive box is not open. Ensure that Hive is initialized and the box is open.');
    }
    productVariant.isUploadedToServer = true;
    await safeHiveOperation(HiveBoxService.productVariantBox, (box) async {
      await box.put(productVariant.variantId, productVariant);
    });
  }
}
