import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButtonAuth extends StatelessWidget {
  final String title;
  void Function()? onpressed;
  CustomButtonAuth({
    required this.title,
    required this.onpressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onpressed,
      child: Container(
          height: 50.h,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              color: Color(0xFFFb12e65)),
          child: Center(
            child: Text(
              title,
              style: GoogleFonts.caveat(
                fontSize: 26.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          )),
    );
  }
}
