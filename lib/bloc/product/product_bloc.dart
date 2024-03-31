import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
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
    on<ViewProducts>(_viewProducts);
    on<SelectCategory>(_selectCategory);
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
            minStockLevel: int.parse(event.productMap['stock_level'] ?? 0)));
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
        minStockLevel: int.parse(productMap['stock_level'] ?? 0));
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
            variantId: 0,
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
      ViewProducts event, Emitter<ProductState> emit) async {
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
              category: event.categoryId);
          products.add(product);
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
}
