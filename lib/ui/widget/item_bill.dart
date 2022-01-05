import 'package:dormitory_manager/bloc/bill/bloc.dart';
import 'package:dormitory_manager/bloc/bill/event.dart';
import 'package:dormitory_manager/bloc/bill/state.dart';
import 'package:dormitory_manager/converts/time_format.dart';
import 'package:dormitory_manager/helper/string_helper.dart';
import 'package:dormitory_manager/helper/ui_helper.dart';
import 'package:dormitory_manager/resources/colors.dart';
import 'package:dormitory_manager/resources/dimensions.dart';
import 'package:dormitory_manager/resources/fontsizes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'close_dialog.dart';

class ItemBill extends StatelessWidget {
  BillBloc billBloc;

  ItemBill({this.billBloc});

  @override
  Widget build(BuildContext context) {
    List<Widget> listItem = [];
    for (int i = 0; i < billBloc.listRoomBill.length; i++) {
      listItem.add(GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          billBloc.bill = billBloc.listRoomBill[i];
          _showDialog(billBloc, context);
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppDimensions.d1h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    'asset/image/bill.png',
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
                          "ngày tạo: ${DateTimeFormat.formatDate(DateTime.fromMillisecondsSinceEpoch(billBloc.listRoomBill[i].dateCreate * 1000))}",
                          style: TextStyle(
                              color: AppColors.colorBlack_38,
                              fontSize: AppFontSizes.fs10),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "${StringHelper.formatCurrency(billBloc.listRoomBill[i].totalPrice)} đ",
                        style: TextStyle(
                            color: AppColors.colorBlack,
                            fontSize: AppFontSizes.fs12,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        billBloc.listRoomBill[i].status == "paid"
                            ? "Đã thanh toán"
                            : "Chưa thanh toán",
                        style: TextStyle(
                          color: billBloc.listRoomBill[i].status == "paid"
                              ? AppColors.colorGreen
                              : AppColors.colorRed,
                          fontSize: AppFontSizes.fs10,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(
                height: AppDimensions.d1h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Tiền nhà",
                      style: TextStyle(
                          color: AppColors.colorBlack,
                          fontSize: AppFontSizes.fs11)),
                  Text(
                      "${StringHelper.formatCurrency(billBloc.listRoomBill[i].room.roomAmount)} đ",
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
                  Text("Tiền dịch vụ",
                      style: TextStyle(
                          color: AppColors.colorBlack,
                          fontSize: AppFontSizes.fs11)),
                  Text(
                      "${StringHelper.formatCurrency(billBloc.listRoomBill[i].totalService)} đ",
                      style: TextStyle(
                          color: AppColors.colorBlack,
                          fontSize: AppFontSizes.fs11)),
                ],
              ),
              Divider(),
            ],
          ),
        ),
      ));

    }

    return BlocListener(
      cubit: billBloc,
      listener: (context, state) {
        if (state is UpdateBillState) {
          Navigator.pop(context);
        }
        if (state is LoadingUpdateBillState) {
          UIHelper.showLoadingCommon(context: context);
        }
      },
      child: Column(
        children: listItem.map<Widget>((item) {
          return item;
        }).toList()
          ..insert(
              0,
              SizedBox(
                height: AppDimensions.d1h,
              )),
      ),
    );
  }

  _showDialog(BillBloc billBloc, BuildContext context) {
    return UIHelper.showDialogLogin(
      context: context,
      widget: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppDimensions.d2w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "Cập nhật hóa đơn",
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
              Divider(),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  billBloc
                      .add(UpdateBill(id: billBloc.bill.id, status: "paid"));
                },
                child: Text("Đã thanh toán"),
              ),
              Divider(),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  billBloc
                      .add(UpdateBill(id: billBloc.bill.id, status: "unpaid"));
                },
                child: Text("Chưa thanh toán"),
              ),
              Divider(),
            ],
          ),
        ),
      ]),
    );
  }
}
