import 'package:dormitory_manager/bloc/all_room/bloc.dart';
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
import 'package:flutter_bloc/flutter_bloc.dart';

import 'close_dialog.dart';

class ItemService extends StatelessWidget {
  AppBloc appBloc;

  ItemService({this.appBloc});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      cubit: appBloc,
      builder: (context,state){
        return _buildService();
      },
    );
  }

  _buildService(){
    List listItem = [];
    appBloc.listAllDataRoom.forEach((element) {
      if(element.service.length > 0){
        listItem.add(Padding(
          padding:  EdgeInsets.all(AppDimensions.d1h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "Phòng : ",
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
              _buildServiceItem(element.service),

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

  _buildServiceItem(List<Service> service){
    List<Widget> widget = [];
    service.forEach((element) {
      widget.add(Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.view_list,
                size: AppFontSizes.fs9,
              ),
              Expanded(
                child: Text(
                  "\t${element.serviceName}",
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
                    text: "${StringHelper.formatCurrency(element.unitPrice)}đ",
                    style: TextStyle(
                        color: AppColors.colorGreen,
                        fontSize: AppFontSizes.fs10,
                        fontWeight: FontWeight.bold),
                  ),
                ]),
              ),
            ],
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
}
