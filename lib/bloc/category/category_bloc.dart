import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:saasify/bloc/category/category_event.dart';
import 'package:saasify/bloc/category/category_state.dart';
import 'package:saasify/models/category/product_categories.dart';
import 'package:saasify/utils/global.dart';
import 'package:saasify/utils/retrieve_image_from_firebase.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  CategoryState get initialState => CategoryInitial();

  CategoryBloc() : super(CategoryInitial()) {
    on<AddCategory>(_addCategory);
    on<FetchCategories>(_fetchCategories);
  }

  String selectedCategory = '';

  FutureOr<void> _addCategory(
      AddCategory event, Emitter<CategoryState> emit) async {
    try {
      if (kIsOfflineModule) {
        final category = ProductCategories(
            name: event.addCategoryMap['category_name'],
            imagePath: event.addCategoryMap['image']);
        final categoriesBox = Hive.box<ProductCategories>('categories');
        await categoriesBox.add(category).whenComplete(() {
          emit(CategoryAdded(successMessage: 'Category added successfully'));
        });
      } else {
        emit(AddingCategory());
        User? user = FirebaseAuth.instance.currentUser;
        if (user == null || user.uid.isEmpty) {
          emit(CategoryNotAdded(errorMessage: 'User not authenticated.'));
        } else {
          String userId = user.uid;
          ProductCategories category = ProductCategories(
              name: event.addCategoryMap['category_name'],
              imagePath: (event.addCategoryMap['image'] != null)
                  ? await RetrieveImageFromFirebase()
                      .getImage(event.addCategoryMap['image'])
                  : '');
          Map<String, dynamic> categoryData = category.toMap();
          categoryData.remove('category_id');
          final usersRef =
              FirebaseFirestore.instance.collection('users').doc(userId);
          CollectionReference companiesRef = usersRef.collection('companies');
          QuerySnapshot snapshot = await companiesRef.get();
          String companyId = '';
          for (var doc in snapshot.docs) {
            companyId = doc.id;
          }
          final categoriesRef = usersRef
              .collection('companies')
              .doc(companyId)
              .collection('modules')
              .doc('pos')
              .collection('categories');
          QuerySnapshot categorySnapshot = await categoriesRef
              .where('name', isEqualTo: categoryData['name'])
              .get();
          if (categorySnapshot.docs.isNotEmpty) {
            emit(CategoryNotAdded(
                errorMessage:
                    'Category already exists. Please add another category!'));
          } else {
            categoriesRef.add(categoryData);
            emit(CategoryAdded(successMessage: 'Category added successfully'));
          }
        }
      }
    } catch (e) {
      emit(CategoryNotAdded(errorMessage: 'Error adding category: $e'));
    }
  }

  FutureOr<void> _fetchCategories(
      FetchCategories event, Emitter<CategoryState> emit) async {
    List<ProductCategories> categories = [];
    // try {
    if (kIsOfflineModule) {
      categories = Hive.box<ProductCategories>('categories').values.toList();
      if (categories.isNotEmpty) {
        emit(CategoriesFetched(categories: categories));
      }
    } else {
      emit(FetchingCategories());
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        emit(CategoriesNotFetched(errorMessage: 'User not authenticated.'));
      } else {
        String userId = user.uid;
        String companyId = '';
        final usersRef =
            FirebaseFirestore.instance.collection('users').doc(userId);
        CollectionReference companiesRef = usersRef.collection('companies');
        QuerySnapshot snapshot = await companiesRef.get();
        for (var doc in snapshot.docs) {
          companyId = doc.id;
        }
        if (companyId.isNotEmpty) {
          QuerySnapshot querySnapshot = await usersRef
              .collection('companies')
              .doc(companyId)
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
            selectedCategory = categories.last.categoryId ?? '';
            emit(CategoriesFetched(categories: categories));
          } else {
            emit(CategoriesNotFetched(errorMessage: 'No categories found!'));
          }
        }
      }
    }
    // } catch (e) {
    //   emit(CategoriesNotFetched(errorMessage: 'Error fetching categories: $e'));
    // }
  }
}
