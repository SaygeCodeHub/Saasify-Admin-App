enum ProductByQuantityEnum {
  kg(quantity: 'kg'),
  ltr(quantity: 'ltr'),
  gm(quantity: 'gm');

  const ProductByQuantityEnum({required this.quantity});

  final String quantity;
}
