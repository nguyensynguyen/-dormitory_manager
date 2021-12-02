import 'package:dormitory_manager/resources/colors.dart';
import 'package:dormitory_manager/resources/dimensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';

class UIHelper{
  static showDialogCommon({context,Widget widget}){
    showAnimatedDialog(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body:Container(
              decoration: BoxDecoration(
                color: AppColors.colorWhite,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(AppDimensions.radius2w),
                  topLeft: Radius.circular(AppDimensions.radius2w),
                ),
              ),
              child: widget ?? Container(),
            ),
          ),
        );
      },
      animationType: DialogTransitionType.slideFromBottomFade,
      curve: Curves.fastOutSlowIn,
      duration: Duration(milliseconds: 500),
    );
}

  static showDialogLogin({context,Widget widget}){
    showAnimatedDialog(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Container(
                    color: Colors.transparent,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.colorWhite,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(AppDimensions.radius2w),
                      topLeft: Radius.circular(AppDimensions.radius2w),
                    ),
                  ),
                  child: widget ?? Container(),
                ),
              ],
            ),
          ),
        );
      },
      animationType: DialogTransitionType.slideFromBottomFade,
      curve: Curves.fastOutSlowIn,
      duration: Duration(milliseconds: 500),
    );
  }

  static showDialogReport({context,Widget widget}){
    showAnimatedDialog(
      context: context,
      builder: (BuildContext context) {
        return Scaffold(
          body:Container(
            decoration: BoxDecoration(
              color: AppColors.colorWhite,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(AppDimensions.radius2w),
                topLeft: Radius.circular(AppDimensions.radius2w),
              ),
            ),
            child: widget ?? Container(),
          ),
        );
      },
      animationType: DialogTransitionType.slideFromBottomFade,
      curve: Curves.fastOutSlowIn,
      duration: Duration(milliseconds: 500),
    );
  }
}