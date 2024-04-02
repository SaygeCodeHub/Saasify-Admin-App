class ProductVariant {
  final String variantId;
  final String productId;
  final String variantName;
  final double price;
  final double cost;
  final int quantityAvailable;

  ProductVariant({
    required this.variantId,
    required this.productId,
    required this.variantName,
    required this.price,
    required this.cost,
    required this.quantityAvailable,
  });

  factory ProductVariant.fromJson(Map<String, dynamic> json) {
    return ProductVariant(
      variantId: json['variantId'],
      productId: json['productId'],
      variantName: json['variantName'],
      price: json['price'],
      cost: json['cost'],
      quantityAvailable: json['quantityAvailable'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'variantId': variantId,
      'productId': productId,
      'variantName': variantName,
      'price': price,
      'cost': cost,
      'quantityAvailable': quantityAvailable,
    };
  }
}

class Product {
  final String productId;
  final String name;
  final String category;
  final String description;
  final String imageUrl;
  final String supplier;
  final double tax;
  final int minStockLevel;
  final DateTime dateAdded;
  final bool isActive;
  final String soldBy;
  final String unit;
  final List<ProductVariant> variants;

  Product({
    required this.productId,
    required this.name,
    required this.category,
    required this.description,
    required this.imageUrl,
    required this.supplier,
    required this.tax,
    required this.minStockLevel,
    required this.dateAdded,
    this.isActive = true,
    required this.soldBy,
    required this.unit,
    required this.variants,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    List<dynamic> variantsJson = json['variants'];
    List<ProductVariant> variants = variantsJson
        .map((variantJson) => ProductVariant.fromJson(variantJson))
        .toList();

    return Product(
      productId: json['productId'],
      name: json['name'],
      category: json['category'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      supplier: json['supplier'],
      tax: json['tax'],
      minStockLevel: json['minStockLevel'],
      dateAdded: DateTime.parse(json['dateAdded']),
      isActive: json['isActive'],
      soldBy: json['soldBy'],
      unit: json['unit'],
      variants: variants,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'name': name,
      'category': category,
      'description': description,
      'imageUrl': imageUrl,
      'supplier': supplier,
      'tax': tax,
      'minStockLevel': minStockLevel,
      'dateAdded': dateAdded.toIso8601String(),
      'isActive': isActive,
      'soldBy': soldBy,
      'unit': unit,
      'variants': variants.map((variant) => variant.toJson()).toList(),
    };
  }
}

class Category {
  final String categoryId;
  final String categoryName;
  final List<Product> products;

  Category({
    required this.categoryId,
    required this.categoryName,
    required this.products,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    List<dynamic> productsJson = json['products'];
    List<Product> products = productsJson
        .map((productJson) => Product.fromJson(productJson))
        .toList();

    return Category(
      categoryId: json['categoryId'],
      categoryName: json['categoryName'],
      products: products,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'categoryId': categoryId,
      'categoryName': categoryName,
      'products': products.map((product) => product.toJson()).toList(),
    };
  }
}
