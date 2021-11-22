import 'package:dormitory_manager/helper/ui_helper.dart';
import 'package:dormitory_manager/resources/colors.dart';
import 'package:dormitory_manager/resources/dimensions.dart';
import 'package:dormitory_manager/resources/fontsizes.dart';
import 'package:dormitory_manager/ui/widget/close_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoginState();
  }
}

class LoginState extends State<Login> {
  String typeAccount = "manager";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: AppDimensions.d100w,
            height: AppDimensions.d30h,
            child: Image.asset(
              'asset/image/logo_login.png',
              fit: BoxFit.fill,
            ),
          ),
          Expanded(
            child: Container(
              width: AppDimensions.d100w,
              decoration: BoxDecoration(
                color: AppColors.colorAppBarDefault,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(AppDimensions.radius2_5w),
                  topRight: Radius.circular(AppDimensions.radius2_5w),
                ),
              ),
              child: Column(
                children: [
                  Text(
                    "Đăng Nhập",
                    style: TextStyle(
                        color: AppColors.colorBlack_54,
                        fontSize: AppFontSizes.fs20,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: AppDimensions.d1h,
                  ),
                  Container(
                    width: AppDimensions.d70w,
                    child: CupertinoTextField(placeholder: "Số điện thoại"),
                  ),
                  SizedBox(
                    height: AppDimensions.d1h,
                  ),
                  Container(
                    width: AppDimensions.d70w,
                    child: CupertinoTextField(
                      placeholder: "Mật khẩu",
                    ),
                  ),
                  SizedBox(
                    height: AppDimensions.d1h,
                  ),
                  GestureDetector(
                    onTap: () => _showDialog(),
                    child: Container(
                        width: AppDimensions.d70w,
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
                              Text(typeAccount),
                              Expanded(
                                child: Container(),
                              ),
                              Icon(
                                Icons.keyboard_arrow_down,
                                color: AppColors.colorGrey_400,
                              )
                            ],
                          ),
                        )),
                  ),
                  SizedBox(
                    height: AppDimensions.d2h,
                  ),
                  GestureDetector(
                    onTap: () {},
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      alignment: Alignment.center,
                      width: AppDimensions.d70w,
                      decoration: BoxDecoration(
                        boxShadow: [],
                        color: AppColors.colorOrange,
                        borderRadius: BorderRadius.all(
                          Radius.circular(AppDimensions.radius1_5w),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(AppDimensions.d2h),
                        child: Text(
                          "Đăng nhập",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.colorWhite,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  _showDialog() {
    return UIHelper.showDialogCommon(context: context,
    widget: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:
          EdgeInsets.symmetric(horizontal: AppDimensions.d2w),
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
          padding:
          EdgeInsets.symmetric(horizontal: AppDimensions.d2w),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              setState(() {
                typeAccount = "Quản lý";
              });
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
          padding:
          EdgeInsets.symmetric(horizontal: AppDimensions.d2w),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              setState(() {
                typeAccount = "Người thuê";
              });
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
    )
    );
  }
}
