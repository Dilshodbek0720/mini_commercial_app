class CategoryModel {
  final int id;
  final String name;
  final String imageUrl;
  final String createdAt;

  CategoryModel(
      {required this.id,
        required this.name,
        required this.imageUrl,
        required this.createdAt});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? "",
      imageUrl: json['image_url'] as String? ?? "",
      createdAt: json['created_at'] as String? ?? "",
    );
  }
}
