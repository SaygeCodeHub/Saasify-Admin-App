import 'package:get_it/get_it.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:saasify/cache/company_cache.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../cache/user_cache.dart';
import 'firebase_services_two.dart';

final GetIt getIt = GetIt.instance;

void setupServiceLocator() {
  getIt.registerLazySingleton<FirebaseFirestore>(
      () => FirebaseFirestore.instance);
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);

  getIt.registerLazySingleton<FirebaseServices>(() => FirebaseServices());
  getIt.registerSingletonAsync<SharedPreferences>(() async {
    return await SharedPreferences.getInstance();
  });
  getIt.registerSingleton<UserCache>(UserCache());
  getIt.registerSingleton<CompanyCache>(CompanyCache());
}
