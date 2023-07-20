import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:third_exam_n8/data/models/category_model/category_model.dart';
import 'package:third_exam_n8/ui/app_routes.dart';
import 'package:third_exam_n8/ui/tab_box/category_screen/widgets/category_screen_shimmer.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../../../data/models/universal_data.dart';
import '../../../data/network/api_provider.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.teal,
        title: const Text("Kategoriyalar ro'yxati", style: TextStyle(
          fontWeight: FontWeight.w500,
          color: Colors.white
        ),),
      ),
      body: FutureBuilder<UniversalData>(
        future: ApiProvider.getCategories(),
        builder: (BuildContext context,AsyncSnapshot<UniversalData> snapshot){
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CategoryScreenShimmer();
          } else if(snapshot.hasData){
            List<CategoryModel> categories = snapshot.data!.data;
            return ListView(
              padding: EdgeInsets.symmetric(horizontal: 13.w),
              children: List.generate(categories.length, (index) => ZoomTapAnimation(
                onTap: (){
                  Navigator.pushNamed(context, RouteNames.showDetails, arguments: {
                    "model":categories[index]
                  });
                },
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 10.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 4.sp,
                      ),
                    ],
                  ),
                  child: Row(children: [
                    SizedBox(width: 20.w,),
                    SizedBox(height: 90.w, width: 90.w, child: CachedNetworkImage(
                      imageUrl: categories[index].imageUrl,
                      placeholder: (context, url) => Padding(padding: EdgeInsets.all(20.r),
                      child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    )
                    ),
                    Spacer(),
                    Text(categories[index].name, style: TextStyle(fontSize: 18.sp, color: Colors.black),),
                    SizedBox(width: 55.w,)
                  ],),
                ),
              )),
            );
          }
          return Center(child: Text("Error:${snapshot.error}"));
        },
      ),
    );
  }
}
