import 'package:dormitory_manager/bloc/contract/bloc.dart';
import 'package:dormitory_manager/bloc/contract/event.dart';
import 'package:dormitory_manager/converts/time_format.dart';
import 'package:dormitory_manager/helper/string_helper.dart';
import 'package:dormitory_manager/helper/ui_helper.dart';
import 'package:dormitory_manager/resources/colors.dart';
import 'package:dormitory_manager/resources/dimensions.dart';
import 'package:dormitory_manager/resources/fontsizes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

import 'close_dialog.dart';

class ItemContract extends StatelessWidget {
  ContractBloc contractBloc;

  ItemContract({this.contractBloc});

  @override
  Widget build(BuildContext context) {
    return _buildItem(context);
  }

  _buildItem(BuildContext context) {
    List<Widget> widget = [];
    for (int i = 0; i < contractBloc.listContract.length; i++) {
      widget.add(GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          print("ok");
        },
        child: Container(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppDimensions.d1h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: AppDimensions.d0_5h,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        contractBloc.user = contractBloc.listContract[i];
                        _showDialogSelect(context, index: i);
                      },
                      child: Image.asset(
                        'asset/image/add.png',
                        width: AppDimensions.d8w,
                        color: AppColors.colorFacebook,
                      ),
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
                            "${contractBloc.listContract[i].userName}",
                            style: TextStyle(
                                color: AppColors.colorBlack,
                                fontSize: AppFontSizes.fs12,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "${contractBloc.listContract[i].room['room_name']}",
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
                          "Sdt: 0${contractBloc.listContract[i].phone}",
                          style: TextStyle(
                            color: AppColors.colorBlack,
                            fontSize: AppFontSizes.fs12,
                          ),
                        ),
                        Text(
                          contractBloc.listContract[i].expirationDate -
                                      DateTime.now().millisecondsSinceEpoch ~/
                                          1000 <
                                  0
                              ? "Hết hạn hợp đồng"
                              : "Còn hạn hợp đồng",
                          style: TextStyle(
                            color: contractBloc.listContract[i].expirationDate -
                                        DateTime.now().millisecondsSinceEpoch ~/
                                            1000 <
                                    0
                                ? AppColors.colorRed
                                : AppColors.colorGreen,
                            fontSize: AppFontSizes.fs10,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: AppDimensions.d1h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Ngày đến ",
                        style: TextStyle(
                            color: AppColors.colorBlack,
                            fontSize: AppFontSizes.fs11)),
                    Text(
                        "${DateTimeFormat.formatDate(DateTime.fromMillisecondsSinceEpoch(contractBloc.listContract[i].registrationDate * 1000))}",
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
                    Text("Ngày hết hạn",
                        style: TextStyle(
                            color: AppColors.colorBlack,
                            fontSize: AppFontSizes.fs11)),
                    Text(
                        "${DateTimeFormat.formatDate(DateTime.fromMillisecondsSinceEpoch(contractBloc.listContract[i].expirationDate * 1000))}",
                        style: TextStyle(
                            color: AppColors.colorBlack,
                            fontSize: AppFontSizes.fs11)),
                  ],
                ),
                Divider(),
              ],
            ),
          ),
        ),
      ));
    }
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widget.map<Widget>((e) {
          return e;
        }).toList());
  }

  _showDialogSelect(BuildContext context, {int index}) {
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
                  _showDateTime(context);
                },
                child: Text("Gia hạn hợp đồng"),
              ),
              Divider(),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  _showConfirm(context, index: index);
                },
                child: Text("Xóa hợp đồng"),
              ),
              Divider(),
            ],
          ),
        ),
      ]),
    );
  }

  _showConfirm(BuildContext context, {int index}) {
    return UIHelper.showConfirmDialog(
        context: context,
        message: "Xác nhận xóa hợp đồng",
        ok: () {
          contractBloc.add(DeleteContractEvent(index: index));
          Navigator.pop(context);
        },
        cancel: () {
          Navigator.pop(context);
        });
  }

  _showDateTime(BuildContext context, {int index}) {
    return DatePicker.showDatePicker(context,
        showTitleActions: true,
        minTime: DateTime.now(),
        maxTime: DateTime(2071, 6, 7),
        onChanged: (date) {}, onConfirm: (date) {
      contractBloc.add(ExtendContractEvent(
          id: contractBloc.user.id,
          dateTime: date.millisecondsSinceEpoch ~/ 1000));
    }, currentTime: DateTime.now(), locale: LocaleType.vi);
  }
}
