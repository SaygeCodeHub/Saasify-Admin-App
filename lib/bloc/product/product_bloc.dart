import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:saasify/bloc/product/product_event.dart';
import 'package:saasify/bloc/product/product_state.dart';
import 'package:saasify/cache/cache.dart';
import 'package:saasify/models/category/product_categories.dart';
import 'package:saasify/models/product/product_variant.dart';
import 'package:saasify/models/product/products.dart';
import 'package:saasify/utils/global.dart';
import 'package:saasify/utils/retrieve_image_from_firebase.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductState get initialState => ProductInitial();

  ProductBloc() : super(ProductInitial()) {
    on<AddProduct>(_addProduct);
    on<FetchProducts>(_viewProducts);
    on<SelectCategory>(_selectCategory);
    on<FetchProduct>(_fetchProductForVariant);
    on<AddVariant>(_addVariant);
  }

  FutureOr<void> _addProduct(
      AddProduct event, Emitter<ProductState> emit) async {
    try {
      emit(AddingProduct());
      if (kIsOfflineModule) {
        final productsBox = Hive.box<Products>('products');
        productsBox.add(Products(
            productId: '',
            name: event.productMap['name'] ?? '',
            category: event.productMap['category_id'] ?? '',
            description: event.productMap['description'] ?? '',
            supplier: event.productMap['supplier'] ?? '',
            tax: event.productMap['tax'] ?? 0.0,
            minStockLevel: int.parse(event.productMap['stock_level'] ?? 0),
            soldBy: '',
            unit: ''));
      } else {
        if (event.productMap.isNotEmpty) {
          _addProductToFirebase(event.productMap);
          emit(ProductAdded(successMessage: 'Product added successfully'));
        } else {
          emit(ProductNotAdded(errorMessage: 'Could not add the product.'));
        }
      }
    } catch (error) {
      emit(ProductNotAdded(errorMessage: 'Error adding product: $error'));
    }
  }

  FutureOr<void> _addProductToFirebase(Map productMap) async {
    final usersRef = FirebaseFirestore.instance
        .collection('users')
        .doc(CustomerCache.getUserId());
    CollectionReference companiesRef = usersRef.collection('companies');
    QuerySnapshot snapshot = await companiesRef.get();
    String companyId = '';
    for (var doc in snapshot.docs) {
      companyId = doc.id;
    }
    productMap['image'] =
        await RetrieveImageFromFirebase().getImage(productMap['image']);
    Products products = Products(
        productId: '',
        name: productMap['name'] ?? '',
        imageUrl: productMap['image'] ?? '',
        category: productMap['category_id'] ?? '',
        description: productMap['description'] ?? '',
        supplier: productMap['supplier'] ?? '',
        tax: productMap['tax'] ?? 0.0,
        minStockLevel: int.parse(productMap['stock_level'] ?? 0),
        soldBy: productMap['sold_by'] ?? '',
        unit: productMap['unit'] ?? '');
    Map<String, dynamic> productData = products.toMap();
    await companiesRef
        .doc(companyId)
        .collection('modules')
        .doc('pos')
        .collection('categories')
        .doc(productMap['category_id'])
        .collection('products')
        .add({...productData, 'dateAdded': FieldValue.serverTimestamp()}).then(
            (DocumentReference productDocRef) async {
      if (productMap['quantity'] != null || productMap['quantity'] != '') {
        ProductVariant productVariant = ProductVariant(
            variantId: '',
            productId: productDocRef.id,
            variantName: productMap['quantity'] ?? '',
            price: double.parse(productMap['price'] ?? 0.0),
            cost: double.parse(productMap['price'] ?? 0.0),
            quantityAvailable: int.parse(productMap['stock_level'] ?? 0),
            isActive: true);
        Map<String, dynamic> variantsData = productVariant.toMap();
        CollectionReference variantsRef = companiesRef
            .doc(companyId)
            .collection('modules')
            .doc('pos')
            .collection('categories')
            .doc(productMap['category_id'])
            .collection('products')
            .doc(productDocRef.id)
            .collection('variants');
        await variantsRef.add(variantsData);
      }
    });
  }

  FutureOr<void> _viewProducts(
      FetchProducts event, Emitter<ProductState> emit) async {
    try {
      if (kIsOfflineModule) {
        final productsBox = Hive.box<Products>('products');
        final List<Products> products = productsBox.values.toList();
        emit(ProductsFetched(
            products: products,
            categories: [],
            categoryId: '',
            selectedCategories: []));
      } else {
        emit(FetchingProducts());
        if (CustomerCache.getUserId() == null) {
          emit(ProductsCouldNotFetch(errorMessage: 'User not authenticated'));
        } else {
          List<ProductCategories> categories = [];

          final usersRef = FirebaseFirestore.instance
              .collection('users')
              .doc(CustomerCache.getUserId());
          QuerySnapshot querySnapshot = await usersRef
              .collection('companies')
              .doc(CustomerCache.getUserCompany())
              .collection('modules')
              .doc('pos')
              .collection('categories')
              .get();

          for (var doc in querySnapshot.docs) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            ProductCategories category = ProductCategories(
                name: data['name'],
                imagePath: data['image_path'],
                categoryId: doc.id);
            categories.add(category);
          }
          if (categories.isNotEmpty) {
            emit(ProductsFetched(
                categories: categories,
                products: [],
                categoryId: '',
                selectedCategories: []));
          } else {
            emit(ProductsCouldNotFetch(errorMessage: 'No categories found!'));
          }
        }
      }
    } catch (e) {
      emit(ProductsCouldNotFetch(
          errorMessage: 'Could not fetch products: ${e.toString()}'));
    }
  }

  FutureOr<void> _selectCategory(
      SelectCategory event, Emitter<ProductState> emit) async {
    try {
      List<Products> products = [];
      List selectedCategories = [];
      if (selectedCategories.contains(event.categoryId)) {
        selectedCategories.remove(event.categoryId);
      } else {
        selectedCategories.add(event.categoryId);
      }
      if (selectedCategories.isNotEmpty) {
        final usersRef = FirebaseFirestore.instance
            .collection('users')
            .doc(CustomerCache.getUserId());
        QuerySnapshot query = await usersRef
            .collection('companies')
            .doc(CustomerCache.getUserCompany())
            .collection('modules')
            .doc('pos')
            .collection('categories')
            .doc(event.categoryId)
            .collection('products')
            .get();
        for (var item in query.docs) {
          Map<String, dynamic> productData =
              item.data() as Map<String, dynamic>;
          Products product = Products(
              productId: item.id,
              name: productData['name'] ?? '',
              description: productData['description'] ?? '',
              tax: productData['tax'] ?? '',
              imageUrl: productData['imageUrl'] ?? '',
              isActive: true,
              supplier: productData['supplier'],
              minStockLevel: productData['minStockLevel'],
              dateAdded: DateTime.now(),
              category: event.categoryId,
              soldBy: '',
              unit: '');
          products.add(product);
          CollectionReference collectionReference = FirebaseFirestore.instance
              .collection('products')
              .doc(item.id)
              .collection('variants');
          collectionReference.get();
          if (products.isNotEmpty) {
            emit(ProductsFetched(
                categories: event.categories,
                products: products,
                categoryId: event.categoryId,
                selectedCategories: selectedCategories));
          } else {
            emit(ProductsCouldNotFetch(errorMessage: 'No products found'));
          }
        }
      }
    } catch (e) {
      e.toString();
    }
  }

  FutureOr<void> _fetchProductForVariant(
      FetchProduct event, Emitter<ProductState> emit) async {
    try {
      if (kIsOfflineModule) {
      } else {
        emit(FetchingProduct());
        String? userId = CustomerCache.getUserId();
        String? companyId = CustomerCache.getUserCompany();
        if (userId == null || companyId == null) {
          User? user = FirebaseAuth.instance.currentUser;
          CustomerCache.setUserId(user!.uid);
          final userRef =
              FirebaseFirestore.instance.collection('users').doc(userId);
          CollectionReference collectionReference =
              userRef.collection('companies');
          QuerySnapshot querySnapshot = await collectionReference.get();
          for (var item in querySnapshot.docs) {
            CustomerCache.setCompanyId(item.id);
          }
        } else {
          final userRef =
              FirebaseFirestore.instance.collection('users').doc(userId);
          CollectionReference categoryCollection = userRef
              .collection('companies')
              .doc(companyId)
              .collection('modules')
              .doc('pos')
              .collection('categories');
          DocumentSnapshot getCategory =
              await categoryCollection.doc(event.categoryId).get();
          String categoryName = getCategory.get('name');
          CollectionReference collectionReference = userRef
              .collection('companies')
              .doc(companyId)
              .collection('modules')
              .doc('pos')
              .collection('categories')
              .doc(event.categoryId)
              .collection('products');
          DocumentSnapshot getProduct =
              await collectionReference.doc(event.productId).get();
          Map<String, dynamic> getProductsData =
              getProduct.data() as Map<String, dynamic>;
          Products products = Products(
              productId: event.productId,
              name: getProductsData['name'],
              category: categoryName,
              imageUrl: getProductsData['imageUrl'] ?? '',
              description: getProductsData['description'] ?? '',
              supplier: getProductsData['supplier'] ?? '',
              minStockLevel: getProductsData['minStockLevel'] ?? 0,
              soldBy: getProductsData['soldBy'] ?? '',
              unit: getProductsData['unit'] ?? '');
          CollectionReference variantsCollection =
              collectionReference.doc(event.productId).collection('variants');
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
            products.variants.add(productVariant);
          }
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
        User? user = FirebaseAuth.instance.currentUser;
        String? userId = CustomerCache.getUserId();
        String? companyId = CustomerCache.getUserCompany();
        if (userId == null || companyId == null) {
          CustomerCache.setUserId(user!.uid);
          final userRef =
              FirebaseFirestore.instance.collection('users').doc(userId);
          CollectionReference collectionReference =
              userRef.collection('companies');
          QuerySnapshot querySnapshot = await collectionReference.get();
          for (var item in querySnapshot.docs) {
            CustomerCache.setCompanyId(item.id);
          }
        } else {
          ProductVariant productVariant = ProductVariant(
              variantId: '',
              productId: event.variantMap['product_id'],
              variantName: event.variantMap['quantity'] ?? '',
              price: double.parse(event.variantMap['price'] ?? 0.0),
              cost: double.parse(event.variantMap['price'] ?? 0.0),
              quantityAvailable:
                  int.parse(event.variantMap['stock_level'] ?? 0),
              isActive: true);
          Map<String, dynamic> variantData = productVariant.toMap();
          final userRef =
              FirebaseFirestore.instance.collection('users').doc(userId);
          CollectionReference productCollection = userRef
              .collection('companies')
              .doc(companyId)
              .collection('modules')
              .doc('pos')
              .collection('categories')
              .doc(event.variantMap['category_id'])
              .collection('products');
          await productCollection
              .doc(event.variantMap['product_id'])
              .collection('variants')
              .add(variantData)
              .whenComplete(() async {
            QuerySnapshot snapshot = await productCollection
                .doc(event.variantMap['product_id'])
                .collection('variants')
                .get();
            for (var item in snapshot.docs) {
              Map<String, dynamic> variantData =
                  item.data() as Map<String, dynamic>;
              if (variantData['price'] ==
                  double.parse(event.variantMap['price'])) {
                emit(VariantNotAdded(
                    errorMessage:
                        'The variant already exists. Do you still want to add?'));
              } else {
                emit(VariantAdded(
                    successMessage: 'Variant added successfully.'));
              }
            }
          });
        }
      }
    } catch (e) {
      emit(VariantNotAdded(
          errorMessage: 'Could not add variant: ${e.toString()}'));
    }
  }
}
