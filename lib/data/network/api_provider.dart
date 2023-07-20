import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:third_exam_n8/data/models/category_model/category_model.dart';
import 'package:third_exam_n8/data/models/product_model/product_model.dart';
import 'package:third_exam_n8/data/models/product_model/result_product_model.dart';
import '../models/universal_data.dart';
import 'network_utils.dart';

class ApiProvider {

  static Future<UniversalData> getProducts() async {
    Uri uri = Uri.parse("https://imtixon.free.mockoapp.net/products");

    try {
      http.Response response = await http.get(uri);
      if (response.statusCode == HttpStatus.ok) {
        {
          return UniversalData(
            data: ResultProductModel.fromJson(jsonDecode(response.body)),
            statusCode: response.statusCode,
          );
        }
      }
      return handleHttpErrors(response);
    } on SocketException {
      return UniversalData(error: "Internet Error!");
    } on FormatException {
      return UniversalData(error: "Format Error!");
    }
    // on TypeError{
    //   return UniversalData(error: "TYPE ERROR");
    // }
    catch (err) {
      return UniversalData(error: err.toString());
    }
  }

  static Future<UniversalData> getCategories() async {
    Uri uri = Uri.parse("https://imtixon.free.mockoapp.net/categories");

    try {
      http.Response response = await http.get(uri);
      if (response.statusCode == HttpStatus.ok) {
        {
          return UniversalData(
            data: (jsonDecode(response.body) as List<dynamic>?)
                ?.map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
                .toList() ??
                [],
            statusCode: response.statusCode,
          );
        }
      }
      return handleHttpErrors(response);
    } on SocketException {
      return UniversalData(error: "Internet Error!");
    } on FormatException {
      return UniversalData(error: "Format Error!");
    }
    // on TypeError{
    //   return UniversalData(error: "TYPE ERROR");
    // }
    catch (err) {
      return UniversalData(error: err.toString());
    }
  }

  static Future<UniversalData> getCategoriesId({
    required int id
}) async {
    Uri uri = Uri.parse("https://imtixon.free.mockoapp.net/categories/$id");

    try {
      http.Response response = await http.get(uri);
      if (response.statusCode == HttpStatus.ok) {
        {
          return UniversalData(
            data: (jsonDecode(response.body) as List<dynamic>?)
                ?.map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
                .toList() ??
                [],
            statusCode: response.statusCode,
          );
        }
      }
      return handleHttpErrors(response);
    } on SocketException {
      return UniversalData(error: "Internet Error!");
    } on FormatException {
      return UniversalData(error: "Format Error!");
    }
    catch (err) {
      return UniversalData(error: err.toString());
    }
  }
}