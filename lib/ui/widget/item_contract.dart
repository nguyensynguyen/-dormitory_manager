import 'package:dormitory_manager/bloc/app_bloc/bloc.dart';
import 'package:dormitory_manager/bloc/contract/bloc.dart';
import 'package:dormitory_manager/bloc/contract/event.dart';
import 'package:dormitory_manager/bloc/contract/state.dart';
import 'package:dormitory_manager/converts/time_format.dart';
import 'package:dormitory_manager/helper/string_helper.dart';
import 'package:dormitory_manager/helper/ui_helper.dart';
import 'package:dormitory_manager/resources/colors.dart';
import 'package:dormitory_manager/resources/dimensions.dart';
import 'package:dormitory_manager/resources/fontsizes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'close_dialog.dart';

class ItemContract extends StatelessWidget {
  ContractBloc contractBloc;
  AppBloc appBloc;

  ItemContract({this.contractBloc, this.appBloc});

  @override
  Widget build(BuildContext context) {
    return appBloc.isUser ? _buildProfileUsre(context) : _buildItem(context);
  }

  _buildProfileUsre(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(AppDimensions.d1h),
      child: Column(
        children: [
          Image.asset(
            "asset/image/profile.png",
            width: AppDimensions.d30w,
          ),
          Container(
            width: AppDimensions.d100w,
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(AppDimensions.d1h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "Thông tin Hợp đồng",
                      style: TextStyle(
                          fontSize: AppFontSizes.fs12,
                          color: AppColors.colorFacebook,
                          fontWeight: FontWeight.bold),
                    ),
                    Divider(),
                    Row(
                      children: [
                        Icon(
                          Icons.person,
                          color: AppColors.colorFacebook,
                        ),
                        Text(
                          "\t \t Họ và tên : ",
                          style: TextStyle(
                              fontSize: AppFontSizes.fs8,
                              color: AppColors.colorGrey_400,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "${appBloc.user.userName}",
                          style: TextStyle(
                              fontSize: AppFontSizes.fs10,
                              color: AppColors.colorFacebook,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: AppDimensions.d0_5h,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.email,
                          color: AppColors.colorFacebook,
                        ),
                        Text(
                          "\t \t Email : ",
                          style: TextStyle(
                              fontSize: AppFontSizes.fs8,
                              color: AppColors.colorGrey_400,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "${appBloc.user.email}",
                          style: TextStyle(
                              fontSize: AppFontSizes.fs10,
                              color: AppColors.colorFacebook,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: AppDimensions.d0_5h,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.phone,
                          color: AppColors.colorFacebook,
                        ),
                        Text(
                          "\t \t SDT : ",
                          style: TextStyle(
                              fontSize: AppFontSizes.fs8,
                              color: AppColors.colorGrey_400,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "0${appBloc.user.phone}",
                          style: TextStyle(
                              fontSize: AppFontSizes.fs10,
                              color: AppColors.colorFacebook,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: AppDimensions.d0_5h,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.home,
                          color: AppColors.colorFacebook,
                        ),
                        Text(
                          "\t \t Phòng : ",
                          style: TextStyle(
                              fontSize: AppFontSizes.fs8,
                              color: AppColors.colorGrey_400,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "${appBloc.room1?.roomName ?? ""}",
                          style: TextStyle(
                              fontSize: AppFontSizes.fs10,
                              color: AppColors.colorFacebook,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: AppDimensions.d0_5h,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.date_range,
                          color: AppColors.colorFacebook,
                        ),
                        Text(
                          "\t \t Ngày tháng năm sinh : ",
                          style: TextStyle(
                              fontSize: AppFontSizes.fs8,
                              color: AppColors.colorGrey_400,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "${DateTimeFormat.formatDate(DateTime.fromMillisecondsSinceEpoch(appBloc.user.birthDay * 1000))}",
                          style: TextStyle(
                              fontSize: AppFontSizes.fs10,
                              color: AppColors.colorFacebook,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: AppDimensions.d0_5h,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.indeterminate_check_box,
                          color: AppColors.colorFacebook,
                        ),
                        Text(
                          "\t \t Số căn cước : ",
                          style: TextStyle(
                              fontSize: AppFontSizes.fs8,
                              color: AppColors.colorGrey_400,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "${appBloc.user.idCard}",
                          style: TextStyle(
                              fontSize: AppFontSizes.fs10,
                              color: AppColors.colorFacebook,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: AppDimensions.d0_5h,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: AppColors.colorFacebook,
                        ),
                        Text(
                          "\t \t Địa chỉ : ",
                          style: TextStyle(
                              fontSize: AppFontSizes.fs8,
                              color: AppColors.colorGrey_400,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "${appBloc.user.address}",
                          style: TextStyle(
                              fontSize: AppFontSizes.fs10,
                              color: AppColors.colorFacebook,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: AppDimensions.d0_5h,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.date_range,
                          color: AppColors.colorFacebook,
                        ),
                        Text(
                          "\t \t Ngày đến : ",
                          style: TextStyle(
                              fontSize: AppFontSizes.fs8,
                              color: AppColors.colorGrey_400,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "${DateTimeFormat.formatDate(DateTime.fromMillisecondsSinceEpoch(appBloc.user.registrationDate * 1000))}",
                          style: TextStyle(
                              fontSize: AppFontSizes.fs10,
                              color: AppColors.colorFacebook,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: AppDimensions.d0_5h,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.date_range,
                          color: AppColors.colorFacebook,
                        ),
                        Text(
                          "\t \t Ngày hết hạn : ",
                          style: TextStyle(
                              fontSize: AppFontSizes.fs8,
                              color: AppColors.colorGrey_400,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "${DateTimeFormat.formatDate(DateTime.fromMillisecondsSinceEpoch(appBloc.user.expirationDate * 1000))}",
                          style: TextStyle(
                              fontSize: AppFontSizes.fs10,
                              color: AppColors.colorFacebook,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: AppDimensions.d1h,
                    ),
                    GestureDetector(
                      onTap: () {
                        _showChangePass(context);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: AppDimensions.d8h,
                        decoration: BoxDecoration(
                          color: AppColors.colorOrange,
                          borderRadius: BorderRadius.all(
                            Radius.circular(AppDimensions.radius1_0w),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(AppDimensions.d1h),
                          child: Text(
                            "Đổi mật khẩu",
                            style: TextStyle(
                                color: AppColors.colorWhite,
                                fontSize: AppFontSizes.fs12,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildItem(BuildContext context) {
    List<Widget> widget = [];
    for (int i = 0; i < contractBloc.listContract.length; i++) {
      widget.add(GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          contractBloc.user = contractBloc.listContract[i];
          _showDialogSelect(context, index: i);
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
                      onTap: () {},
                      child: Image.asset(
                        'asset/image/contract.png',
                        width: AppDimensions.d8w,
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
                            contractBloc.listContract[i].room !=null?
                            "${contractBloc.listContract[i]?.room['room_name']}":"",
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
                      "Cập nhật hợp đồng",
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

                  _showDialogDetailContract(context, index: index);
                },
                child: Text("Xem chi tiết hợp đồng"),
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

  _showDialogDetailContract(BuildContext context, {int index}) {
    return UIHelper.showDialogLogin(
      context: context,
      widget: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: CloseDialog(
              color: Colors.grey,
              onClose: () {
                Navigator.pop(context);
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(AppDimensions.d1h),
            child: Column(
              children: [
                Image.asset(
                  "asset/image/profile.png",
                  width: AppDimensions.d30w,
                ),
                Container(
                  width: AppDimensions.d100w,
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(AppDimensions.d1h),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "Thông tin Hợp đồng",
                            style: TextStyle(
                                fontSize: AppFontSizes.fs16,
                                color: AppColors.colorFacebook,
                                fontWeight: FontWeight.bold,
                                fontFamily: "San"),
                          ),
                          Divider(),
                          Row(
                            children: [
                              Icon(
                                Icons.person,
                                color: AppColors.colorFacebook,
                              ),
                              Text(
                                "\t \t Họ và tên : ",
                                style: TextStyle(
                                    fontSize: AppFontSizes.fs8,
                                    color: AppColors.colorGrey_400,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "${contractBloc.listContract[index].userName}",
                                style: TextStyle(
                                    fontSize: AppFontSizes.fs10,
                                    color: AppColors.colorFacebook,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: AppDimensions.d0_5h,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.email,
                                color: AppColors.colorFacebook,
                              ),
                              Text(
                                "\t \t Email : ",
                                style: TextStyle(
                                    fontSize: AppFontSizes.fs8,
                                    color: AppColors.colorGrey_400,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "${contractBloc.listContract[index].email}",
                                style: TextStyle(
                                    fontSize: AppFontSizes.fs10,
                                    color: AppColors.colorFacebook,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: AppDimensions.d0_5h,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.phone,
                                color: AppColors.colorFacebook,
                              ),
                              Text(
                                "\t \t SDT : ",
                                style: TextStyle(
                                    fontSize: AppFontSizes.fs8,
                                    color: AppColors.colorGrey_400,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "0${contractBloc.listContract[index].phone}",
                                style: TextStyle(
                                    fontSize: AppFontSizes.fs10,
                                    color: AppColors.colorFacebook,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: AppDimensions.d0_5h,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.home,
                                color: AppColors.colorFacebook,
                              ),
                              Text(
                                "\t \t Phòng : ",
                                style: TextStyle(
                                    fontSize: AppFontSizes.fs8,
                                    color: AppColors.colorGrey_400,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "${contractBloc.listContract[index].room['room_name'] ?? ""}",
                                style: TextStyle(
                                    fontSize: AppFontSizes.fs10,
                                    color: AppColors.colorFacebook,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: AppDimensions.d0_5h,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.date_range,
                                color: AppColors.colorFacebook,
                              ),
                              Text(
                                "\t \t Ngày tháng năm sinh : ",
                                style: TextStyle(
                                    fontSize: AppFontSizes.fs8,
                                    color: AppColors.colorGrey_400,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "${DateTimeFormat.formatDate(DateTime.fromMillisecondsSinceEpoch(contractBloc.listContract[index].birthDay * 1000))}",
                                style: TextStyle(
                                    fontSize: AppFontSizes.fs10,
                                    color: AppColors.colorFacebook,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: AppDimensions.d0_5h,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.indeterminate_check_box,
                                color: AppColors.colorFacebook,
                              ),
                              Text(
                                "\t \t Số căn cước : ",
                                style: TextStyle(
                                    fontSize: AppFontSizes.fs8,
                                    color: AppColors.colorGrey_400,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "${contractBloc.listContract[index].idCard}",
                                style: TextStyle(
                                    fontSize: AppFontSizes.fs10,
                                    color: AppColors.colorFacebook,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: AppDimensions.d0_5h,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                color: AppColors.colorFacebook,
                              ),
                              Text(
                                "\t \t Địa chỉ : ",
                                style: TextStyle(
                                    fontSize: AppFontSizes.fs8,
                                    color: AppColors.colorGrey_400,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "${contractBloc.listContract[index].address}",
                                style: TextStyle(
                                    fontSize: AppFontSizes.fs10,
                                    color: AppColors.colorFacebook,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: AppDimensions.d0_5h,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.date_range,
                                color: AppColors.colorFacebook,
                              ),
                              Text(
                                "\t \t Ngày đến : ",
                                style: TextStyle(
                                    fontSize: AppFontSizes.fs8,
                                    color: AppColors.colorGrey_400,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "${DateTimeFormat.formatDate(DateTime.fromMillisecondsSinceEpoch(contractBloc.listContract[index].registrationDate * 1000))}",
                                style: TextStyle(
                                    fontSize: AppFontSizes.fs10,
                                    color: AppColors.colorFacebook,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: AppDimensions.d0_5h,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.date_range,
                                color: AppColors.colorFacebook,
                              ),
                              Text(
                                "\t \t Ngày hết hạn : ",
                                style: TextStyle(
                                    fontSize: AppFontSizes.fs8,
                                    color: AppColors.colorGrey_400,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "${DateTimeFormat.formatDate(DateTime.fromMillisecondsSinceEpoch(contractBloc.listContract[index].expirationDate * 1000))}",
                                style: TextStyle(
                                    fontSize: AppFontSizes.fs10,
                                    color: AppColors.colorFacebook,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
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

  _showChangePass(BuildContext context, {int index}) {
    return UIHelper.showChangePass(
      newPass: contractBloc.newPass,
      oldPass: contractBloc.oldPass,
      context: context,
      message: "Đổi mật khẩu",
      widget: BlocListener(
        cubit: contractBloc,
        listener: (context,state){
          if(state is LoadingChangePassState){
            UIHelper.showLoadingCommon(context: context);
          }
          if(state is ChangPassDoneState){
            Fluttertoast.showToast(
                backgroundColor: AppColors.colorFacebook,
                msg: "Đổi mật khẩu thành công", toastLength: Toast.LENGTH_LONG);
            Navigator.pop(context);
          }
          if(state is ChangePassError){
            Fluttertoast.showToast(
                backgroundColor: AppColors.colorFacebook,
                msg: "Đổi mật khẩu thất bại", toastLength: Toast.LENGTH_LONG);
            Navigator.pop(context);
          }
        },
        child: BlocBuilder(
          cubit: contractBloc,
          builder: (context,st){
            return Padding(
              padding:  EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Đổi mật khẩu',
                        style: TextStyle(
                            fontFamily: "San",
                            fontSize: AppFontSizes.fs14,
                            fontWeight: FontWeight.bold),
                      ),
                      Expanded(
                        child: Container(),
                      ),
                      CloseDialog(
                        color: AppColors.colorGrey_400,
                        onClose: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                  Text(
                    "Mật khẩu cũ",
                    style: TextStyle(fontFamily: "San"),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.colorGrey_300),
                      borderRadius: BorderRadius.all(
                        Radius.circular(AppDimensions.radius1_5w),
                      ),
                    ),
                    child: CupertinoTextField(
                      obscureText: true,
                      controller: contractBloc.oldPass,
                      placeholderStyle:
                      TextStyle(color: Colors.grey, fontSize: AppFontSizes.fs12),
                    ),
                  ),
                  SizedBox(height: AppDimensions.d1h,),
                  Text(
                    "Mật khẩu mới",
                    style: TextStyle(fontFamily: "San"),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.colorGrey_300),
                      borderRadius: BorderRadius.all(
                        Radius.circular(AppDimensions.radius1_5w),
                      ),
                    ),
                    child: CupertinoTextField(
                      obscureText: true,
                      controller: contractBloc.newPass,
                      placeholderStyle:
                      TextStyle(color: Colors.grey, fontSize: AppFontSizes.fs12),
                    ),
                  ),
                  SizedBox(height: AppDimensions.d1h,),

                  GestureDetector(
                    onTap: () {
                      if (contractBloc.oldPass.text == "") {
                        Fluttertoast.showToast(
                            backgroundColor: AppColors.colorFacebook,
                            msg: "Nhập mật khẩu cũ", toastLength: Toast.LENGTH_LONG);
                        return;
                      }
                      if (contractBloc.newPass.text == "") {
                        Fluttertoast.showToast(
                            backgroundColor: AppColors.colorFacebook,
                            msg: "Nhập mật khẩu mới", toastLength: Toast.LENGTH_LONG);
                        return;
                      }
                      contractBloc.add(ChangePassUserEvent(appBloc: appBloc));
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: AppDimensions.d8h,
                      decoration: BoxDecoration(
                        color: AppColors.colorOrange,
                        borderRadius: BorderRadius.all(
                          Radius.circular(AppDimensions.radius1_0w),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(AppDimensions.d1h),
                        child: Text(
                          "Đổi mật khẩu",
                          style: TextStyle(
                              color: AppColors.colorWhite,
                              fontSize: AppFontSizes.fs12,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  _showDateTime(BuildContext context, {int index}) {
    DateTime time = DateTime.now();
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
                onTap: () {
                  if (time.millisecondsSinceEpoch <=
                      DateTime.now().millisecondsSinceEpoch) {
                    Fluttertoast.showToast(
                        backgroundColor: AppColors.colorFacebook,
                        msg: "Ngày hết hạn không thể nhỏ hơn ngày hiện tại",
                        toastLength: Toast.LENGTH_LONG);
                    return;
                  }
                  contractBloc.add(ExtendContractEvent(
                      id: contractBloc.user.id,
                      dateTime: time.millisecondsSinceEpoch ~/ 1000));
                  Navigator.pop(context);
                },
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
                  time = dateTime;
                }),
          )
        ]),
      ),
    );
  }
}
