import 'package:saasify/models/pdf/customer_info_model.dart';

class Orders {
  final CustomerInfoModel customerInfo;
  final BillingInfo billingInfo;
  final List<Map<String, dynamic>> items;

  Orders({
    required this.customerInfo,
    required this.billingInfo,
    required this.items,
  });

  factory Orders.fromJson(Map<String, dynamic> json) => Orders(
        billingInfo: BillingInfo.fromJson(json['billingInfo']),
        items: json['items'],
        customerInfo: CustomerInfoModel.fromJson(json['customerInfo']),
      );

  Map<String, dynamic> toJson() => {
        'customerInfo': customerInfo.toMap(),
        'billingInfo': billingInfo.toJson(),
        'items': items,
      };
}

class BillingInfo {
  final String customerName;
  final String date;
  final String invoiceNumber;
  final String paymentMethod;
  final double subTotal;
  final double discountAmount;
  final double sgst;
  final double cgst;
  final double grandTotal;

  BillingInfo({
    required this.customerName,
    required this.date,
    required this.invoiceNumber,
    required this.paymentMethod,
    required this.subTotal,
    this.discountAmount = 0.0,
    this.sgst = 0.0,
    this.cgst = 0.0,
    required this.grandTotal,
  });

  factory BillingInfo.fromJson(Map<String, dynamic> json) => BillingInfo(
        customerName: json['customerName'] ?? '',
        date: json['date'],
        invoiceNumber: json['invoiceNumber'],
        paymentMethod: json['paymentMethod'],
        subTotal: json['subTotal'].toDouble(),
        discountAmount: json['discountAmount']?.toDouble() ?? 0.0,
        sgst: json['sgst']?.toDouble() ?? 0.0,
        cgst: json['cgst']?.toDouble() ?? 0.0,
        grandTotal: json['grandTotal'].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'customerName': customerName,
        'date': date,
        'invoiceNumber': invoiceNumber,
        'paymentMethod': paymentMethod,
        'subTotal': subTotal,
        'discountAmount': discountAmount,
        'sgst': sgst,
        'cgst': cgst,
        'grandTotal': grandTotal,
      };
}
