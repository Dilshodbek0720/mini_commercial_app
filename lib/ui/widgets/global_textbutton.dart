import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../data/local/db/local_database.dart';
import '../../data/models/product_sql_model/saved_product_sql.dart';

class GlobalTextButton extends StatelessWidget {
  const GlobalTextButton({super.key, required this.onPressed, });

  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: onPressed,
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: 10.w, vertical: 6.h),
          decoration: BoxDecoration(
            borderRadius:
            BorderRadius.circular(4.r),
            color: Colors.black,
          ),
          child: const Text(
            "Savatga qo'shish",
            style: TextStyle(color: Colors.white),
          ),
        ));
  }
}
