import 'dart:io';

import 'package:dormitory_manager/helper/ui_helper.dart';
import 'package:dormitory_manager/resources/colors.dart';
import 'package:dormitory_manager/resources/dimensions.dart';
import 'package:dormitory_manager/resources/fontsizes.dart';
import 'package:dormitory_manager/ui/widget/close_dialog.dart';
import 'package:dormitory_manager/ui/widget/item_bill.dart';
import 'package:dormitory_manager/ui/widget/item_report.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Report extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ReportState();
  }
}

class ReportState extends State<Report> {
  @override
  Widget build(BuildContext context) {
    var heightStatusBar = MediaQuery.of(context).padding.top;
    return Column(
      children: [
        Container(
          width: AppDimensions.d100w,
          height: AppDimensions.d14h,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomLeft,
              colors: [
                Colors.green,
                AppColors.colorFacebook,
              ],
            ),
            color: AppColors.mainColor,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(AppDimensions.radius3w),
              bottomRight: Radius.circular(AppDimensions.radius3w),
            ),
          ),
          child: Column(
            children: [
              SizedBox(
                height: heightStatusBar,
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(AppDimensions.d1h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Báo sự cố",
                        style: TextStyle(
                            color: AppColors.colorWhite,
                            fontSize: AppFontSizes.fs14,
                            fontWeight: FontWeight.bold),
                      ),
                      GestureDetector(
                        onTap: () => _showDialogReport(),
                        child: Container(
                          alignment: Alignment.center,
                          width: AppDimensions.d18w,
                          height: AppDimensions.d10h,
                          decoration: BoxDecoration(
                            color: AppColors.colorOrange,
                            borderRadius: BorderRadius.all(
                              Radius.circular(AppDimensions.radius1_0w),
                            ),
                          ),
                          child: Text(
                            "Thêm",
                            style: TextStyle(
                              color: AppColors.colorWhite,
                              fontSize: AppFontSizes.fs12,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(AppDimensions.d1h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Chưa sửa",
                      style: TextStyle(
                          color: AppColors.colorWhite,
                          fontSize: AppFontSizes.fs12),
                    ),
                    Text(
                      "Đang sửa",
                      style: TextStyle(
                          color: AppColors.colorWhite,
                          fontSize: AppFontSizes.fs12),
                    ),
                    Text(
                      "Đã sửa",
                      style: TextStyle(
                          color: AppColors.colorWhite,
                          fontSize: AppFontSizes.fs12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(child: ItemReport()),
        ),
      ],
    );
  }

  _showDialogReport() {
    return UIHelper.showDialogLogin(
        context: context,
        widget: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppDimensions.d2w),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "Nhập nội dung",
                      style: TextStyle(
                          fontSize: AppFontSizes.fs14,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  CloseDialog(
                    color: AppColors.colorBlack_54,
                    onClose: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(AppDimensions.d1h),
              child: GestureDetector(
                onTap: () => _showDialogSelect(),
                child: Container(
                  width: AppDimensions.d100w,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.colorGrey_300),
                    borderRadius: BorderRadius.all(
                      Radius.circular(AppDimensions.radius1_5w),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(AppDimensions.d0_5h),
                    child: Row(
                      children: [
                        Text("p102"),
                        Expanded(
                          child: Container(),
                        ),
                        Icon(
                          Icons.keyboard_arrow_down,
                          color: AppColors.colorGrey_400,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppDimensions.d2w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Tiêu đề",
                    style: TextStyle(
                      color: AppColors.colorBlack_87,
                      fontSize: AppFontSizes.fs10,
                    ),
                  ),
                  Container(
                    child: CupertinoTextField(
                      style: TextStyle(
                          fontSize: AppFontSizes.fs10,
                          color: AppColors.colorBlack_87),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppDimensions.d2w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Nội dung",
                    style: TextStyle(
                      color: AppColors.colorBlack_87,
                      fontSize: AppFontSizes.fs10,
                    ),
                  ),
                  Container(
                    child: CupertinoTextField(
                      maxLines: 10,
                      style: TextStyle(
                          fontSize: AppFontSizes.fs10,
                          color: AppColors.colorBlack_87),
                    ),
                  ),
                ],
              ),
            ),
            Divider(),
            Padding(
              padding: EdgeInsets.all(AppDimensions.d1h),
              child: GestureDetector(
                onTap: () {},
                behavior: HitTestBehavior.opaque,
                child: Container(
                  alignment: Alignment.center,
                  width: AppDimensions.d100w,
                  decoration: BoxDecoration(
                    boxShadow: [],
                    color: AppColors.colorOrange,
                    borderRadius: BorderRadius.all(
                      Radius.circular(AppDimensions.radius1_0w),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(AppDimensions.d2h),
                    child: Text(
                      "Gửi",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.colorWhite,
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ));
  }

  _showDialogSelect() {
    return UIHelper.showDialogLogin(
        context: context,
        widget: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppDimensions.d2w),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "Nhập nội dung",
                      style: TextStyle(
                          fontSize: AppFontSizes.fs14,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  CloseDialog(
                    color: AppColors.colorBlack_54,
                    onClose: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(AppDimensions.d1h),
              child: GestureDetector(
                onTap: () => _showDialogSelect(),
                child: Container(
                  width: AppDimensions.d100w,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.colorGrey_300),
                    borderRadius: BorderRadius.all(
                      Radius.circular(AppDimensions.radius1_5w),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(AppDimensions.d0_5h),
                    child: Row(
                      children: [
                        Text(
                          "p102",
                          style: TextStyle(
                              fontSize: AppFontSizes.fs10,
                              fontWeight: FontWeight.bold),
                        ),
                        Expanded(
                          child: Container(),
                        ),
                        Icon(
                          Icons.keyboard_arrow_down,
                          color: AppColors.colorGrey_400,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppDimensions.d2w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Tiêu đề",
                    style: TextStyle(
                      color: AppColors.colorBlack_87,
                      fontSize: AppFontSizes.fs10,
                    ),
                  ),
                  Container(
                    child: CupertinoTextField(
                      style: TextStyle(
                          fontSize: AppFontSizes.fs10,
                          color: AppColors.colorBlack_87),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppDimensions.d2w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Nội dung",
                    style: TextStyle(
                      color: AppColors.colorBlack_87,
                      fontSize: AppFontSizes.fs10,
                    ),
                  ),
                  Container(
                    child: CupertinoTextField(
                      maxLines: 10,
                      style: TextStyle(
                          fontSize: AppFontSizes.fs10,
                          color: AppColors.colorBlack_87),
                    ),
                  ),
                ],
              ),
            ),
            Divider(),
            Padding(
              padding: EdgeInsets.all(AppDimensions.d1h),
              child: GestureDetector(
                onTap: () {},
                behavior: HitTestBehavior.opaque,
                child: Container(
                  alignment: Alignment.center,
                  width: AppDimensions.d100w,
                  decoration: BoxDecoration(
                    boxShadow: [],
                    color: AppColors.colorOrange,
                    borderRadius: BorderRadius.all(
                      Radius.circular(AppDimensions.radius1_0w),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(AppDimensions.d2h),
                    child: Text(
                      "Gửi",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.colorWhite,
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ));
  }
}