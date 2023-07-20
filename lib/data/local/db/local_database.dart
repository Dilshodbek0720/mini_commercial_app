import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:third_exam_n8/data/models/product_sql_model/product_model_sql.dart';
import 'package:third_exam_n8/data/models/product_sql_model/saved_product_sql.dart';

class LocalDatabase {
  static final LocalDatabase getInstance = LocalDatabase._init();

  LocalDatabase._init();

  factory LocalDatabase() {
    return getInstance;
  }

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    } else {
      _database = await _initDB("product.db");
      return _database!;
    }
  }

  Future<Database> _initDB(String dbName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, dbName);
    return await openDatabase(path, version: 2, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const textType = "TEXT NOT NULL";
    const intType = "INTEGER DEFAULT 0";

    await db.execute('''
    CREATE TABLE ${ProductModelFields.productsTable} (
    ${ProductModelFields.productId} $intType,
    ${ProductModelFields.categoryId} $intType,
    ${ProductModelFields.name} $textType,
    ${ProductModelFields.imageUrl} $textType,
    ${ProductModelFields.price} $intType
    )
    ''');

    await db.execute('''
    CREATE TABLE ${SavedProductSqlFields.productsSavedTable} (
    ${SavedProductSqlFields.productId} $intType,
    ${SavedProductSqlFields.categoryId} $intType,
    ${SavedProductSqlFields.name} $textType,
    ${SavedProductSqlFields.imageUrl} $textType,
    ${SavedProductSqlFields.price} $intType,
    ${SavedProductSqlFields.count} $intType
    )
    ''');

  }

  static Future<ProductModelSql> insertLikeProduct(ProductModelSql productsModelSql) async {
    final db = await getInstance.database;
    final int id = await db.insert(
        ProductModelFields.productsTable, productsModelSql.toJson());
    return productsModelSql.copyWith(productId: id);
  }

  static Future<List<ProductModelSql>> getAllProducts() async {
    List<ProductModelSql> allProducts = [];
    final db = await getInstance.database;
    allProducts = (await db.query(ProductModelFields.productsTable))
        .map((e) => ProductModelSql.fromJson(e))
        .toList();

    return allProducts;
  }

  static Future<int> deleteLikeProduct(int productId) async {
    final db = await getInstance.database;
    int count = await db.delete(
      ProductModelFields.productsTable,
      where: "${ProductModelFields.productId} = ?",
      whereArgs: [productId],
    );
    return count;
  }


  // *********************

  static Future<SavedProductSql> insertSavedProduct(SavedProductSql savedProductSql) async {
    final db = await getInstance.database;
    final int id = await db.insert(
        SavedProductSqlFields.productsSavedTable, savedProductSql.toJson());
    return savedProductSql.copyWith(productId: id);
  }

  static updateSavedProduct({required int productId, required int count}) async {
    final db = await getInstance.database;
    db.update(
      SavedProductSqlFields.productsSavedTable,
      {SavedProductSqlFields.count: count},
      where: "${SavedProductSqlFields.productId} = ?",
      whereArgs: [productId],
    );
  }

  static Future<List<SavedProductSql>> getAllSavedProducts() async {
    List<SavedProductSql> allProducts = [];
    final db = await getInstance.database;
    allProducts = (await db.query(SavedProductSqlFields.productsSavedTable))
        .map((e) => SavedProductSql.fromJson(e))
        .toList();

    return allProducts;
  }

  static Future<SavedProductSql?> getSingleSavedProduct(int id) async {
    List<SavedProductSql> contacts = [];
    final db = await getInstance.database;
    contacts = (await db.query(
      SavedProductSqlFields.productsSavedTable,
      where: "${SavedProductSqlFields.productId} = ?",
      whereArgs: [id],
    ))
        .map((e) => SavedProductSql.fromJson(e))
        .toList();

    if (contacts.isNotEmpty) {
      return contacts.first;
    }
  }

  static Future<int> deleteSavedProduct(int productId) async {
    final db = await getInstance.database;
    int count = await db.delete(
      SavedProductSqlFields.productsSavedTable,
      where: "${SavedProductSqlFields.productId} = ?",
      whereArgs: [productId],
    );
    return count;
  }

  static Future<int> deleteAllProduct() async {
    final db = await getInstance.database;
    int count = await db.delete(
      SavedProductSqlFields.productsSavedTable,
    );
    return count;
  }
}