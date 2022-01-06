import 'package:dormitory_manager/bloc/all_room/bloc.dart';
import 'package:dormitory_manager/bloc/app_bloc/bloc.dart';
import 'package:dormitory_manager/bloc/report/bloc.dart';
import 'package:dormitory_manager/bloc/report/event.dart';
import 'package:dormitory_manager/converts/time_format.dart';
import 'package:dormitory_manager/helper/string_helper.dart';
import 'package:dormitory_manager/helper/ui_helper.dart';
import 'package:dormitory_manager/model/message.dart';
import 'package:dormitory_manager/model/room_eqiupment.dart';
import 'package:dormitory_manager/resources/colors.dart';
import 'package:dormitory_manager/resources/dimensions.dart';
import 'package:dormitory_manager/resources/fontsizes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'close_dialog.dart';

class ItemService extends StatelessWidget {
  AppBloc equipment;

  ItemService({this.equipment});

  @override
  Widget build(BuildContext context) {
    return _buildItem(context, equipment);
  }

  _buildItem(BuildContext context, AppBloc equipment) {
    List listItem = [];
    int checkDisplayRoom = -1;
    bool noneDisplay = false;
    int index = 0;
    for (int i = 0; i < equipment.listAllDataRoom.length; i++) {
      listItem.addAll(equipment.listAllDataRoom[i].service.map<Widget>((e) {
        if (equipment.listAllDataRoom[i].id == checkDisplayRoom) {
          noneDisplay = true;
        } else {
          checkDisplayRoom = equipment.listAllDataRoom[i].id;
          noneDisplay = false;
          index = 0;
        }
        index++;
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            noneDisplay
                ? Container()
                : Text(
                    equipment.listAllDataRoom[i].roomName,
                    style: TextStyle(
                        color: AppColors.colorFacebook,
                        fontWeight: FontWeight.bold,
                        fontSize: AppFontSizes.fs14),
                  ),
            Row(
              children: [
                Icon(
                  Icons.view_list,
                  size: AppFontSizes.fs9,
                ),
                Expanded(
                  child: Text(
                    "\t${e.serviceName}",
                    style: TextStyle(
                        color: AppColors.colorBlack_54,
                        fontSize: AppFontSizes.fs10),
                  ),
                ),
                RichText(
                  text: TextSpan(children: <TextSpan>[
                    TextSpan(
                      text: "đơn giá: ",
                      style: TextStyle(
                        color: AppColors.colorBlack_54,
                        fontSize: AppFontSizes.fs10,
                      ),
                    ),
                    TextSpan(
                      text: "${StringHelper.formatCurrency(e.unitPrice)}đ",
                      style: TextStyle(
                          color: AppColors.colorGreen,
                          fontSize: AppFontSizes.fs10,
                          fontWeight: FontWeight.bold),
                    ),
                  ]),
                ),
              ],
            ),
            index >= equipment.listAllDataRoom[i].roomEquipment.length
                ? Divider()
                : Container()
          ],
        );
      }));
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: listItem.map<Widget>((item) {
        return item;
      }).toList(),
    );
  }
}
