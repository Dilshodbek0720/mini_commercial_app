import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:third_exam_n8/ui/tab_box/products_screen/widgets/product_screen_shimmer.dart';

import '../../../../data/local/db/local_database.dart';
import '../../../../data/models/product_sql_model/product_model_sql.dart';
import '../../../../data/models/product_sql_model/saved_product_sql.dart';
import '../../../utils/utils_function.dart';
import '../../../widgets/global_textbutton.dart';


class LikeScreen extends StatefulWidget {
  const LikeScreen({super.key});
  @override
  State<LikeScreen> createState() => _LikeScreenState();
}

class _LikeScreenState extends State<LikeScreen> {

  List<ProductModelSql> favorites = [];

  bool isLoading = false;
  init()async{
    setState(() {
      isLoading = false;
    });
    favorites = await LocalDatabase.getAllProducts();
    setState(() {
      isLoading = true;
    });
  }
  List<SavedProductSql> savedProducts = [];

  fetchSavedData() async {
    savedProducts = await LocalDatabase.getAllSavedProducts();
    setState(() {});
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sevimlilar"),
        backgroundColor: Colors.teal,
      ),
      body: isLoading ? GridView(
        padding: EdgeInsets.all(14.r),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.6,
            mainAxisSpacing: 13.h,
            crossAxisSpacing: 18.w),
        children: List.generate(
            favorites.length,
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
                            imageUrl: favorites[index].imageUrl,
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
                        padding: EdgeInsets.symmetric(horizontal: 5.h),
                        child: Text(
                          favorites[index].name,
                          maxLines: 2,
                          style: TextStyle(
                              fontSize: 15.sp,
                              overflow: TextOverflow.ellipsis,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        "USD ${favorites[index].price}",
                        style: TextStyle(
                            fontSize: 18.sp,
                            color: Colors.deepPurple,
                            fontWeight: FontWeight.w600),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 7.h),
                        child: GlobalTextButton(onPressed: () async {
                          getToast(toastName: "Muvaffaqqiyatli qo'shildi");
                          SavedProductSql? savedProductSql =
                          await LocalDatabase
                              .getSingleSavedProduct(
                              favorites[index].productId);
                          if (savedProductSql == null) {
                            await LocalDatabase
                                .insertSavedProduct(
                                SavedProductSql(
                                  productId: favorites[index].productId,
                                  categoryId: favorites[index].categoryId,
                                  name: favorites[index].name,
                                  price: favorites[index].price,
                                  imageUrl: favorites[index].imageUrl,
                                  count: 1,
                                ));
                            fetchSavedData();
                          } else {
                            await LocalDatabase
                                .updateSavedProduct(
                                productId: favorites[index].productId,
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
              ],
            )),
      ) : ProductScreenShimmer()
    );
  }
}
