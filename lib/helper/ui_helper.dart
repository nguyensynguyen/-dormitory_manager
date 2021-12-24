import 'package:dormitory_manager/resources/colors.dart';
import 'package:dormitory_manager/resources/dimensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';

class UIHelper {
  static showDialogCommon({context, Widget widget}) {
    showAnimatedDialog(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Container(
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

  static showLoadingCommon({context}) {
    showAnimatedDialog(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(AppDimensions.radius2w),
                  topLeft: Radius.circular(AppDimensions.radius2w),
                ),
              ),
              child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.all(
                          Radius.circular(AppDimensions.radius1_0w))),
                  child: LiquidCircularProgressIndicator(
                    value: 0.5,
                    // Defaults to 0.5.
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                    // Defaults to the current Theme's accentColor.
                    backgroundColor: Colors.transparent,
                    // Defaults to the current Theme's backgroundColor.
                    borderColor: Colors.white,
                    borderWidth: 2.0,
                    direction: Axis
                        .vertical, // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.vertical.
                  )),
            ),
          ),
        );
      },
      animationType: DialogTransitionType.slideFromBottomFade,
      curve: Curves.fastOutSlowIn,
      duration: Duration(milliseconds: 500),
    );
  }

  static showDialogLogin({context, Widget widget}) {
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

  static showDialogReport({context, Widget widget}) {
    showAnimatedDialog(
      context: context,
      builder: (BuildContext context) {
        return Scaffold(
          body: Container(
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

  static loading() {
    return  Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(AppDimensions.radius2w),
          topLeft: Radius.circular(AppDimensions.radius2w),
        ),
      ),
      child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.all(
                  Radius.circular(AppDimensions.radius1_0w))),
          child: LiquidCircularProgressIndicator(
            value: 0.5,
            // Defaults to 0.5.
            valueColor: AlwaysStoppedAnimation(Colors.white),
            // Defaults to the current Theme's accentColor.
            backgroundColor: Colors.transparent,
            // Defaults to the current Theme's backgroundColor.
            borderColor: Colors.white,
            borderWidth: 2.0,
            direction: Axis
                .vertical, // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.vertical.
          )),
    );
  }
}
