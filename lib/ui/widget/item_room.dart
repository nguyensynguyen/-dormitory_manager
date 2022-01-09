import 'package:dormitory_manager/bloc/all_room/bloc.dart';
import 'package:dormitory_manager/bloc/app_bloc/bloc.dart';
import 'package:dormitory_manager/bloc/report/bloc.dart';
import 'package:dormitory_manager/bloc/report/event.dart';
import 'package:dormitory_manager/converts/time_format.dart';
import 'package:dormitory_manager/helper/input_format.dart';
import 'package:dormitory_manager/helper/string_helper.dart';
import 'package:dormitory_manager/helper/ui_helper.dart';
import 'package:dormitory_manager/model/message.dart';
import 'package:dormitory_manager/resources/colors.dart';
import 'package:dormitory_manager/resources/dimensions.dart';
import 'package:dormitory_manager/resources/fontsizes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

import 'close_dialog.dart';

class ItemRoom extends StatelessWidget {
  AllRoomBloc allRoomBloc;
  AppBloc appBloc;
  ItemRoom({this.allRoomBloc,this.appBloc});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppDimensions.d100w,
      height: AppDimensions.d100h,
      child: _buildItem(context,appBloc),
    );
  }

  _buildItem(BuildContext context, AppBloc allRoomBloc) {
    List<Widget> listItem = [];
    for (int i = 0; i < allRoomBloc.listAllDataRoom.length; i++) {
      listItem.add(GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {},
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppDimensions.d1h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.colorGrey_400),
                        borderRadius: BorderRadius.all(
                          Radius.circular(AppDimensions.radius1_0w),
                        ),
                      ),
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              Container(),
                              Positioned(
                                child: Container(
                                  child: Image.asset(
                                    'asset/image/room.png',
                                    width: AppDimensions.d10w,
                                  ),
                                ),
                              ),
                              Positioned(
                                  left: 20,
                                  child: Column(
                                    children: [
                                      Container(
                                        color: AppColors.colorGrey_400,
                                        child: Text(
                                          allRoomBloc.listAllDataRoom[i]
                                                      .user.length <=
                                                  0
                                              ? "${allRoomBloc.listAllDataRoom[i].roomName}:Trống"
                                              : allRoomBloc.listAllDataRoom[i]
                                                          .user.length >=
                                                      allRoomBloc
                                                          .listAllDataRoom[i].maxPeople
                                                  ? "${allRoomBloc.listAllDataRoom[i].roomName}: Full"
                                                  : "${allRoomBloc.listAllDataRoom[i].roomName}: Đang ở",
                                          style: TextStyle(
                                              color: allRoomBloc.listAllDataRoom[i]
                                                          .user.length <=
                                                      0
                                                  ? AppColors.colorBlack
                                                  : allRoomBloc.listAllDataRoom[i]
                                                              .user.length >=
                                                          allRoomBloc
                                                              .listAllDataRoom[i]
                                                              .maxPeople
                                                      ? AppColors.colorRed
                                                      : AppColors.colorFacebook,
                                              fontSize: AppFontSizes.fs10,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ))
                            ],
                          ),
                          Divider(),
                          Row(
                            children: [
                              Text(
                                "Giá: ",
                                style: TextStyle(fontSize: AppFontSizes.fs8),
                              ),
                              Text(
                                "${StringHelper.formatCurrency(allRoomBloc.listAllDataRoom[i].roomAmount)}đ",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: AppFontSizes.fs10,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                "người/phòng: ",
                                style: TextStyle(fontSize: AppFontSizes.fs8),
                              ),
                              Text(
                                "${allRoomBloc.listAllDataRoom[i].maxPeople}",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: AppFontSizes.fs10,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text("Số người hiện tại: ",
                                  style: TextStyle(fontSize: AppFontSizes.fs8)),
                              Text(
                                "${allRoomBloc.listAllDataRoom[i].user?.length ?? 0}",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: AppFontSizes.fs10,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ));
    }

    return GridView.count(
        primary: false,
        // crossAxisSpacing: 10,
        // mainAxisSpacing: 10,
        crossAxisCount: 3,
        children: listItem.map<Widget>((item) {
          return item;
        }).toList());
  }

}
