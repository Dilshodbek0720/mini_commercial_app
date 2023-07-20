import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:third_exam_n8/data/local/db/local_database.dart';
import 'package:third_exam_n8/data/models/product_sql_model/saved_product_sql.dart';
import 'package:third_exam_n8/ui/tab_box/saved_screen/widgets/get_sum.dart';

class SavedScreen extends StatefulWidget {
  const SavedScreen({super.key});

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  double sum = 0;
  List<SavedProductSql> savedProducts = [];
  init() async {
    savedProducts = await LocalDatabase.getAllSavedProducts();
    for (int i = 0; i < savedProducts.length; i++) {
      sum += (savedProducts[i].count) * savedProducts[i].price;
    }
    setState(() {});
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal,
          automaticallyImplyLeading: false,
          title: const Text(
            "Savatcha",
            style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 12.w),
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    showDialog(context: context, builder: (context){
                      return CupertinoAlertDialog(
                        title: Text("Haqiqatdan hamma mahsulotlarni o'chirmoqchimisiz", style: TextStyle(
                          fontSize: 21.sp
                        ),),
                        actions: [
                          GestureDetector(onTap: ()async{
                            await LocalDatabase.deleteAllProduct();
                            Navigator.pop(context);
                            sum = 0;
                            init();
                          }, child: Center(child: Padding(
                            padding: const EdgeInsets.all(7.0),
                            child: Text("Ok", style: TextStyle(fontSize: 17.sp),),
                          ))),
                          GestureDetector(onTap: (){
                            Navigator.pop(context);
                          }, child: Padding(
                            padding: const EdgeInsets.all(7.0),
                            child: Center(child: Text("Cancel", style: TextStyle(fontSize: 17.sp),)),
                          )),
                        ],
                      );
                    });
                  },
                  child: Text(
                    "Tozalash",
                    style: TextStyle(color: Colors.white, fontSize: 15.sp),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 10.w,
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView(
                  children: List.generate(
                      savedProducts.length,
                      (index) => ListTile(
                            title: Text(
                              savedProducts[index].name,
                              style: TextStyle(
                                  color: Colors.black, fontSize: 18.sp),
                            ),
                            subtitle: Text(
                              "Mahsulotlar soni: ${savedProducts[index].count.toString()} * ${savedProducts[index].price}",
                              style: TextStyle(
                                  color: Colors.deepPurple, fontSize: 15.sp),
                            ),
                            trailing: SizedBox(
                              height: 50.h,
                              width: 100.w,
                              child: Row(
                                children: [
                                  IconButton(
                                      onPressed: () {},
                                      icon: ClipRRect(
                                          child: SizedBox(
                                        height: 40.w,
                                        width: 40.w,
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              savedProducts[index].imageUrl,
                                          placeholder: (context, url) => Padding(
                                              padding: EdgeInsets.all(20.r),
                                              child:
                                                  CircularProgressIndicator()),
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.error),
                                        ),
                                      ))),
                                  Spacer(),
                                  IconButton(
                                      onPressed: () async {
                                        await LocalDatabase.deleteSavedProduct(
                                            savedProducts[index].productId);
                                        sum = 0;
                                        init();
                                      },
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ))
                                ],
                              ),
                            ),
                          ))),
            ),
            Spacer(),
            GetSum(sum: sum,)
          ],
        ));
  }
}
