import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:saasify/cache/cache.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  DocumentReference<Map<String, dynamic>> get usersRef =>
      _firestore.collection('users').doc(CustomerCache.getUserId());

  CollectionReference getCompaniesCollectionRef() =>
      usersRef.collection('companies');

  DocumentReference<Map<String, dynamic>> getCompaniesDocRef(
          String companyId) =>
      usersRef.collection('companies').doc(companyId);

  CollectionReference getModulesCollectionRef(String companyId) =>
      getCompaniesDocRef(companyId).collection('modules');

  CollectionReference getCategoriesCollectionRef(String companyId) =>
      getCompaniesDocRef(companyId)
          .collection('modules')
          .doc('pos')
          .collection('categories');

  DocumentReference<Map<String, dynamic>> getCategoriesDocRef(
          String companyId, String categoryId) =>
      getModulesCollectionRef(companyId)
          .doc('pos')
          .collection('categories')
          .doc(categoryId);

  CollectionReference getProductsCollectionRef(
          String companyId, String categoryId) =>
      getCategoriesDocRef(companyId, categoryId).collection('products');
}
