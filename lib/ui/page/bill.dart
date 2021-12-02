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

class Bill extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return BillState();
  }
}

class BillState extends State<Bill> {
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
                        "Hóa đơn",
                        style: TextStyle(
                            color: AppColors.colorWhite,
                            fontSize: AppFontSizes.fs14,
                            fontWeight: FontWeight.bold),
                      ),
                      GestureDetector(
                          child: Icon(
                        Icons.filter_list,
                        color: AppColors.colorWhite,
                      ))
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
                      "10/2021",
                      style: TextStyle(
                          color: AppColors.colorWhite,
                          fontSize: AppFontSizes.fs12),
                    ),
                    Text(
                      "11/2021",
                      style: TextStyle(
                          color: AppColors.colorWhite,
                          fontSize: AppFontSizes.fs12),
                    ),
                    Text(
                      "12/2021",
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
        Container(
          width: AppDimensions.d100w,
          height: AppDimensions.d10h,
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
              topLeft: Radius.circular(AppDimensions.radius3w),
              topRight: Radius.circular(AppDimensions.radius3w),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppDimensions.d2h),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Tổng tiền",
                        style: TextStyle(
                            color: AppColors.colorWhite,
                            fontSize: AppFontSizes.fs12),
                      ),
                      SizedBox(
                        height: AppDimensions.d1h,
                      ),
                      Text(
                        "14.000.000 đ",
                        style: TextStyle(
                            color: AppColors.colorWhite,
                            fontSize: AppFontSizes.fs12,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => UIHelper.showDialogCommon(
                      context: context,
                      widget: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "Lập hóa đơn",
                                  style: TextStyle(
                                      color: AppColors.colorBlack_87,
                                      fontSize: AppFontSizes.fs14,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              CloseDialog(
                                color: AppColors.colorBlack_38,
                                onClose: () => Navigator.pop(context),
                              ),
                            ],
                          ),
                          Divider(),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildTop(),
                                  Divider(),
                                  _buildfirst(),
                                  Divider(),
                                  _buildSecond(),
                                  Divider(),
                                  _buildBottom(),
                                  Divider(),
                                  _buildButton()
                                ],
                              ),
                            ),
                          )
                        ],
                      )),
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: AppColors.colorWhite),
                        borderRadius:
                            BorderRadius.circular(AppDimensions.radius1_0w)),
                    child: Padding(
                      padding: EdgeInsets.all(AppDimensions.d1h),
                      child: Text(
                        "Lập hóa đơn",
                        style: TextStyle(
                            color: AppColors.colorWhite,
                            fontSize: AppFontSizes.fs12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  _buildTop() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppDimensions.d1h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Thông tin hóa đơn",
            style: TextStyle(
              color: AppColors.colorBlack_87,
              fontSize: AppFontSizes.fs14,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "Nhập đầy đủ thông tin vào đây",
            style: TextStyle(
              color: AppColors.colorBlack_87,
              fontSize: AppFontSizes.fs10,
            ),
          ),
        ],
      ),
    );
  }

  _buildfirst() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppDimensions.d2h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Tháng chốt *",
            style: TextStyle(
              color: AppColors.colorBlack,
              fontSize: AppFontSizes.fs12,
            ),
          ),
          SizedBox(
            height: AppDimensions.d1h,
          ),
          GestureDetector(
            onTap: () => _showDialog(),
            child: Container(
                width: AppDimensions.d100w,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.colorGrey_300),
                  borderRadius: BorderRadius.all(
                    Radius.circular(AppDimensions.radius1_5w),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(AppDimensions.d1h),
                  child: Row(
                    children: [
                      Text("11/2021"),
                      Expanded(
                        child: Container(),
                      ),
                      Icon(
                        Icons.content_paste,
                        color: AppColors.colorGrey_400,
                      )
                    ],
                  ),
                )),
          ),
          SizedBox(
            height: AppDimensions.d1h,
          ),
          Text(
            "Phòng *",
            style: TextStyle(
              color: AppColors.colorBlack,
              fontSize: AppFontSizes.fs12,
            ),
          ),
          SizedBox(
            height: AppDimensions.d1h,
          ),
          GestureDetector(
            onTap: () => _showDialog(),
            child: Container(
              width: AppDimensions.d100w,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.colorGrey_300),
                borderRadius: BorderRadius.all(
                  Radius.circular(AppDimensions.radius1_5w),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(AppDimensions.d1h),
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
        ],
      ),
    );
  }

  _buildSecond() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppDimensions.d2h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Dịch vụ sử dụng",
            style: TextStyle(
              color: AppColors.colorBlack_87,
              fontSize: AppFontSizes.fs14,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "Hãy chọn dịch vụ khách sử dụng",
            style: TextStyle(
              color: AppColors.colorBlack_87,
              fontSize: AppFontSizes.fs10,
            ),
          ),
          //điện
          SizedBox(
            height: AppDimensions.d1h,
          ),
          Row(
            children: [
              Icon(
                Icons.check_circle,
                color: AppColors.colorOrange,
                size: AppFontSizes.fs18,
              ),
              SizedBox(
                width: AppDimensions.d0_5h,
              ),
              RichText(
                text: TextSpan(children: <TextSpan>[
                  TextSpan(
                    text: "Điện\n",
                    style: TextStyle(
                      color: AppColors.colorBlack_87,
                      fontSize: AppFontSizes.fs10,
                    ),
                  ),
                  TextSpan(
                    text: "3.000 đ/kwh",
                    style: TextStyle(
                      color: AppColors.colorBlack_87,
                      fontSize: AppFontSizes.fs8,
                    ),
                  ),
                ]),
              ),
            ],
          ),
          SizedBox(
            height: AppDimensions.d1h,
          ),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Số cũ *",
                      style: TextStyle(
                        color: AppColors.colorBlack_87,
                        fontSize: AppFontSizes.fs10,
                      ),
                    ),
                    Container(
                      child: CupertinoTextField(),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: AppDimensions.d1h,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Số mới *",
                      style: TextStyle(
                        color: AppColors.colorBlack_87,
                        fontSize: AppFontSizes.fs10,
                      ),
                    ),
                    Container(
                      child: CupertinoTextField(),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: AppDimensions.d1h,
          ),
          RichText(
            text: TextSpan(children: <TextSpan>[
              TextSpan(
                text: "Thành Tiền ",
                style: TextStyle(
                  color: AppColors.colorBlack_87,
                  fontSize: AppFontSizes.fs10,
                ),
              ),
              TextSpan(
                text: "3.000.000 đ",
                style: TextStyle(
                    color: AppColors.colorBlack_87,
                    fontSize: AppFontSizes.fs10,
                    fontWeight: FontWeight.bold),
              ),
            ]),
          ),
