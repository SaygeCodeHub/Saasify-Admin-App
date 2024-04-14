import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:saasify/enums/hive_boxes_enum.dart';
import 'package:saasify/models/couponsAndDiscounts/coupons_and_discounts.dart';
import 'package:saasify/models/supplier/add_supplier_model.dart';
import 'package:saasify/models/user/user_details.dart';
import '../models/category/categories_model.dart';
import '../models/customer/add_customer_model.dart';
import '../models/product/product_variant.dart';
import '../models/product/products.dart';

Future<void> setupHive() async {
  final appDocumentDirectory =
      await path_provider.getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocumentDirectory.path);

  Hive
    ..registerAdapter(UserDetailsAdapter())
    ..registerAdapter(CategoriesModelAdapter())
    ..registerAdapter(ProductsAdapter())
    ..registerAdapter(AddCustomerModelAdapter())
    ..registerAdapter(ProductVariantAdapter())
    ..registerAdapter(AddSupplierModelAdapter())
    ..registerAdapter(CouponsAndDiscountsModelAdapter());

  await Future.wait([
    Hive.openBox<UserDetails>('userDetails'),
    Hive.openBox<CategoriesModel>(HiveBoxes.categories.boxName),
    Hive.openBox<Products>(HiveBoxes.products.boxName),
    Hive.openBox<Map<String, dynamic>>('cartData'),
    Hive.openBox<AddCustomerModel>(HiveBoxes.customers.boxName),
    Hive.openBox<AddSupplierModel>(HiveBoxes.suppliers.boxName),
    Hive.openBox<CouponsAndDiscountsModel>(HiveBoxes.coupons.boxName)
  ]);
}
