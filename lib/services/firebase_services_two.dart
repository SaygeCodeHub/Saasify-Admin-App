import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:saasify/cache/company_cache.dart';
import 'package:saasify/cache/user_cache.dart';
import 'package:saasify/enums/firestore_collections_enum.dart';
import 'package:saasify/services/service_locator.dart';

class FirebaseServices {
  FirebaseFirestore get firestore => getIt<FirebaseFirestore>();

  FirebaseAuth get auth => getIt<FirebaseAuth>();

  CollectionReference get usersCollection =>
      firestore.collection(FirestoreCollection.users.collectionName);

  DocumentReference<Map<String, dynamic>> get usersRef => firestore
      .collection(FirestoreCollection.users.collectionName)
      .doc(UserCache.getUserId());

  DocumentReference userDocRef() => usersCollection.doc(UserCache.getUserId());

  CollectionReference getCompaniesCollectionRef() =>
      usersRef.collection(FirestoreCollection.companies.collectionName);

  DocumentReference<Map<String, dynamic>> getCompaniesDocRef() => usersRef
      .collection(FirestoreCollection.companies.collectionName)
      .doc(CompanyCache.getCompanyId());

  CollectionReference getModulesCollectionRef() => getCompaniesDocRef()
      .collection(FirestoreCollection.modules.collectionName);

  CollectionReference getCategoriesCollectionRef() => getCompaniesDocRef()
      .collection(FirestoreCollection.modules.collectionName)
      .doc(FirestoreCollection.pos.collectionName)
      .collection(FirestoreCollection.categories.collectionName);

  DocumentReference<Map<String, dynamic>> getCategoriesDocRef(
          String categoryId) =>
      getModulesCollectionRef()
          .doc(FirestoreCollection.pos.collectionName)
          .collection(FirestoreCollection.categories.collectionName)
          .doc(categoryId);

  CollectionReference getProductsCollectionRef(String categoryId) =>
      getCategoriesDocRef(categoryId)
          .collection(FirestoreCollection.products.collectionName);

  DocumentReference<Object?> getProductDocRef(
          String categoryId, String productId) =>
      getProductsCollectionRef(categoryId).doc(productId);

  CollectionReference getVariantsCollectionRef(
          String categoryId, String productId) =>
      getProductDocRef(categoryId, productId)
          .collection(FirestoreCollection.variants.collectionName);
}
