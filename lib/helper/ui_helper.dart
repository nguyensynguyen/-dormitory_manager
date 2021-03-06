import 'package:dormitory_manager/resources/colors.dart';
import 'package:dormitory_manager/resources/dimensions.dart';
import 'package:dormitory_manager/resources/fontsizes.dart';
import 'package:dormitory_manager/ui/widget/close_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class UIHelper {
  static showDialogCommon({context, Widget widget, Color color, bool isFull}) {
    if (isFull == null) {
      isFull = false;
    }
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

  static showDialogLogin1({context, Widget widget}) {
    showAnimatedDialog(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                    color: Colors.transparent,
                  ),

                Expanded(
                  child: Container(
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
    return Container(
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
              borderRadius:
                  BorderRadius.all(Radius.circular(AppDimensions.radius1_0w))),
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

  static showDateTime({Function ok, Function cancel, BuildContext context}) {
    return showAnimatedDialog(
        context: context,
        builder: (BuildContext context) {
          return Scaffold(
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
                  height: AppDimensions.d20h,
                  width: AppDimensions.d50w,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                          Radius.circular(AppDimensions.radius1_0w))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: AppDimensions.d0_5h,
                      ),
                      Text(
                        "Ch???n ng??y h???n",
                        style: TextStyle(color: Colors.red),
                      ),
                      CupertinoDatePicker(
                        onDateTimeChanged: (time) {},
                      ),
                      Padding(
                        padding: EdgeInsets.all(AppDimensions.d2w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: ok,
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(
                                              AppDimensions.radius1_0w)),
                                      border:
                                          Border.all(color: Colors.grey[300])),
                                  child: Text("Ok"),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: cancel,
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(
                                              AppDimensions.radius1_0w)),
                                      border:
                                          Border.all(color: Colors.grey[300])),
                                  child: Text("Cancel"),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )),
            ),
          );
        });
  }

  static showConfirmDialog(
      {String message, Function ok, Function cancel, BuildContext context}) {
    return showAnimatedDialog(
        context: context,
        builder: (BuildContext context) {
          return Scaffold(
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
                  height: AppDimensions.d12h,
                  width: AppDimensions.d50w,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                          Radius.circular(AppDimensions.radius1_0w))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: AppDimensions.d0_5h,
                      ),
                      Text(
                        message,
                        style: TextStyle(color: Colors.red),
                      ),
                      Padding(
                        padding: EdgeInsets.all(AppDimensions.d2w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: ok,
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(
                                              AppDimensions.radius1_0w)),
                                      border:
                                          Border.all(color: Colors.grey[300])),
                                  child: Text("Ok"),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: cancel,
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(
                                              AppDimensions.radius1_0w)),
                                      border:
                                          Border.all(color: Colors.grey[300])),
                                  child: Text("Cancel"),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )),
            ),
          );
        });
  }

  static showChangePass(
      {String message,
        Widget widget,
      Function onTap,
      BuildContext context,
      TextEditingController oldPass,
      TextEditingController newPass}) {
    return showAnimatedDialog(
        context: context,
        builder: (BuildContext context) {
          return Scaffold(
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
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.all(
                          Radius.circular(AppDimensions.radius1_0w))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          child: Container(
                        color: Colors.transparent,
                      )),
                      Container(
                        width: AppDimensions.d100w,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(
                                Radius.circular(AppDimensions.radius1_0w))),
                        child: widget,
                      ),
                      Expanded(
                          child: Container(
                        color: Colors.transparent,
                      )),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
