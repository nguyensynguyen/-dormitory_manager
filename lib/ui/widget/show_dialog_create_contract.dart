import 'package:dormitory_manager/bloc/app_bloc/bloc.dart';
import 'package:dormitory_manager/bloc/contract/bloc.dart';
import 'package:dormitory_manager/converts/time_format.dart';
import 'package:dormitory_manager/helper/ui_helper.dart';
import 'package:dormitory_manager/resources/colors.dart';
import 'package:dormitory_manager/resources/dimensions.dart';
import 'package:dormitory_manager/resources/fontsizes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dormitory_manager/bloc/contract/event.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'close_dialog.dart';

class CreateContract extends StatelessWidget {
  ContractBloc contractBloc;
  AppBloc appBloc;

  CreateContract({this.contractBloc, this.appBloc});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _intput(
            hintText: "Nhập tên", title: "Tên", textEditingController: null),
        _intput(
            hintText: "Nhập email",
            title: "Email",
            textEditingController: null),
        _intput(
            hintText: "nhập chứng minh thư",
            title: "Số chứng minh thư",
            textEditingController: null),
        _intput(
            hintText: "nhập địa chỉ",
            title: "Địa chỉ",
            textEditingController: null),
        _intput(
            hintText: "nhập số điện thoại",
            title: "Số điện thoại",
            textEditingController: null),
        _intput(
            hintText: "nhập mật khẩu",
            title: "Mật khẩu",
            textEditingController: null),
        _noneInput(
            title: "Chọn phòng",
            onTap: () {
              _showDialogListRoom(appBloc: appBloc, context: context);
            }),
        SizedBox(
          height: AppDimensions.d1h,
        ),
        _noneInputDate(
            title: "Ngày sinh",
            onTap: () async {
              DateTime time = await _showDateTime(context);
              if (time != null) {
                contractBloc.user.birthDay =
                    time.millisecondsSinceEpoch ~/ 1000;
              }
              contractBloc.add(UpdateUIContractEvent());
            },
            text: contractBloc.user.birthDay == null
                ? ""
                : "${DateTimeFormat.formatDate(
                    DateTime.fromMillisecondsSinceEpoch(
                        contractBloc.user.birthDay * 1000),
                  )}"),
        SizedBox(
          height: AppDimensions.d1h,
        ),
        _noneInputDate(
            title: "Ngày đến",
            onTap: () async {
              DateTime time = await _showDateTime(context);
              if (time != null) {
                contractBloc.user.registrationDate =
                    time.millisecondsSinceEpoch ~/ 1000;
              }
              contractBloc.add(UpdateUIContractEvent());
            },
            text: contractBloc.user.registrationDate == null
                ? ""
                : "${DateTimeFormat.formatDate(DateTime.fromMillisecondsSinceEpoch(contractBloc.user.registrationDate * 1000))}"),
        SizedBox(
          height: AppDimensions.d1h,
        ),
        _noneInputDate(
            title: "Ngày hết hạn",
            onTap: () async {
              DateTime time = await _showDateTime(context);
              if (time != null) {
                contractBloc.user.expirationDate =
                    time.millisecondsSinceEpoch ~/ 1000;
              }
              contractBloc.add(UpdateUIContractEvent());
            },
            text: contractBloc.user.expirationDate == null
                ? ""
                : "${DateTimeFormat.formatDate(DateTime.fromMillisecondsSinceEpoch(contractBloc.user.expirationDate * 1000))}"),
        _buildButton(ontap: () {})
      ],
    );
  }

  _intput(
      {String title,
      String hintText,
      TextEditingController textEditingController}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
              color: AppColors.colorBlack_87,
              fontSize: AppFontSizes.fs12,
              fontWeight: FontWeight.bold),
        ),
        Container(
          child: CupertinoTextField(
            controller: textEditingController,
            placeholder: hintText,
            placeholderStyle:
                TextStyle(color: Colors.grey, fontSize: AppFontSizes.fs12),
          ),
        ),
        SizedBox(
          height: AppDimensions.d1h,
        ),
      ],
    );
  }

  _showDialogListRoom({AppBloc appBloc, BuildContext context}) {
    List<Widget> widget = []..insert(
        0,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppDimensions.d2w),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  "Chọn phòng",
                  style: TextStyle(
                      fontSize: AppFontSizes.fs14, fontWeight: FontWeight.bold),
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
      );
    for (int i = 0; i < appBloc.listAllDataRoom.length; i++) {
      widget.add(Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: AppDimensions.d1h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppDimensions.d2w),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                contractBloc.room = appBloc.listAllDataRoom[i];
                // appBloc.index = i;
                Navigator.pop(context);
                contractBloc.add(UpdateUIContractEvent());
              },
              child: Text(
                "${appBloc.listAllDataRoom[i].roomName}",
                style: TextStyle(fontSize: AppFontSizes.fs12),
              ),
            ),
          ),
          Divider(),
          SizedBox(
            height: AppDimensions.d1h,
          ),
        ],
      ));
    }
    return UIHelper.showDialogLogin(
      context: context,
      widget: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: widget.map<Widget>((e) {
            return e;
          }).toList(),
        ),
      ),
    );
  }

  _noneInputDate({String title, Function onTap, String text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${title} *",
          style: TextStyle(
            color: AppColors.colorBlack_87,
            fontSize: AppFontSizes.fs10,
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: AppDimensions.d100w,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.colorGrey_300),
              borderRadius: BorderRadius.all(
                Radius.circular(AppDimensions.radius1_5w),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(AppDimensions.d1h),
              child: Row(
                children: [
                  Text(text ?? ""),
                  Expanded(
                    child: Container(),
                  ),
                  Icon(
                    Icons.keyboard_arrow_down,
                    color: AppColors.colorGrey_400,
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  _noneInput({String title, Function onTap}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${title} *",
          style: TextStyle(
            color: AppColors.colorBlack_87,
            fontSize: AppFontSizes.fs10,
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: AppDimensions.d100w,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.colorGrey_300),
              borderRadius: BorderRadius.all(
                Radius.circular(AppDimensions.radius1_5w),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(AppDimensions.d1h),
              child: Row(
                children: [
                  Text(contractBloc.room?.roomName ?? ""),
                  Expanded(
                    child: Container(),
                  ),
                  Icon(
                    Icons.keyboard_arrow_down,
                    color: AppColors.colorGrey_400,
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  _buildButton({Function ontap}) {
    return Padding(
      padding: EdgeInsets.all(AppDimensions.d1h),
      child: GestureDetector(
        onTap: ontap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          alignment: Alignment.center,
          width: AppDimensions.d100w,
          decoration: BoxDecoration(
            boxShadow: [],
            color: AppColors.colorOrange,
            borderRadius: BorderRadius.all(
              Radius.circular(AppDimensions.radius1_0w),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(AppDimensions.d2h),
            child: Text(
              "Xác nhận",
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

  Future<DateTime> _showDateTime(BuildContext context) {
    return DatePicker.showDatePicker(context,
        showTitleActions: true,
        minTime: DateTime(1930, 6, 7),
        maxTime: DateTime.now(),
        onChanged: (date) {},
        onConfirm: (date) {},
        currentTime: DateTime(2000, 6, 7),
        locale: LocaleType.vi);
  }
}
