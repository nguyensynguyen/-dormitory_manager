import 'dart:io';

import 'package:dormitory_manager/helper/ui_helper.dart';
import 'package:dormitory_manager/resources/colors.dart';
import 'package:dormitory_manager/resources/dimensions.dart';
import 'package:dormitory_manager/resources/fontsizes.dart';
import 'package:dormitory_manager/ui/widget/close_dialog.dart';
import 'package:dormitory_manager/ui/widget/item_bill.dart';
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
                        onTap: ()=>_showDialog(),
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
          child: SingleChildScrollView(
            child: ItemBill(),
          ),
        ),
      ],
    );
  }
  _showDialog() {
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
                      "Chọn loại tài khoản",
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
            Divider(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppDimensions.d2w),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "Quản lý",
                  style: TextStyle(fontSize: AppFontSizes.fs12),
                ),
              ),
            ),
            Divider(),
            SizedBox(
              height: AppDimensions.d1h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppDimensions.d2w),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "Người thuê",
                  style: TextStyle(fontSize: AppFontSizes.fs12),
                ),
              ),
            ),
            SizedBox(
              height: AppDimensions.d1h,
            ),
          ],
        ));
  }
}
