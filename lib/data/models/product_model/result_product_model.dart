import 'package:third_exam_n8/data/models/product_model/product_model.dart';

class ResultProductModel{
  final List<ProductModel> data;

  ResultProductModel({
    required this.data
});

  factory ResultProductModel.fromJson(Map<String, dynamic> json){
    return ResultProductModel(data: (json['data'] as List<dynamic>?)
        ?.map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
        .toList() ??
        [],);
  }
}