import 'package:dormitory_manager/bloc/all_room/bloc.dart';
import 'package:dormitory_manager/bloc/all_room/event.dart';
import 'package:dormitory_manager/bloc/app_bloc/bloc.dart';
import 'package:dormitory_manager/bloc/report/bloc.dart';
import 'package:dormitory_manager/bloc/report/event.dart';
import 'package:dormitory_manager/converts/time_format.dart';
import 'package:dormitory_manager/helper/string_helper.dart';
import 'package:dormitory_manager/helper/ui_helper.dart';
import 'package:dormitory_manager/model/message.dart';
import 'package:dormitory_manager/model/room_eqiupment.dart';
import 'package:dormitory_manager/model/service.dart';
import 'package:dormitory_manager/resources/colors.dart';
import 'package:dormitory_manager/resources/dimensions.dart';
import 'package:dormitory_manager/resources/fontsizes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'close_dialog.dart';

class ItemEquipment extends StatelessWidget {
  AppBloc appBloc;
  AllRoomBloc allRoomBloc;

  ItemEquipment({this.appBloc,this.allRoomBloc});

  @override
  Widget build(BuildContext context) {
    return _buildEqiupment(context);
  }


  _buildEqiupment(BuildContext context){
    List listItem = [];
    appBloc.listAllDataRoom.forEach((element) {
      if(element.roomEquipment.length >0){
        listItem.add(Padding(
          padding:  EdgeInsets.all(AppDimensions.d1h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "Phòng ",
                    style: TextStyle(
                        color: AppColors.colorFacebook,
                        fontSize: AppFontSizes.fs14),
                  ),
                  Text(
                    element.roomName,
                    style: TextStyle(
                        color: AppColors.colorFacebook,
                        fontWeight: FontWeight.bold,
                        fontSize: AppFontSizes.fs14),
                  ),
                ],
              ),
              _buildServiceItem(element.roomEquipment,context),

            ],),
        ));

      }
    });
    return SingleChildScrollView(
      child: Column(
        children: listItem.map<Widget>((e){
          return Card(
            color: Colors.grey[100],
            child: e,);
        }).toList(),
      ),
    );
  }

  _buildServiceItem(List<RoomEquipment> service,BuildContext context){
    List<Widget> widget = [];
    service.forEach((element) {
      widget.add(Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: (){
              appBloc.equipment = element;
              _showStatusEqipment(context);
            },
            child: Card(
              child: Padding(
                padding:  EdgeInsets.all(AppDimensions.d1h),
                child: Row(
                  children: [
                    Icon(
                      Icons.view_list,
                      size: AppFontSizes.fs9,
                    ),
                    Expanded(
                      child: Text(
                        "\t${element.roomEquipmentName}",
                        style: TextStyle(
                            color: AppColors.colorBlack_54,
                            fontSize: AppFontSizes.fs10),
                      ),
                    ),
                    RichText(
                      text: TextSpan(children: <TextSpan>[
                        TextSpan(
                          text: "Tình trạng: ",
                          style: TextStyle(
                            color: AppColors.colorBlack_54,
                            fontSize: AppFontSizes.fs10,
                          ),
                        ),
                        TextSpan(
                          text: "${element.status}",
                          style: TextStyle(
                              color:element.status == "Hỏng"?AppColors.colorRed:AppColors.colorGreen,
                              fontSize: AppFontSizes.fs10,
                              fontWeight: FontWeight.bold),
                        ),
                      ]),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
        ],
      ));
    });
    return Column(
      children: widget.map<Widget>((e){
        return e;
      }).toList(),
    );
  }

  _showStatusEqipment(BuildContext  context) {
    return UIHelper.showDialogLogin(
      context: context,
      widget: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppDimensions.d2w),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "Tình trạng thiết bị",
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
            ),
            Divider(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppDimensions.d2w),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  allRoomBloc.status = "Hỏng";
                  Navigator.pop(context);
                  allRoomBloc.add(UpdateRoomEquipmentEvent(appBloc: appBloc));
                },
                child: Text(
                  "Hỏng",
                  style: TextStyle(fontSize: AppFontSizes.fs12),
                ),
              ),
            ),
            Divider(),
            SizedBox(
              height: AppDimensions.d1h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppDimensions.d2w),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  allRoomBloc.status = "Hoạt động";
                  Navigator.pop(context);
                  allRoomBloc.add(UpdateRoomEquipmentEvent(appBloc: appBloc));
                },
                child: Text(
                  "Hoạt động",
                  style: TextStyle(fontSize: AppFontSizes.fs12),
                ),
              ),
            ),
            Divider(),
          ],
        ),
      ),
    );
  }
}
