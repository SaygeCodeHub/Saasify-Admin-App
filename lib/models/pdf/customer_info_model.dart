class CustomerInfoModel {
  final String? name;
  final String? customerContact;
  final String? loyaltyPoints;
  final String? customerAddress;

  const CustomerInfoModel(
      {this.name = '',
      this.customerContact = '',
      this.loyaltyPoints = '',
      this.customerAddress = ''});

  factory CustomerInfoModel.fromJson(Map<String, dynamic> json) =>
      CustomerInfoModel(
          name: json['name'] ?? '',
          customerContact: json['customerContact'],
          loyaltyPoints: json['loyaltyPoints'],
          customerAddress: json['customerAddress']);

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'customerContact': customerContact,
      'loyaltyPoints': loyaltyPoints,
      'customerAddress': customerAddress
    };
  }
}
