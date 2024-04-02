class Billing {
  final String name;
  double cost;
  final String quantity;
  int count;
  double variantCost;
  bool showCart;

  Billing(
      {required this.cost,
      required this.name,
      required this.quantity,
      required this.count,
      required this.variantCost,
      this.showCart = false});
}
