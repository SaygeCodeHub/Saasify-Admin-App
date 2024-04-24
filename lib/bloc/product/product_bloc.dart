import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:saasify/bloc/product/product_event.dart';
import 'package:saasify/bloc/product/product_state.dart';
import 'package:saasify/models/product/product_variant.dart';
import 'package:saasify/models/product/product_model.dart';
import 'package:saasify/services/firebase_services.dart';
import 'package:saasify/services/service_locator.dart';
import 'package:saasify/utils/global.dart';
import 'package:saasify/services/hive_box_service.dart';
import 'package:saasify/utils/retrieve_image_from_firebase.dart';
import 'package:saasify/utils/unique_id.dart';

import '../../services/safe_hive_operations.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductState get initialState => ProductInitial();
  final firebaseService = getIt<FirebaseServices>();
  final ProductVariant productVariant = getIt<ProductVariant>();

  ProductBloc() : super(ProductInitial()) {
    on<AddProduct>(_addProduct);
    on<FetchProduct>(_fetchProductForVariant);
    on<AddVariant>(_addVariant);
  }

  FutureOr<void> _addProduct(
      AddProduct event, Emitter<ProductState> emit) async {
    emit(AddingProduct());
    try {
      event.products.productId = IDUtil.generateUUID();
      if (!await isProductPresent(event.products.name!)) {
        await _addToLocalDatabase(event.products);
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

  Future<void> _addToLocalDatabase(ProductsModel product) async {
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
        String serverImagePath =
            await RetrieveImageFromFirebase().uploadImageAndGetUrl(imagePath,'products');
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

  FutureOr<void> _fetchProductForVariant(
      FetchProduct event, Emitter<ProductState> emit) async {
    try {
      if (kIsCloudVersion) {
      } else {
        emit(FetchingProduct());
        DocumentSnapshot getCategory =
            await firebaseService.getCategoriesDocRef(event.categoryId).get();
        String categoryName = getCategory.get('name');
        DocumentSnapshot getProduct = await firebaseService
            .getProductDocRef(event.categoryId, event.productId)
            .get();
        Map<String, dynamic> getProductsData =
            getProduct.data() as Map<String, dynamic>;
        ProductsModel products = ProductsModel(
            productId: event.productId,
            name: getProductsData['name'],
            categoryId: categoryName,
            localImagePath: getProductsData['imageUrl'] ?? '',
            description: getProductsData['description'] ?? '',
            supplier: getProductsData['supplier'] ?? '',
            minStockLevel: getProductsData['minStockLevel'] ?? 0,
            soldBy: getProductsData['soldBy'] ?? '',
            unit: getProductsData['unit'] ?? '');
        CollectionReference variantsCollection = firebaseService
            .getVariantsCollectionRef(event.categoryId, event.productId);
        QuerySnapshot variantData = await variantsCollection.get();
        for (var item in variantData.docs) {
          Map<String, dynamic> variantsMap =
              item.data() as Map<String, dynamic>;
          ProductVariant productVariant = ProductVariant(
              variantId: item.id,
              productId: event.productId,
              variantName: variantsMap['variantName'],
              price: variantsMap['price'],
              cost: variantsMap['price'],
              quantityAvailable: variantsMap['quantityAvailable'],
              isActive: true);
          products.variants?.add(productVariant);

          if (getProductsData.isNotEmpty) {
            emit(ProductFetched(products: products));
          } else {
            emit(ProductNotFetched(errorMessage: 'No product found!'));
          }
        }
      }
    } catch (e) {
      emit(ProductNotFetched(errorMessage: e.toString()));
    }
  }

  FutureOr<void> _addVariant(
      AddVariant event, Emitter<ProductState> emit) async {
    try {
      emit(AddingVariant());
      DocumentReference variantRef = await firebaseService
          .getVariantsCollectionRef(
              event.categoryId, productVariant.productId.toString())
          .add(productVariant.toMap());
      if (variantRef.id.isEmpty) {
        emit(VariantNotAdded(errorMessage: 'Could not add Variant'));
      } else {
        emit(VariantAdded(successMessage: 'Variant added successfully.'));
      }
    } catch (e) {
      emit(VariantNotAdded(
          errorMessage: 'Could not add variant: ${e.toString()}'));
    }
  }
}
