import 'dart:io';

import 'package:dormitory_manager/resources/colors.dart';
import 'package:dormitory_manager/resources/dimensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Bill extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return BillState();
  }
}

class BillState extends State<Bill> {
  final listItem = [
    Container(
      child: Text("1"),
      height: AppDimensions.d10h,
      width: AppDimensions.d100w,
      decoration: BoxDecoration(border: Border.all()),
    ),
    Container(
      child: Text("1"),
      height: AppDimensions.d10h,
      width: AppDimensions.d100w,
      decoration: BoxDecoration(border: Border.all()),
    ),
    Container(
      child: Text("1"),
      height: AppDimensions.d10h,
      width: AppDimensions.d100w,
      decoration: BoxDecoration(border: Border.all()),
    ),
    Container(
      child: Text("1"),
      height: AppDimensions.d10h,
      width: AppDimensions.d100w,
      decoration: BoxDecoration(border: Border.all()),
    ),
    Container(
      child: Text("1"),
      height: AppDimensions.d10h,
      width: AppDimensions.d100w,
      decoration: BoxDecoration(border: Border.all()),
    ),
    Container(
      child: Text("1"),
      height: AppDimensions.d10h,
      width: AppDimensions.d100w,
      decoration: BoxDecoration(border: Border.all()),
    ),
    Container(
      child: Text("1"),
      height: AppDimensions.d10h,
      width: AppDimensions.d100w,
      decoration: BoxDecoration(border: Border.all()),
    ),
    Container(
      child: Text("1"),
      height: AppDimensions.d10h,
      width: AppDimensions.d100w,
      decoration: BoxDecoration(border: Border.all()),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: AppDimensions.d100w,
          height: AppDimensions.d20h,
          decoration: BoxDecoration(
            color: AppColors.mainColor,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(AppDimensions.radius3w),
              bottomRight: Radius.circular(AppDimensions.radius3w),
            ),
          ),
        ),
        Expanded(
            child: SingleChildScrollView(
              child: Column(
          children:listItem.map<Widget>((e){
              return e;
          }).toList(),
        ),
            )),
        Container(
          width: AppDimensions.d100w,
          height: AppDimensions.d10h,
          decoration: BoxDecoration(
            color: AppColors.mainColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(AppDimensions.radius3w),
              topRight: Radius.circular(AppDimensions.radius3w),
            ),
          ),
        ),
      ],
    );
  }
}
