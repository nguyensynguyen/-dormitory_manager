import 'package:dormitory_manager/bloc/bill/bloc.dart';
import 'package:dormitory_manager/helper/ui_helper.dart';
import 'package:dormitory_manager/resources/colors.dart';
import 'package:dormitory_manager/resources/dimensions.dart';
import 'package:dormitory_manager/resources/fontsizes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ItemBill extends StatelessWidget {
  BillBloc billBloc;
  ItemBill({this.billBloc});
  @override
  Widget build(BuildContext context) {
    List<Widget> listItem = [];
    for (int i = 0; i < billBloc.listRoomBill.length; i++) {
      listItem.add(Padding(
        padding: EdgeInsets.symmetric(horizontal: AppDimensions.d1h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  'asset/image/user.png',
                  width: AppDimensions.d8w,
                ),
                SizedBox(
                  width: AppDimensions.d1h,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${billBloc.listRoomBill[i].room.roomName}",
                        style: TextStyle(
                            color: AppColors.colorBlack,
                            fontSize: AppFontSizes.fs12),
                      ),
                      Text(
                        "ngày tạo:${billBloc.listRoomBill[i].dateCreate}",
                        style: TextStyle(
                            color: AppColors.colorBlack_38,
                            fontSize: AppFontSizes.fs10),
                      ),
                    ],
                  ),
                ),
                Text("${billBloc.listRoomBill[i].totalPrice} đ",
                    style: TextStyle(
                        color: AppColors.colorBlack,
                        fontSize: AppFontSizes.fs12,
                        fontWeight: FontWeight.bold))
              ],
            ),
            SizedBox(
              height: AppDimensions.d1h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Tien nha",
                    style: TextStyle(
                        color: AppColors.colorBlack,
                        fontSize: AppFontSizes.fs11)),
                Text("${billBloc.listRoomBill[i].room.roomAmount} đ",
                    style: TextStyle(
                        color: AppColors.colorBlack,
                        fontSize: AppFontSizes.fs11)),
              ],
            ),
            SizedBox(
              height: AppDimensions.d1h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("tien dich vu",
                    style: TextStyle(
                        color: AppColors.colorBlack,
                        fontSize: AppFontSizes.fs11)),
                Text("${billBloc.listRoomBill[i].totalService} đ",
                    style: TextStyle(
                        color: AppColors.colorBlack,
                        fontSize: AppFontSizes.fs11)),
              ],
            ),
            Divider(),
          ],
        ),
      ));
    }
    return Column(
      children: listItem.map<Widget>((item) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => UIHelper.showDialogCommon(
              context: context, widget: Text("okokkoko")),
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
}
