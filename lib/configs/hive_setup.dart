import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:saasify/models/user/user_details.dart';
import '../models/category/product_categories.dart';
import '../models/customer/add_customer_model.dart';
import '../models/product/product_variant.dart';
import '../models/product/products.dart';

Future<void> setupHive() async {
  final appDocumentDirectory =
      await path_provider.getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocumentDirectory.path);

  // Register adapters
  Hive
    ..registerAdapter(UserDetailsAdapter())
    ..registerAdapter(ProductCategoriesAdapter())
    ..registerAdapter(ProductsAdapter())
    ..registerAdapter(AddCustomerModelAdapter())
    ..registerAdapter(ProductVariantAdapter());

  // Open boxes
  await Future.wait([
    Hive.openBox<UserDetails>('userDetails'),
    Hive.openBox<ProductCategories>('categories'),
    Hive.openBox<Products>('products'),
    Hive.openBox<Products>('customers'),
    Hive.openBox<Map<String, dynamic>>('cartData'),
  ]);
}
