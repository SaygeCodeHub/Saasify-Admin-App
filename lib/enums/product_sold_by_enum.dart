enum ProductSoldByEnum {
  each(soldBy: 'Each'),
  quantity(soldBy: 'Quantity');

  const ProductSoldByEnum({required this.soldBy});

  final String soldBy;
}
