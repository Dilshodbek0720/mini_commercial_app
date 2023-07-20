class ProductModelFields {
  static const String productId = "productId";
  static const String categoryId = "categoryId";
  static const String name = "name";
  static const String price = "price";
  static const String imageUrl = "imageUrl";

  static const String productsTable = "gmm";
}

class ProductModelSql {
  final int productId;
  final int categoryId;
  final String name;
  final int price;
  final String imageUrl;

  ProductModelSql({
    required this.productId,
    required this.categoryId,
    required this.name,
    required this.price,
    required this.imageUrl,
  });

  factory ProductModelSql.fromJson(Map<String, dynamic> json) {
    return ProductModelSql(
      productId: json[ProductModelFields.productId] ?? 0,
      categoryId: json[ProductModelFields.categoryId] ?? 0,
      name: json[ProductModelFields.name] ?? "",
      imageUrl: json[ProductModelFields.imageUrl] ?? "",
      price: json[ProductModelFields.price] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      ProductModelFields.productId: productId,
      ProductModelFields.categoryId: categoryId,
      ProductModelFields.name: name,
      ProductModelFields.imageUrl: imageUrl,
      ProductModelFields.price: price,
    };
  }

  ProductModelSql copyWith({
    int? productId,
    int? categoryId,
    String? name,
    String? imageUrl,
    int? price,
  }) {
    return ProductModelSql(
      productId: productId ?? this.productId,
      categoryId: categoryId ?? this.categoryId,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
    );
  }

  @override
  String toString() {
    return '''
      productId: $productId,
      categoryId: $categoryId,
      name: $name,
      imageUrl: $imageUrl,
      price: $price,
    ''';
  }
}