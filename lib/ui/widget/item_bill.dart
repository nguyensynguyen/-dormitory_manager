import 'package:dormitory_manager/bloc/app_bloc/bloc.dart';
import 'package:dormitory_manager/bloc/bill/bloc.dart';
import 'package:dormitory_manager/bloc/bill/event.dart';
import 'package:dormitory_manager/bloc/bill/state.dart';
import 'package:dormitory_manager/converts/time_format.dart';
import 'package:dormitory_manager/helper/string_helper.dart';
import 'package:dormitory_manager/helper/ui_helper.dart';
import 'package:dormitory_manager/model/room_bill.dart';
import 'package:dormitory_manager/resources/colors.dart';
import 'package:dormitory_manager/resources/dimensions.dart';
import 'package:dormitory_manager/resources/fontsizes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'close_dialog.dart';

class ItemBill extends StatelessWidget {
  BillBloc billBloc;
  AppBloc appBloc;

  ItemBill({this.billBloc, this.appBloc});

  @override
  Widget build(BuildContext context) {
    List<Widget> listItem = [];
    for (int i = 0; i < billBloc.listRoomBill.length; i++) {
      if (appBloc.isUser) {
        if (appBloc.user.roomId == billBloc.listRoomBill[i].room.id) {
          appBloc.roomContract = billBloc.listRoomBill[i].room;
          listItem.add(GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              _showDitailBill(billBloc.listRoomBill[i], context);
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
                        'asset/image/invoice.png',
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
                              "ng??y t???o: ${DateTimeFormat.formatDate(DateTime.fromMillisecondsSinceEpoch(billBloc.listRoomBill[i].dateCreate * 1000))}",
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
                            "${StringHelper.formatCurrency(billBloc.listRoomBill[i].totalPrice)} ??",
                            style: TextStyle(
                                color: AppColors.colorBlack,
                                fontSize: AppFontSizes.fs12,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            billBloc.listRoomBill[i].status == "paid"
                                ? "???? thanh to??n"
                                : "Ch??a thanh to??n",
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
                      Text("Ti???n nh??",
                          style: TextStyle(
                              color: AppColors.colorBlack,
                              fontSize: AppFontSizes.fs11)),
                      Text(
                          "${StringHelper.formatCurrency(billBloc.listRoomBill[i].room.roomAmount)} ??",
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
                      Text("Ti???n d???ch v???",
                          style: TextStyle(
                              color: AppColors.colorBlack,
                              fontSize: AppFontSizes.fs11)),
                      Text(
                          "${StringHelper.formatCurrency(billBloc.listRoomBill[i].totalService)} ??",
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
      } else {
        listItem.add(GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              billBloc.bill = billBloc.listRoomBill[i];
              _showDialog(billBloc, context);
            },
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(AppDimensions.d1h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          'asset/image/invoice.png',
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
                                "ng??y t???o: ${DateTimeFormat.formatDate(DateTime.fromMillisecondsSinceEpoch(billBloc.listRoomBill[i].dateCreate * 1000))}",
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
                              "${StringHelper.formatCurrency(billBloc.listRoomBill[i].totalPrice)} ??",
                              style: TextStyle(
                                  color: AppColors.colorBlack,
                                  fontSize: AppFontSizes.fs12,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              billBloc.listRoomBill[i].status == "paid"
                                  ? "???? thanh to??n"
                                  : "Ch??a thanh to??n",
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
                        Text("Ti???n nh??",
                            style: TextStyle(
                                color: AppColors.colorBlack,
                                fontSize: AppFontSizes.fs11)),
                        Text(
                            "${StringHelper.formatCurrency(billBloc.listRoomBill[i].room.roomAmount)} ??",
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
                        Text("Ti???n d???ch v???",
                            style: TextStyle(
                                color: AppColors.colorBlack,
                                fontSize: AppFontSizes.fs11)),
                        Text(
                            "${StringHelper.formatCurrency(billBloc.listRoomBill[i].totalService)} ??",
                            style: TextStyle(
                                color: AppColors.colorBlack,
                                fontSize: AppFontSizes.fs11)),
                      ],
                    ),
                  ],
                ),
              ),
            )));
      }
    }

    return BlocListener(
      cubit: billBloc,
      listener: (context, state) {
        if (state is UpdateBillState) {
          Fluttertoast.showToast(
              msg: "C???p nh???t th??nh c??ng",
              backgroundColor: AppColors.colorFacebook,
              toastLength:
              Toast.LENGTH_SHORT);
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
                      "C???p nh???t h??a ????n",
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
                child: Text("???? thanh to??n"),
              ),
              Divider(),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  billBloc
                      .add(UpdateBill(id: billBloc.bill.id, status: "unpaid"));
                },
                child: Text("Ch??a thanh to??n"),
              ),
              Divider(),
              GestureDetector(
                onTap: () {
                  // Navigator.pop(context);
                  _showDitailBill(billBloc.bill, context);
                },
                child: Text("Xem chi ti???t h??a ????n"),
              ),
              Divider(),
            ],
          ),
        ),
      ]),
    );
  }

  _showDetail(RoomBill bill) {
    List<Widget> item = [];
    bill.roomBillDetail.forEach((element) {
      item.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "T??n d???ch v???",
                  style: TextStyle(
                    fontSize: AppFontSizes.fs12,
                  ),
                ),
                Text(
                  "${element.serviceName}",
                  style: TextStyle(
                    fontSize: AppFontSizes.fs12,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: AppDimensions.d1h,
            ),
            element.serviceName == "??i???n"
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "S??? l?????ng s??? d???ng",
                        style: TextStyle(
                          fontSize: AppFontSizes.fs12,
                        ),
                      ),
                      Text(
                        "${element.amountUse} s???",
                        style: TextStyle(
                          fontSize: AppFontSizes.fs12,
                        ),
                      ),
                    ],
                  )
                : element.serviceName == "n?????c"
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "S??? l?????ng s??? d???ng",
                            style: TextStyle(
                              fontSize: AppFontSizes.fs12,
                            ),
                          ),
                          Text(
                            "${element.amountUse} s???",
                            style: TextStyle(
                              fontSize: AppFontSizes.fs12,
                            ),
                          ),
                        ],
                      )
                    : Container(),
            SizedBox(
              height: AppDimensions.d1h,
            ),
            element.serviceName == "??i???n"
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "S??? c??",
                        style: TextStyle(
                          fontSize: AppFontSizes.fs12,
                        ),
                      ),
                      Text(
                        "${element.numberStart}",
                        style: TextStyle(
                          fontSize: AppFontSizes.fs12,
                        ),
                      ),
                    ],
                  )
                : element.serviceName == "n?????c"
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "S??? c??",
                            style: TextStyle(
                              fontSize: AppFontSizes.fs12,
                            ),
                          ),
                          Text(
                            "${element.numberStart}",
                            style: TextStyle(
                              fontSize: AppFontSizes.fs12,
                            ),
                          ),
                        ],
                      )
                    : Container(),
            SizedBox(
              height: AppDimensions.d1h,
            ),
            element.serviceName == "??i???n"
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "S??? m???i",
                        style: TextStyle(
                          fontSize: AppFontSizes.fs12,
                        ),
                      ),
                      Text(
                        "${element.numberEnd}",
                        style: TextStyle(
                          fontSize: AppFontSizes.fs12,
                        ),
                      ),
                    ],
                  )
                : element.serviceName == "n?????c"
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "S??? m???i",
                            style: TextStyle(
                              fontSize: AppFontSizes.fs12,
                            ),
                          ),
                          Text(
                            "${element.numberEnd}",
                            style: TextStyle(
                              fontSize: AppFontSizes.fs12,
                            ),
                          ),
                        ],
                      )
                    : Container(),
            SizedBox(
              height: AppDimensions.d1h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "T???ng ti???n s??? d???ng",
                  style: TextStyle(
                    fontSize: AppFontSizes.fs12,
                  ),
                ),
                Text(
                  "${StringHelper.formatCurrency(element.totalPrice)}??",
                  style: TextStyle(
                    fontSize: AppFontSizes.fs12,
                  ),
                ),
              ],
            ),
            Divider()
          ],
        ),
      );
    });
    return Column(
      children: item.map((e) {
        return e;
      }).toList(),
    );
  }

  _showDitailBill(RoomBill bill, BuildContext context) {
    return UIHelper.showDialogLogin(
      context: context,
      widget: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(AppDimensions.d1h),
          child: Container(
            width: AppDimensions.d100w,
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(AppDimensions.d1h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Chi ti???t h??a ????n",
                          style: TextStyle(
                              fontSize: AppFontSizes.fs14,
                              color: AppColors.colorFacebook,
                              fontWeight: FontWeight.bold),
                        ),
                        CloseDialog(
                          onClose: () {
                            Navigator.pop(context);
                          },
                          color: AppColors.colorGrey_400,
                        )
                      ],
                    ),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Ph??ng ",
                          style: TextStyle(
                            fontSize: AppFontSizes.fs12,
                          ),
                        ),
                        Text(
                          "${bill.room.roomName} ",
                          style: TextStyle(
                            fontSize: AppFontSizes.fs12,
                          ),
                        ),
                      ],
                    ),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Ti???n nh?? ",
                          style: TextStyle(
                            fontSize: AppFontSizes.fs12,
                          ),
                        ),
                        Text(
                          "${StringHelper.formatCurrency(bill.room.roomAmount)}??",
                          style: TextStyle(
                            fontSize: AppFontSizes.fs12,
                          ),
                        ),
                      ],
                    ),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Ti???n D???ch v??? ",
                          style: TextStyle(
                            fontSize: AppFontSizes.fs12,
                          ),
                        ),
                        Text(
                          "${StringHelper.formatCurrency(bill.totalService)}??",
                          style: TextStyle(
                            fontSize: AppFontSizes.fs12,
                          ),
                        ),
                      ],
                    ),
                    Divider(),
                    _showDetail(bill),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "T???ng ti???n ph??ng ",
                          style: TextStyle(
                              fontSize: AppFontSizes.fs14,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "${StringHelper.formatCurrency(bill.totalPrice)}??",
                          style: TextStyle(
                              fontSize: AppFontSizes.fs14,
                              color: AppColors.colorOrange,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Divider(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
