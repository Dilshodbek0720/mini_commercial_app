import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:third_exam_n8/data/models/product_model/product_model.dart';
import 'package:third_exam_n8/data/models/universal_data.dart';
import 'package:third_exam_n8/data/network/api_provider.dart';
import 'package:third_exam_n8/ui/tab_box/products_screen/widgets/product_screen_shimmer.dart';
import 'package:third_exam_n8/ui/widgets/global_like_button.dart';

import '../../../../data/local/db/local_database.dart';
import '../../../../data/models/category_model/category_model.dart';
import '../../../../data/models/product_sql_model/product_model_sql.dart';
import '../../../../data/models/product_sql_model/saved_product_sql.dart';
import '../../../utils/utils_function.dart';
import '../../../widgets/global_textbutton.dart';


class ShowDetailScreen extends StatefulWidget {
  const ShowDetailScreen({super.key, required this.categoryModel});
  final CategoryModel categoryModel;
  @override
  State<ShowDetailScreen> createState() => _ShowDetailScreenState();
}

class _ShowDetailScreenState extends State<ShowDetailScreen> {
  List<ProductModel> products = [];
  List<int> favorites = [];
  List<SavedProductSql> savedProducts = [];

  bool isLoading = false;
  init()async{
    setState(() { isLoading = false; });

    UniversalData universalData = await ApiProvider.getCategoriesId(id: widget.categoryModel.id);
    products = universalData.data;

    setState(() { isLoading = true; });
  }

  fetchSavedData() async {
    savedProducts = await LocalDatabase.getAllSavedProducts();
    setState(() {});
  }

  fetch()async{
    favorites = (await LocalDatabase.getAllProducts()).map((e) => e.productId as int).toList();
    setState(() { });
  }

  @override
  void initState() {
    init();
    fetch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text(widget.categoryModel.name, style: const TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.white
        ),),
      ),
      body: isLoading ? GridView(
        padding: EdgeInsets.all(14.r),
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
                          borderRadius: BorderRadius.circular(16.sp),
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
                            padding: EdgeInsets.symmetric(horizontal: 5.w),
                            child: Text(
                              products[index].name,
                              maxLines: 2,
                              style: TextStyle(
                                  fontSize: 15.sp,
                                  overflow: TextOverflow.ellipsis,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          Spacer(),
                          Text(
                            "USD ${products[index].price}",
                            style: TextStyle(
                                fontSize: 18.sp,
                                color: Colors.deepPurple,
                                fontWeight: FontWeight.w600),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 7),
                            child: GlobalTextButton(onPressed: () async {
                              Fluttertoast.showToast(
                                msg: "Muvaffaqqiyatli qo'shildi",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                backgroundColor: Colors.black,
                                textColor: Colors.white,
                              );
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
                            },),
                          ),
                          SizedBox(
                            height: 18.h,
                          )
                        ],
                      ),
                    ),
                    GlobalLikeButton(onTap: () async {
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
                )),
      ) : ProductScreenShimmer()
    );
  }
}
