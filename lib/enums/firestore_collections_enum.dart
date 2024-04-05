enum FirestoreCollection {
  users,
  companies,
  pos,
  modules,
  categories,
  products,
  variants,
  orders,
  customers,
  suppliers,
  coupons
}

extension FirestoreCollectionExtension on FirestoreCollection {
  String get collectionName {
    switch (this) {
      case FirestoreCollection.users:
        return "users";
      case FirestoreCollection.companies:
        return "companies";
      case FirestoreCollection.pos:
        return "pos";
      case FirestoreCollection.modules:
        return "modules";
      case FirestoreCollection.categories:
        return "categories";
      case FirestoreCollection.products:
        return "products";
      case FirestoreCollection.variants:
        return "variants";
      case FirestoreCollection.orders:
        return "orders";
      case FirestoreCollection.customers:
        return "customers";
      case FirestoreCollection.suppliers:
        return "suppliers";
      case FirestoreCollection.coupons:
        return "coupons";
      default:
        return "";
    }
  }
}
