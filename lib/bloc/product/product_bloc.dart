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
import 'package:saasify/utils/retrieve_image_from_firebase.dart';

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

  bool showCart = false;
  Map<String, dynamic> billDetailsMap = {};

  FutureOr<void> _addProduct(
      AddProduct event, Emitter<ProductState> emit) async {
    try {
      if (kIsOfflineModule) {
        final productsBox = Hive.box<Products>('products');
        productsBox.add(products);
      } else {
        emit(AddingProduct());
        await _addProductToFirebase(emit);
      }
    } catch (error) {
      emit(ProductNotAdded(errorMessage: 'Error adding product: $error'));
    }
  }

  Future<void> _addProductToFirebase(Emitter<ProductState> emit) async {
    (products.imageUrl != null)
        ? products.imageUrl = await RetrieveImageFromFirebase()
            .getImage(products.imageUrl.toString())
        : '';
    await firebaseService
        .getProductsCollectionRef(products.categoryId.toString())
        .add({
      ...products.toMap(),
      'dateAdded': FieldValue.serverTimestamp()
    }).then((DocumentReference productDocRef) async {
      productVariant.productId = productDocRef.id;
      productVariant.variantName = productVariant.quantityAvailable.toString();
      CollectionReference variantsRef =
          firebaseService.getVariantsCollectionRef(
              products.categoryId.toString(), productDocRef.id);
      DocumentReference variantRef =
          await variantsRef.add(productVariant.toMap());
      if (variantRef.id.isNotEmpty) {
        emit(ProductAdded(successMessage: 'Product added successfully'));
      } else {
        emit(ProductNotAdded(errorMessage: 'Could not add the product.'));
      }
    });
  }

  FutureOr<void> _fetchProductForVariant(
      FetchProduct event, Emitter<ProductState> emit) async {
    try {
      if (kIsOfflineModule) {
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
      if (kIsOfflineModule) {
      } else {
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
      }
    } catch (e) {
      emit(VariantNotAdded(
          errorMessage: 'Could not add variant: ${e.toString()}'));
    }
  }
}