//nước
          Divider(),
          Row(
            children: [
              Icon(
                Icons.check_circle,
                color: AppColors.colorOrange,
                size: AppFontSizes.fs18,
              ),
              SizedBox(
                width: AppDimensions.d0_5h,
              ),
              RichText(
                text: TextSpan(children: <TextSpan>[
                  TextSpan(
                    text: "Nước\n",
                    style: TextStyle(
                      color: AppColors.colorBlack_87,
                      fontSize: AppFontSizes.fs10,
                    ),
                  ),
                  TextSpan(
                    text: "20.000 đ/m3",
                    style: TextStyle(
                      color: AppColors.colorBlack_87,
                      fontSize: AppFontSizes.fs8,
                    ),
                  ),
                ]),
              ),
            ],
          ),
          SizedBox(
            height: AppDimensions.d1h,
          ),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Số cũ *",
                      style: TextStyle(
                        color: AppColors.colorBlack_87,
                        fontSize: AppFontSizes.fs10,
                      ),
                    ),
                    Container(
                      child: CupertinoTextField(),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: AppDimensions.d1h,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Số mới *",
                      style: TextStyle(
                        color: AppColors.colorBlack_87,
                        fontSize: AppFontSizes.fs10,
                      ),
                    ),
                    Container(
                      child: CupertinoTextField(),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: AppDimensions.d1h,
          ),
          RichText(
            text: TextSpan(children: <TextSpan>[
              TextSpan(
                text: "Thành Tiền ",
                style: TextStyle(
                  color: AppColors.colorBlack_87,
                  fontSize: AppFontSizes.fs10,
                ),
              ),
              TextSpan(
                text: "3.000.000 đ",
                style: TextStyle(
                    color: AppColors.colorBlack_87,
                    fontSize: AppFontSizes.fs10,
                    fontWeight: FontWeight.bold),
              ),
            ]),
          ),

          //vệ sinh
          Divider(),
          Row(
            children: [
              Icon(
                Icons.check_circle,
                color: AppColors.colorOrange,
                size: AppFontSizes.fs18,
              ),
              SizedBox(
                width: AppDimensions.d0_5h,
              ),
              RichText(
                text: TextSpan(children: <TextSpan>[
                  TextSpan(
                    text: "Vệ sinh\n",
                    style: TextStyle(
                      color: AppColors.colorBlack_87,
                      fontSize: AppFontSizes.fs10,
                    ),
                  ),
                  TextSpan(
                    text: "40.000 đ",
                    style: TextStyle(
                      color: AppColors.colorBlack_87,
                      fontSize: AppFontSizes.fs8,
                    ),
                  ),
                ]),
              ),
            ],
          ),
          SizedBox(
            height: AppDimensions.d1h,
          ),
          RichText(
            text: TextSpan(children: <TextSpan>[
              TextSpan(
                text: "Thành Tiền ",
                style: TextStyle(
                  color: AppColors.colorBlack_87,
                  fontSize: AppFontSizes.fs10,
                ),
              ),
              TextSpan(
                text: "40.000 đ",
                style: TextStyle(
                    color: AppColors.colorBlack_87,
                    fontSize: AppFontSizes.fs10,
                    fontWeight: FontWeight.bold),
              ),
            ]),
          ),

          //Gửi xe
          Divider(),
          Row(
            children: [
              Icon(
                Icons.check_circle,
                color: AppColors.colorOrange,
                size: AppFontSizes.fs18,
              ),
              SizedBox(
                width: AppDimensions.d0_5h,
              ),
              RichText(
                text: TextSpan(children: <TextSpan>[
                  TextSpan(
                    text: "Gửi xe\n",
                    style: TextStyle(
                      color: AppColors.colorBlack_87,
                      fontSize: AppFontSizes.fs10,
                    ),
                  ),
                  TextSpan(
                    text: "50.000 đ",
                    style: TextStyle(
                      color: AppColors.colorBlack_87,
                      fontSize: AppFontSizes.fs8,
                    ),
                  ),
                ]),
              ),
            ],
          ),
          SizedBox(
            height: AppDimensions.d1h,
          ),
          RichText(
            text: TextSpan(children: <TextSpan>[
              TextSpan(
                text: "Thành Tiền ",
                style: TextStyle(
                  color: AppColors.colorBlack_87,
                  fontSize: AppFontSizes.fs10,
                ),
              ),
              TextSpan(
                text: "50.000 đ",
                style: TextStyle(
                    color: AppColors.colorBlack_87,
                    fontSize: AppFontSizes.fs10,
                    fontWeight: FontWeight.bold),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  _buildBottom() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppDimensions.d1h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Tổng hợp",
            style: TextStyle(
              color: AppColors.colorBlack_87,
              fontSize: AppFontSizes.fs14,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "Xem lại thông tin trước khi xác nhận",
            style: TextStyle(
              color: AppColors.colorBlack_87,
              fontSize: AppFontSizes.fs10,
            ),
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Tổng tiền"),
              Text(
                "7.500.000 đ",
                style: TextStyle(
                    fontSize: AppFontSizes.fs12,
                    color: AppColors.colorOrange,
                    fontWeight: FontWeight.bold),
              ),
            ],
          )
        ],
      ),
    );
  }

  _buildButton() {
    return Padding(
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
              "Xác nhận",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.colorWhite,
              ),
            ),
          ),
        ),
      ),
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
                  "p102",
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
                  "p103",
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
