enum ProductSoldByEnum {
  each(soldBy: 'Each'),
  weight(soldBy: 'Weight');

  const ProductSoldByEnum({required this.soldBy});

  final String soldBy;
}
