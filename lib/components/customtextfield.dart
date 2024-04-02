import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextformAuth extends StatelessWidget {
  String text;
  String hinttext;
  TextEditingController controller;
  String? Function(String?)? validator;
  Icon? suffixicon;
  CustomTextformAuth({
    required this.text,
    required this.hinttext,
    required this.controller,
    this.suffixicon,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: TextStyle(fontSize: 20.sp),
        ),
        SizedBox(
          height: 10.h,
        ),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              color: Colors.grey[200]),
          child: TextFormField(
            validator: validator,
            controller: controller,
            decoration: InputDecoration(
              suffixIcon: suffixicon,
              hintText: hinttext,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.r),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
