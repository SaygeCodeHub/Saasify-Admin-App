class AddSupplierModel {
  final String name;
  final String email;
  final String contact;

  AddSupplierModel(
      {required this.name, required this.email, required this.contact});

  Map<String, dynamic> toMap() {
    return {'name': name, 'email': email, 'contact': contact};
  }
}
