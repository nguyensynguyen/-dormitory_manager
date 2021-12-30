import 'package:dormitory_manager/resources/colors.dart';
import 'package:dormitory_manager/resources/dimensions.dart';
import 'package:dormitory_manager/resources/fontsizes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Notifications extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
return _Notification();
  }
}

class _Notification extends State<Notifications>{
  @override
  Widget build(BuildContext context) {
    var heightStatusBar = MediaQuery.of(context).padding.top;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
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
                        "Thông báo",
                        style: TextStyle(
                            color: AppColors.colorWhite,
                            fontSize: AppFontSizes.fs14,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(AppDimensions.d1h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                  ],
                ),
              ),
            ],
          ),
        ),
        // Expanded(
        //   child: SingleChildScrollView(
        //     child: ItemContract(
        //       contractBloc: _contractBloc,
        //     ),
        //   ),
        // ),
      ],
    );
  }

}