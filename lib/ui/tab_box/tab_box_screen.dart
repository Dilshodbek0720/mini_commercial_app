import 'package:flutter/material.dart';
import 'package:third_exam_n8/ui/tab_box/category_screen/category_screen.dart';
import 'package:third_exam_n8/ui/tab_box/products_screen/products_screen.dart';
import 'package:third_exam_n8/ui/tab_box/saved_screen/saved_screen.dart';

class TabBoxScreen extends StatefulWidget {
  const TabBoxScreen({Key? key}) : super(key: key);
  @override
  State<TabBoxScreen> createState() => _TabBoxScreenState();
}

class _TabBoxScreenState extends State<TabBoxScreen> {
  List<Widget> screens = [];
  int activePage = 0;

  @override
  void initState() {
    screens.add(const CategoryScreen());
    screens.add(const ProductScreen());
    screens.add(const SavedScreen());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[activePage],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.teal,
        currentIndex: activePage,
        onTap: (index) {
          setState(() {
            activePage = index;
          });
        },
        selectedIconTheme: const IconThemeData(
          color: Colors.white
        ),
        selectedItemColor: Colors.white,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.category,
            ),
            label: "Products",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.square,
            ),
            label: "Users",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.shopping_basket,
            ),
            label: "Users",
          ),
        ],
      ),
    );
  }
}