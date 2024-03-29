class BillingInfoModel {
  final String? cashierName;
  final String? dateAndTime;
  final String? billNumber;
  final String? paymentType;
  final int? totalItems;
  final double? subTotalAmount;
  final double? discountAmount;
  final double? cgstAmount;
  final double? sgstAmount;
  final double? grandTotalAmount;

  const BillingInfoModel(
      this.cashierName,
      this.dateAndTime,
      this.billNumber,
      this.paymentType,
      this.totalItems,
      this.subTotalAmount,
      this.discountAmount,
      this.cgstAmount,
      this.sgstAmount,
      this.grandTotalAmount);
}
