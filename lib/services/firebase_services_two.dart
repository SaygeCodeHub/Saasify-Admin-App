import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:saasify/services/service_locator.dart';

import '../cache/cache.dart';

class FirebaseServices {
  FirebaseFirestore get firestore => getIt<FirebaseFirestore>();
  FirebaseAuth get auth => getIt<FirebaseAuth>();

  CollectionReference get usersCollection => firestore.collection('users');

  DocumentReference<Map<String, dynamic>> get usersRef =>
      firestore.collection('users').doc(CustomerCache.getUserId());

  DocumentReference userDocRef(String? userId) => usersCollection.doc(userId);
}
