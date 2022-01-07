import 'package:dormitory_manager/bloc/app_bloc/bloc.dart';
import 'package:dormitory_manager/bloc/report/bloc.dart';
import 'package:dormitory_manager/bloc/report/event.dart';
import 'package:dormitory_manager/converts/time_format.dart';
import 'package:dormitory_manager/helper/ui_helper.dart';
import 'package:dormitory_manager/model/message.dart';
import 'package:dormitory_manager/resources/colors.dart';
import 'package:dormitory_manager/resources/dimensions.dart';
import 'package:dormitory_manager/resources/fontsizes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'close_dialog.dart';

class ItemReport extends StatelessWidget {
  ReportBloc reportBloc;
AppBloc appBloc;
  ItemReport({this.reportBloc,this.appBloc});

  @override
  Widget build(BuildContext context) {
    return _buildItem(context, reportBloc);
  }

  _buildItem(BuildContext context, ReportBloc reportBloc) {
    List<Widget> listItem = [];
    for (int i = 0; i < reportBloc.listMessage.length; i++) {
      if(appBloc.isUser){
      if(appBloc.user.id == reportBloc.listMessage[i].userId){
        listItem.add(GestureDetector(
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppDimensions.d1h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      'asset/image/report1.png',
                      width: AppDimensions.d10w,
                    ),
                    SizedBox(
                      width: AppDimensions.d1h,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${reportBloc.listMessage[i].title}",
                            style: TextStyle(
                              color: AppColors.colorBlack_87,
                              fontSize: AppFontSizes.fs12,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            "${reportBloc.listMessage[i].room.roomName}",
                            style: TextStyle(
                                color: AppColors.colorBlack_87,
                                fontSize: AppFontSizes.fs10),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      reportBloc.listMessage[i].status == "fixing"?
                      "Đang sửa":"Đã sửa",
                      style: TextStyle(
                        color:reportBloc.listMessage[i].status == "fixing"? AppColors.colorOrange:AppColors.colorGreen,
                        fontSize: AppFontSizes.fs10,
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Người gửi : ${reportBloc.listMessage[i].user.userName}",
                        style: TextStyle(
                          color: AppColors.colorBlack_87,
                          fontSize: AppFontSizes.fs10,
                        ),
                      ),
                    ),
                    Text(
                      "Ngày tạo: ${DateTimeFormat.formatDate(DateTime.fromMillisecondsSinceEpoch(reportBloc.listMessage[i].dateCreate * 1000))}",
                      style: TextStyle(
                        color: AppColors.colorBlack_87,
                        fontSize: AppFontSizes.fs10,
                      ),
                    )
                  ],
                ),
                Divider(),
              ],
            ),
          ),
        ));
      }
      }
      else{
        listItem.add(GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () =>
              _showDialog(context: context, message: reportBloc.listMessage[i]),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppDimensions.d1h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      'asset/image/report1.png',
                      width: AppDimensions.d10w,
                    ),
                    SizedBox(
                      width: AppDimensions.d1h,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${reportBloc.listMessage[i].title}",
                            style: TextStyle(
                              color: AppColors.colorBlack_87,
                              fontSize: AppFontSizes.fs12,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            "${reportBloc.listMessage[i].room.roomName}",
                            style: TextStyle(
                                color: AppColors.colorBlack_87,
                                fontSize: AppFontSizes.fs10),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      reportBloc.listMessage[i].status == "fixing"?
                      "Đang sửa":"Đã sửa",
                      style: TextStyle(
                        color:reportBloc.listMessage[i].status == "fixing"? AppColors.colorOrange:AppColors.colorGreen,
                        fontSize: AppFontSizes.fs10,
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Người gửi : ${reportBloc.listMessage[i].user.userName}",
                        style: TextStyle(
                          color: AppColors.colorBlack_87,
                          fontSize: AppFontSizes.fs10,
                        ),
                      ),
                    ),
                    Text(
                      "Ngày tạo: ${DateTimeFormat.formatDate(DateTime.fromMillisecondsSinceEpoch(reportBloc.listMessage[i].dateCreate * 1000))}",
                      style: TextStyle(
                        color: AppColors.colorBlack_87,
                        fontSize: AppFontSizes.fs10,
                      ),
                    )
                  ],
                ),
                Divider(),
              ],
            ),
          ),
        ));
      }
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: listItem.map<Widget>((item) {
        return item;
      }).toList()
        ..insert(
            0,
            SizedBox(
              height: AppDimensions.d1h,
            )),
    );
  }

  _buildButton({String text, Function onTap, Color color}) {
    return Padding(
      padding: EdgeInsets.all(AppDimensions.d1h),
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          alignment: Alignment.center,
          width: AppDimensions.d100w,
          decoration: BoxDecoration(
            boxShadow: [],
            color: color,
            borderRadius: BorderRadius.all(
              Radius.circular(AppDimensions.radius1_0w),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(AppDimensions.d2h),
            child: Text(
              text,
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

  _showDialog({BuildContext context, Message message}) {
    return UIHelper.showDialogLogin(
      context: context,
      widget: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppDimensions.d2w),
            child: Row(
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Sự cố",
                      style: TextStyle(
                          fontSize: AppFontSizes.fs16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.colorOrange),
                    ),
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
          Padding(
            padding: EdgeInsets.all(AppDimensions.d1h),
            child: Text(
              "${message.title}",
              style: TextStyle(
                fontSize: AppFontSizes.fs12,
                color: AppColors.colorBlack_87,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppDimensions.d2w),
            child: Text(
              '"${message.content}"',
              style: TextStyle(
                  fontSize: AppFontSizes.fs12, color: AppColors.colorBlack_54),
            ),
          ),
          Divider(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppDimensions.d2w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Phòng",
                  style: TextStyle(
                    color: AppColors.colorBlack_87,
                    fontSize: AppFontSizes.fs10,
                  ),
                ),
                Text(
                  "${message.room.roomName}",
                  style: TextStyle(
                    color: AppColors.colorBlack_87,
                    fontSize: AppFontSizes.fs10,
                  ),
                ),
              ],
            ),
          ),
          Divider(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppDimensions.d2w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Người gửi",
                  style: TextStyle(
                    color: AppColors.colorBlack_87,
                    fontSize: AppFontSizes.fs10,
                  ),
                ),
                Text(
                  "${message.user.userName}",
                  style: TextStyle(
                    color: AppColors.colorGreen,
                    fontSize: AppFontSizes.fs10,
                  ),
                ),
              ],
            ),
          ),
          Divider(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppDimensions.d2w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Tạo lúc",
                  style: TextStyle(
                    color: AppColors.colorBlack_87,
                    fontSize: AppFontSizes.fs10,
                  ),
                ),
                Text(
                  "${DateTimeFormat.formatDate(DateTime.fromMillisecondsSinceEpoch(message.dateCreate * 1000))}",
                  style: TextStyle(
                    color: AppColors.colorBlack_87,
                    fontSize: AppFontSizes.fs10,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                child: _buildButton(
                    text: "Tiếp nhận",
                    onTap: () {
                      reportBloc.message = message;
                      reportBloc.add(UpdateMessage(id: message.id,status: "fixing"));
                      Navigator.pop(context);
                    },
                    color: AppColors.colorOrange),
              ),
              Expanded(
                child: _buildButton(
                    text: "Hoàn thành",
                    onTap: () {
                      reportBloc.message = message;
                      reportBloc.add(UpdateMessage(id: message.id,status: "fixed"));
                      Navigator.pop(context);
                    },
                    color: AppColors.colorGreen),
              )
            ],
          )
        ],
      ),
    );
  }
}
