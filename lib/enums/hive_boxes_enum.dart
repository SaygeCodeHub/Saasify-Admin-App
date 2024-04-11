enum HiveBoxes { categories, products, customers, suppliers, coupons }

extension HiveBoxesCollection on HiveBoxes {
  String get boxName {
    switch (this) {
      case HiveBoxes.categories:
        return 'categories';
      case HiveBoxes.products:
        return 'products';
      case HiveBoxes.customers:
        return 'customers';
      case HiveBoxes.suppliers:
        return 'suppliers';
      case HiveBoxes.coupons:
        return 'coupons';
      default:
        return '';
    }
  }
}
