import 'package:flutter/material.dart';
import 'package:third_exam_n8/ui/tab_box/category_screen/widgets/show_detail_screen.dart';
import 'package:third_exam_n8/ui/tab_box/products_screen/widgets/like_screen.dart';
import 'package:third_exam_n8/ui/tab_box/tab_box_screen.dart';

class RouteNames {
  static const String tabBoxScreen = "/tab_box";
  static const String showDetails = "/show_details";
  static const String like = "/like";
}

class AppRoutes {
  static Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.tabBoxScreen:
        return MaterialPageRoute(builder: (context) {
          return const TabBoxScreen();
        });
      case RouteNames.like:
        return MaterialPageRoute(builder: (context) => const LikeScreen());
      case RouteNames.showDetails:
        return MaterialPageRoute(builder: (context) {
          Map<String, dynamic> map = settings.arguments as Map<String, dynamic>;
          return ShowDetailScreen(categoryModel: map['model']);
        });
      default:
        return MaterialPageRoute(
          builder: (context) => const Scaffold(
            body: Center(
              child: Text("Route mavjud emas"),
            ),
          ),
        );
    }
  }
}