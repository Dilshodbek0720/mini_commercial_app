class SavedProductSqlFields {
  static const String productId = "productId";
  static const String categoryId = "categoryId";
  static const String name = "name";
  static const String price = "price";
  static const String imageUrl = "imageUrl";
  static const String count = "count";

  static const String productsSavedTable = "gms";
}

class SavedProductSql {
  final int productId;
  final int categoryId;
  final String name;
  final int price;
  final String imageUrl;
  final int count;

  SavedProductSql({
    required this.productId,
    required this.categoryId,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.count,
  });

  factory SavedProductSql.fromJson(Map<String, dynamic> json) {
    return SavedProductSql(
      productId: json[SavedProductSqlFields.productId] ?? 0,
      categoryId: json[SavedProductSqlFields.categoryId] ?? 0,
      name: json[SavedProductSqlFields.name] ?? "",
      imageUrl: json[SavedProductSqlFields.imageUrl] ?? "",
      price: json[SavedProductSqlFields.price] ?? 0,
      count: json[SavedProductSqlFields.count] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      SavedProductSqlFields.productId: productId,
      SavedProductSqlFields.categoryId: categoryId,
      SavedProductSqlFields.name: name,
      SavedProductSqlFields.imageUrl: imageUrl,
      SavedProductSqlFields.price: price,
      SavedProductSqlFields.count: count,
    };
  }

  SavedProductSql copyWith({
    int? productId,
    int? categoryId,
    String? name,
    String? imageUrl,
    int? price,
    int? count,
  }) {
    return SavedProductSql(
      productId: productId ?? this.productId,
      categoryId: categoryId ?? this.categoryId,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      count: count ?? this.count,
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
      count: $count,
    ''';
  }
}