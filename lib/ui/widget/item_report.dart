import 'package:dormitory_manager/helper/ui_helper.dart';
import 'package:dormitory_manager/resources/colors.dart';
import 'package:dormitory_manager/resources/dimensions.dart';
import 'package:dormitory_manager/resources/fontsizes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'close_dialog.dart';

class ItemReport extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Widget> listItem = [];
    for (int i = 0; i <= 10; i++) {
      listItem.add(Padding(
        padding: EdgeInsets.symmetric(horizontal: AppDimensions.d1h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  'asset/image/report1.png',
                  width: AppDimensions.d10w,
                ),
                SizedBox(
                  width: AppDimensions.d1h,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hong cua",
                        style: TextStyle(
                          color: AppColors.colorBlack_87,
                          fontSize: AppFontSizes.fs12,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        "p001",
                        style: TextStyle(
                            color: AppColors.colorBlack_87,
                            fontSize: AppFontSizes.fs10),
                      ),
                    ],
                  ),
                ),
                Text(
                  "chua sua",
                  style: TextStyle(
                    color: AppColors.colorRed,
                    fontSize: AppFontSizes.fs10,
                  ),
                )
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Người gửi : ABC",
                    style: TextStyle(
                      color: AppColors.colorBlack_87,
                      fontSize: AppFontSizes.fs10,
                    ),
                  ),
                ),
                Text(
                  "Ngày tạo: 2021/10/10",
                  style: TextStyle(
                    color: AppColors.colorBlack_87,
                    fontSize: AppFontSizes.fs10,
                  ),
                )
              ],
            ),
            Divider(),
          ],
        ),
      ));
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: listItem.map<Widget>((item) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => UIHelper.showDialogLogin(
            context: context,
            widget: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppDimensions.d2w),
                  child: Row(
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Sự cố",
                            style: TextStyle(
                                fontSize: AppFontSizes.fs16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.colorOrange),
                          ),
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
                  child: Text(
                    "Hỏng cửa",
                    style: TextStyle(
                      fontSize: AppFontSizes.fs12,
                      color: AppColors.colorBlack_87,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppDimensions.d2w),
                  child: Text(
                    '"dhfjghjdbfgkjdfnbjdfnbkjdnbdk"',
                    style: TextStyle(
                        fontSize: AppFontSizes.fs12,
                        color: AppColors.colorBlack_54),
                  ),
                ),
                Divider(),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppDimensions.d2w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Phòng",
                        style: TextStyle(
                          color: AppColors.colorBlack_87,
                          fontSize: AppFontSizes.fs10,
                        ),
                      ),
                      Text(
                        "P01",
                        style: TextStyle(
                          color: AppColors.colorBlack_87,
                          fontSize: AppFontSizes.fs10,
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppDimensions.d2w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Người gửi",
                        style: TextStyle(
                          color: AppColors.colorBlack_87,
                          fontSize: AppFontSizes.fs10,
                        ),
                      ),
                      Text(
                        "ABC",
                        style: TextStyle(
                          color: AppColors.colorGreen,
                          fontSize: AppFontSizes.fs10,
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppDimensions.d2w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Tạo lúc",
                        style: TextStyle(
                          color: AppColors.colorBlack_87,
                          fontSize: AppFontSizes.fs10,
                        ),
                      ),
                      Text(
                        "2021/101/10",
                        style: TextStyle(
                          color: AppColors.colorBlack_87,
                          fontSize: AppFontSizes.fs10,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: _buildButton(
                          text: "Tiếp nhận",
                          onTap: () {
                            Navigator.pop(context);
                          },
                          color: AppColors.colorOrange),
                    ),
                    Expanded(
                      child: _buildButton(
                          text: "Hoàn thành",
                          onTap: () {
                            Navigator.pop(context);
                          },
                          color: AppColors.colorGreen),
                    )
                  ],
                )
              ],
            ),
          ),
          child: item,
        );
      }).toList()
        ..insert(
            0,
            SizedBox(
              height: AppDimensions.d1h,
            )),
    );
  }

  _buildButton({String text, Function onTap, Color color}) {
    return Padding(
      padding: EdgeInsets.all(AppDimensions.d1h),
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          alignment: Alignment.center,
          width: AppDimensions.d100w,
          decoration: BoxDecoration(
            boxShadow: [],
            color: color,
            borderRadius: BorderRadius.all(
              Radius.circular(AppDimensions.radius1_0w),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(AppDimensions.d2h),
            child: Text(
              text,
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
}
