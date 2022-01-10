import 'package:dormitory_manager/bloc/app_bloc/bloc.dart';
import 'package:dormitory_manager/bloc/contract/bloc.dart';
import 'package:dormitory_manager/bloc/contract/state.dart';
import 'package:dormitory_manager/converts/time_format.dart';
import 'package:dormitory_manager/helper/input_format.dart';
import 'package:dormitory_manager/helper/ui_helper.dart';
import 'package:dormitory_manager/resources/colors.dart';
import 'package:dormitory_manager/resources/dimensions.dart';
import 'package:dormitory_manager/resources/fontsizes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dormitory_manager/bloc/contract/event.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'close_dialog.dart';

class CreateContract extends StatelessWidget {
  ContractBloc contractBloc;
  AppBloc appBloc;
  final List<TextInputFormatter> _formatter = [NumberFormat()];
  final List<TextInputFormatter> _formatter1 = [NumberFormat(isInt: true)];

  CreateContract({this.contractBloc, this.appBloc});

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      cubit: contractBloc,
      listener: (context, state) {
        if (state is LoadingCreateContractState) {
          UIHelper.showLoadingCommon(context: context);
        }
        if (state is CreateContractDoneState) {
          Navigator.pop(context);
          Fluttertoast.showToast(
              msg: "Tạo thành công", toastLength: Toast.LENGTH_LONG);
        }

        if (state is CreateContractErrorsState) {
          Navigator.pop(context);
          Fluttertoast.showToast(
              msg: contractBloc.messageErrors, toastLength: Toast.LENGTH_LONG);
        }
      },
      child: BlocBuilder(
        cubit: contractBloc,
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _intput(
                  hintText: "Nhập tên",
                  title: "Tên",
                  textEditingController: contractBloc.name),
              _intput(
                  hintText: "Nhập email",
                  title: "Email",
                  textEditingController: contractBloc.mail),
              _intput(
                  hintText: "nhập chứng minh thư",
                  title: "Số chứng minh thư",
                  formatter1: _formatter1,
                  textEditingController: contractBloc.idCard),
              _intput(
                  hintText: "nhập địa chỉ",
                  title: "Địa chỉ",
                  textEditingController: contractBloc.address),
              _intput(
                  hintText: "nhập số điện thoại",
                  title: "Số điện thoại",
                  formatter1: _formatter1,
                  textEditingController: contractBloc.phone),
              _noneInput(
                  title: "Chọn phòng *",
                  onTap: () {
                    _showDialogListRoom(appBloc: appBloc, context: context);
                  }),
              SizedBox(
                height: AppDimensions.d1h,
              ),
              _noneInputDate(
                  title: "Ngày sinh *",
                  onTap: () {
                    _showDateTime(context, onTap: () {
                      if (contractBloc.time != null) {
                        contractBloc.user1.birthDay =
                            contractBloc.time.millisecondsSinceEpoch ~/ 1000;
                        contractBloc.time = null;
                        Navigator.pop(context);
                        contractBloc.add(UpdateUIContractEvent());
                      }
                    });
                  },
                  text: contractBloc.user1.birthDay == null
                      ? ""
                      : "${DateTimeFormat.formatDate(
                          DateTime.fromMillisecondsSinceEpoch(
                              contractBloc.user1.birthDay * 1000),
                        )}"),
              SizedBox(
                height: AppDimensions.d1h,
              ),
              _noneInputDate(
                  title: "Ngày đến",
                  onTap: () async {
                    _showDateTime(context, onTap: () {
                      if (contractBloc.time != null) {
                        contractBloc.user1.registrationDate =
                            contractBloc.time.millisecondsSinceEpoch ~/ 1000;
                        contractBloc.time = null;
                        Navigator.pop(context);
                        contractBloc.add(UpdateUIContractEvent());
                      }
                    });
                  },
                  text: contractBloc.user1.registrationDate == null
                      ? ""
                      : "${DateTimeFormat.formatDate(DateTime.fromMillisecondsSinceEpoch(contractBloc.user1.registrationDate * 1000))}"),
              SizedBox(
                height: AppDimensions.d1h,
              ),
              _noneInputDate(
                  title: "Ngày hết hạn",
                  onTap: () async {
                    _showDateTime(context, onTap: () {
                      if (contractBloc.time != null) {
                        contractBloc.user1.expirationDate =
                            contractBloc.time.millisecondsSinceEpoch ~/ 1000;
                        contractBloc.time = null;
                        Navigator.pop(context);
                        contractBloc.add(UpdateUIContractEvent());
                      }
                    });
                  },
                  text: contractBloc.user1.expirationDate == null
                      ? ""
                      : "${DateTimeFormat.formatDate(DateTime.fromMillisecondsSinceEpoch(contractBloc.user1.expirationDate * 1000))}"),
              _buildButton(ontap: () {
                contractBloc.add(CreateContractEvent(appBloc: appBloc));
              })
            ],
          );
        },
      ),
    );
  }

  _intput(
      {String title,
      String hintText,
      TextEditingController textEditingController,
      List<TextInputFormatter> formatter1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${title} *",
          style: TextStyle(
              color: AppColors.colorBlack_87,
              fontSize: AppFontSizes.fs12,
              fontWeight: FontWeight.bold),
        ),
        Container(
          child: CupertinoTextField(
            inputFormatters: formatter1 == null ? [] : formatter1,
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
                appBloc.roomContract = appBloc.listAllDataRoom[i];
                appBloc.listAllDataRoomDisplay.forEach((element) {
                  if (element.id == appBloc.roomContract.id) {
                    appBloc.roomDisplay = element;
                  }
                });
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
              fontWeight: FontWeight.bold),
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
          "${title}",
          style: TextStyle(
              color: AppColors.colorBlack_87,
              fontSize: AppFontSizes.fs10,
              fontWeight: FontWeight.bold),
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

  DateTime _showDateTime(BuildContext context, {int index, Function onTap}) {
    return UIHelper.showDialogLogin(
      context: context,
      widget: Padding(
        padding: EdgeInsets.all(AppDimensions.d1h),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "Hủy",
                  style: TextStyle(
                      color: AppColors.colorFacebook,
                      fontWeight: FontWeight.bold),
                ),
              ),
              GestureDetector(
                onTap: onTap,
                child: Text(
                  "Xác nhận",
                  style: TextStyle(
                      color: AppColors.colorFacebook,
                      fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
          Container(
            height: AppDimensions.d30h,
            child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                initialDateTime: DateTime.now(),
                onDateTimeChanged: (dateTime) {
                  contractBloc.time = dateTime;
                }),
          )
        ]),
      ),
    );
  }
}
