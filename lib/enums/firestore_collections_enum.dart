enum FirestoreCollection {
  users,
  companies,
}

extension FirestoreCollectionExtension on FirestoreCollection {
  String get collectionName {
    switch (this) {
      case FirestoreCollection.users:
        return "users";
      case FirestoreCollection.companies:
        return "companies";
      default:
        return "";
    }
  }
}
