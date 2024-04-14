import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:saasify/bloc/product/product_event.dart';
import 'package:saasify/bloc/product/product_state.dart';
import 'package:saasify/models/product/product_variant.dart';
import 'package:saasify/models/product/products.dart';
import 'package:saasify/services/firebase_services.dart';
import 'package:saasify/services/service_locator.dart';
import 'package:saasify/utils/global.dart';
import 'package:saasify/services/hive_box_service.dart';
import 'package:saasify/utils/retrieve_image_from_firebase.dart';
import 'package:saasify/utils/unique_id.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductState get initialState => ProductInitial();
  final firebaseService = getIt<FirebaseServices>();
  final Products products = getIt<Products>();
  final ProductVariant productVariant = getIt<ProductVariant>();

  ProductBloc() : super(ProductInitial()) {
    on<AddProduct>(_addProduct);
    on<FetchProduct>(_fetchProductForVariant);
    on<AddVariant>(_addVariant);
  }

  FutureOr<void> _addProduct(
      AddProduct event, Emitter<ProductState> emit) async {
    try {
      String productId = IDUtil.generateUUID();
      products.productId = productId;
      await HiveBoxService.productsBox.add(products).whenComplete(() async {
        try {
          if (!kIsCloudVersion) {
            emit(AddingProduct());
            (products.imageUrl != null)
                ? products.imageUrl = await RetrieveImageFromFirebase()
                    .getImage(products.imageUrl.toString())
                : '';
            await firebaseService
                .getProductsCollectionRef(products.categoryId.toString())
                .doc(products.productId)
                .set({
              ...products.toMap(),
              'dateAdded': FieldValue.serverTimestamp()
            }).then((value) async {
              productVariant.productId = products.productId;
              productVariant.variantName =
                  productVariant.quantityAvailable.toString();
              String variantId = IDUtil.generateUUID();
              productVariant.variantId = variantId;
              CollectionReference variantsRef =
                  firebaseService.getVariantsCollectionRef(
                      products.categoryId.toString(),
                      products.productId.toString());
              await variantsRef.doc(variantId).set(productVariant.toMap());
              if (productVariant.variantId!.isNotEmpty) {
                emit(
                    ProductAdded(successMessage: 'Product added successfully'));
              } else {
                emit(ProductNotAdded(
                    errorMessage: 'Could not add the product.'));
              }
            });
          } else {
            if (HiveBoxService.productsBox.isNotEmpty) {
              emit(ProductAdded(successMessage: 'Product added successfully'));
            } else {
              emit(ProductNotAdded(errorMessage: 'Could not add the product.'));
            }
          }
        } catch (e) {
          emit(ProductNotAdded(
              errorMessage:
                  'An error occurred while adding the product. Please try again!'));
        }
      });
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
        Products products = Products(
            productId: event.productId,
            name: getProductsData['name'],
            categoryId: categoryName,
            imageUrl: getProductsData['imageUrl'] ?? '',
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
