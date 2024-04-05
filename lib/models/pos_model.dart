class PosModel {
  final String name;
  double cost;
  final String quantity;
  int count;
  double variantCost;
  String variantId;
  String description;
  String image;

  PosModel(
      {required this.cost,
      required this.name,
      required this.quantity,
      required this.count,
      required this.variantCost,
      required this.variantId,
      required this.description,
      required this.image});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'cost': cost,
      'quantity': quantity,
      'count': count,
      'variantCost': variantCost,
      'variantId': variantId,
      'description': description,
      'image': image
    };
  }
}

class BillDetails {
  double? netAmount;
  double? discount;
  double? subTotal;
  double? tax;
  double? grandTotal;
  double? taxPercentage;
  double? discountPercentage;
  String? selectedPaymentMethod;

  BillDetails(
      {this.netAmount = 0.0,
      this.discount = 0.0,
      this.subTotal = 0.0,
      this.tax = 0.0,
      this.grandTotal = 0.0,
      this.taxPercentage = 0.0,
      this.discountPercentage = 0.0,
      this.selectedPaymentMethod = ''});

  Map<String, dynamic> toJson() {
    return {
      'netAmount': netAmount,
      'discount': discount,
      'subTotal': subTotal,
      'tax': tax,
      'grandTotal': grandTotal,
      'taxPercentage': taxPercentage,
      'discountPercentage': discountPercentage,
      'paymentMethod': selectedPaymentMethod
    };
  }
}
