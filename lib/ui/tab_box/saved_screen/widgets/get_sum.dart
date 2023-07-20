import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GetSum extends StatelessWidget {
  const GetSum({super.key, required this.sum});
  final double sum;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(14.r),
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(width: 1, color: Colors.teal),
          borderRadius: BorderRadius.circular(7.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              spreadRadius: 2,
            )
          ]),
      child: Row(
        children: [
          SizedBox(
            width: 10.w,
          ),
          Text(
            "Umumiy summa",
            style: TextStyle(
                color: Colors.black,
                fontSize: 20.sp,
                fontWeight: FontWeight.w500),
          ),
          Spacer(),
          Text(
            "\$ $sum",
            style: TextStyle(
                color: Colors.deepPurple,
                fontSize: 20.sp,
                fontWeight: FontWeight.w500),
          ),
          SizedBox(
            width: 10.w,
          )
        ],
      ),
    );
  }
}
