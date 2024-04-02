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
}
