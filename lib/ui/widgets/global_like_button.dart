import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GlobalLikeButton extends StatelessWidget {
  const GlobalLikeButton({super.key, required this.onTap, required this.isAdd});

  final VoidCallback onTap;
  final bool isAdd;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 10.w,
      top: 5.h,
      child: Container(
        margin: EdgeInsets.all(5.r),
        width: 40.w,
        height: 40.h,
        decoration: BoxDecoration(
            color: Colors.black12,
            shape: BoxShape.circle
        ),
        child: Center(
          child: GestureDetector(
              onTap: onTap,
              child: isAdd
                  ? Icon(
                Icons.favorite,
                color: Colors.red,
                size: 25.r,
              )
                  : Icon(
                Icons.favorite,
                color: Colors.white,
                size: 25.r,
              )),
        ),
      ),
    );
  }
}
