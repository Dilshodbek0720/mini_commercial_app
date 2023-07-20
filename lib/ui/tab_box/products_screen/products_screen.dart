import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:third_exam_n8/data/local/db/local_database.dart';
import 'package:third_exam_n8/data/models/product_model/product_model.dart';
import 'package:third_exam_n8/data/models/product_model/result_product_model.dart';
import 'package:third_exam_n8/data/models/product_sql_model/saved_product_sql.dart';
import 'package:third_exam_n8/data/models/universal_data.dart';
import 'package:third_exam_n8/data/network/api_provider.dart';
import 'package:third_exam_n8/ui/app_routes.dart';
import 'package:third_exam_n8/ui/tab_box/category_screen/widgets/category_screen_shimmer.dart';
import 'package:third_exam_n8/ui/tab_box/products_screen/widgets/product_screen_shimmer.dart';
import 'package:third_exam_n8/ui/utils/utils_function.dart';
import 'package:third_exam_n8/ui/widgets/global_like_button.dart';

import '../../../data/models/product_sql_model/product_model_sql.dart';
import '../../widgets/global_textbutton.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  List<ProductModel> products = [];
  List<int> favorites = [];
  List<SavedProductSql> savedProducts = [];

  bool isLoading = false;
  init() async {
    setState(() {
      isLoading = false;
    });
    UniversalData universalData = await ApiProvider.getProducts();
    ResultProductModel resultProductModel = universalData.data;
    products = resultProductModel.data;

    setState(() {
      isLoading = true;
    });
  }

  fetch() async {
    favorites =
        (await LocalDatabase.getAllProducts()).map((e) => e.productId).toList();
    setState(() {});
  }

  fetchSavedData() async {
    savedProducts = await LocalDatabase.getAllSavedProducts();
    setState(() {});
  }

  @override
  void initState() {
    init();
    fetch();
    fetchSavedData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.teal,
        title: const Text(
          "Hamma mahsulotlar",
          style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, RouteNames.like);
              },
              icon: const Icon(
                Icons.favorite,
                color: Colors.white,
              ))
        ],
      ),
      body: isLoading ? GridView(
              padding: const EdgeInsets.all(14),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.6,
                  mainAxisSpacing: 13.h,
                  crossAxisSpacing: 18.w),
              children: List.generate(
                  products.length,
                  (index) => Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    spreadRadius: 2,
                                    blurRadius: 4.sp,
                                  ),
                                ],
                                color: Colors.white),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 20.h,
                                ),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10.r),
                                  child: SizedBox(
                                    height: 120 * size.height / 812,
                                    width: 120 * size.width / 375,
                                    child: CachedNetworkImage(
                                      imageUrl: products[index].imageUrl,
                                      placeholder: (context, url) =>
                                          const CircularProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 8.h,
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 5.h),
                                  child: Text(
                                    products[index].name,
                                    maxLines: 2,
                                    style: TextStyle(
                                        fontSize: 15.sp,
                                        overflow: TextOverflow.ellipsis,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  "USD ${products[index].price}",
                                  style: TextStyle(
                                      fontSize: 18.sp,
                                      color: Colors.deepPurple,
                                      fontWeight: FontWeight.w600),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 7.h),
                                  child: GlobalTextButton(onPressed: () async {
                                    getToast(toastName: "Muvaffaqqiyatli qo'shildi");
                                    SavedProductSql? savedProductSql =
                                    await LocalDatabase
                                        .getSingleSavedProduct(
                                        products[index].id);
                                    if (savedProductSql == null) {
                                      await LocalDatabase
                                          .insertSavedProduct(
                                          SavedProductSql(
                                            productId: products[index].id,
                                            categoryId: products[index].categoryId,
                                            name: products[index].name,
                                            price: products[index].price,
                                            imageUrl: products[index].imageUrl,
                                            count: 1,
                                          ));
                                      fetchSavedData();
                                    } else {
                                      await LocalDatabase
                                          .updateSavedProduct(
                                          productId: products[index].id,
                                          count: savedProductSql.count +
                                              1);
                                      fetchSavedData();
                                    }
                                  },)
                                 // TextButton(
                                ),
                                const SizedBox(
                                  height: 18,
                                )
                              ],
                            ),
                          ),
                          GlobalLikeButton(onTap: () async{
                            if (favorites.contains(products[index].id)) {
                              getToast(toastName: "Like bekor qilindi");
                              await LocalDatabase.deleteLikeProduct(products[index].id);
                              fetch();
                            }
                            else{
                              ProductModelSql? productModelSql =
                                  await LocalDatabase.insertLikeProduct(ProductModelSql(
                                productId: products[index].id,
                                categoryId: products[index].categoryId,
                                price: products[index].price,
                                imageUrl: products[index].imageUrl,
                                name: products[index].name,
                              ));
                              getToast(toastName: "Like bosildi");
                              fetch();
                            }
                            fetch();
                          }, isAdd: favorites.contains(products[index].id))
                        ],
                      )) ,
            ) : ProductScreenShimmer()
    );
  }
}
