import 'package:hive_flutter/hive_flutter.dart';
import 'package:saasify/enums/hive_boxes_enum.dart';
import 'package:saasify/models/category/categories_model.dart';
import 'package:saasify/models/couponsAndDiscounts/coupons_and_discounts.dart';
import 'package:saasify/models/customer/add_customer_model.dart';
import 'package:saasify/models/product/products.dart';
import 'package:saasify/models/supplier/add_supplier_model.dart';

class HiveBoxService {
  static final categoryBox =
      Hive.box<CategoriesModel>(HiveBoxes.categories.boxName);

  static final productsBox = Hive.box<Products>(HiveBoxes.products.boxName);

  static final customersBox =
      Hive.box<AddCustomerModel>(HiveBoxes.customers.boxName);

  static final suppliersBox =
      Hive.box<AddSupplierModel>(HiveBoxes.suppliers.boxName);

  static final couponsBox =
      Hive.box<CouponsAndDiscountsModel>(HiveBoxes.coupons.boxName);
}
