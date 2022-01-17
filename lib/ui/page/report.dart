import 'dart:io';

import 'package:dormitory_manager/bloc/app_bloc/bloc.dart';
import 'package:dormitory_manager/bloc/report/bloc.dart';
import 'package:dormitory_manager/bloc/report/event.dart';
import 'package:dormitory_manager/bloc/report/state.dart';
import 'package:dormitory_manager/helper/ui_helper.dart';
import 'package:dormitory_manager/provider/login_provider.dart';
import 'package:dormitory_manager/resources/colors.dart';
import 'package:dormitory_manager/resources/dimensions.dart';
import 'package:dormitory_manager/resources/fontsizes.dart';
import 'package:dormitory_manager/ui/widget/close_dialog.dart';
import 'package:dormitory_manager/ui/widget/item_bill.dart';
import 'package:dormitory_manager/ui/widget/item_report.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class Report extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ReportState();
  }
}

class ReportState extends State<Report> {
  ReportBloc _reportBloc;
  AppBloc _appBloc;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    _appBloc = BlocProvider.of<AppBloc>(context);
    _reportBloc = new ReportBloc();
    _reportBloc.add(GetAllMessage(appBloc: _appBloc));
  }

  List<String> items = ["1", "2", "3", "4", "5", "6", "7", "8"];

  @override
  Widget build(BuildContext context) {
    var heightStatusBar = MediaQuery.of(context).padding.top;
    return BlocListener(
      cubit: _reportBloc,
      listener: (context, state) {
        if (state is LoadingReportState) {
          UIHelper.showLoadingCommon(context: context);
        }

        if (state is LoadDoneReportState) {
          Navigator.pop(context);
        }
      },
      child: BlocBuilder(
        cubit: _reportBloc,
        builder: (context, state) {
          return Column(
            children: [
              Container(
                width: AppDimensions.d100w,
                height: AppDimensions.d14h,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomLeft,
                    colors: [
                      Colors.green,
                      AppColors.colorFacebook,
                    ],
                  ),
                  color: AppColors.mainColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(AppDimensions.radius3w),
                    bottomRight: Radius.circular(AppDimensions.radius3w),
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: heightStatusBar,
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(AppDimensions.d1h),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Báo sự cố",
                              style: TextStyle(
                                  color: AppColors.colorWhite,
                                  fontSize: AppFontSizes.fs14,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: AppDimensions.d1h,
                            ),
                            _appBloc.isUser
                                ? Expanded(child: Container())
                                : Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: AppColors.colorWhite,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(
                                                  AppDimensions.radius1_0w))),
                                      child: Padding(
                                        padding: EdgeInsets.all(0.0),
                                        child: Center(
                                          child: TextField(
                                            decoration:
                                                InputDecoration.collapsed(
                                              hintText: "Tìm theo phòng",
                                              border: InputBorder.none,
                                            ),
                                            controller: _reportBloc.search,
                                            style: TextStyle(
                                                fontSize: AppFontSizes.fs9),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                            SizedBox(
                              width: AppDimensions.d0_5h,
                            ),
                            _appBloc.isUser
                                ? Container()
                                : GestureDetector(
                                    onTap: () {
                                      if (_reportBloc.search.text != "") {
                                        _reportBloc.add(SearchReportEvent());
                                      }
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: AppColors.colorWhite,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(
                                                  AppDimensions.radius1_0w))),
                                      child: Icon(
                                        Icons.search,
                                        color: AppColors.colorRed,
                                      ),
                                    ),
                                  ),
                            _appBloc.isUser
                                ? GestureDetector(
                                    onTap: () => _showDialogReport(),
                                    child: Container(
                                      alignment: Alignment.center,
                                      width: AppDimensions.d18w,
                                      height: AppDimensions.d10h,
                                      decoration: BoxDecoration(
                                        color: AppColors.colorOrange,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(
                                              AppDimensions.radius1_0w),
                                        ),
                                      ),
                                      child: Text(
                                        "Thêm",
                                        style: TextStyle(
                                          color: AppColors.colorWhite,
                                          fontSize: AppFontSizes.fs12,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  )
                                : Container()
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(AppDimensions.d1h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            child: Text(
                              "Tất cả",
                              style: TextStyle(
                                  color: _reportBloc.statusTab == 1
                                      ? AppColors.colorOrange
                                      : AppColors.colorWhite,
                                  fontSize: AppFontSizes.fs12),
                            ),
                            onTap: () {
                              _reportBloc.add(AllReportEvent());
                            },
                          ),
                          GestureDetector(
                            onTap: () {
                              _reportBloc.add(FixingReportEvent());
                            },
                            child: Text(
                              "Đang sửa",
                              style: TextStyle(
                                  color: _reportBloc.statusTab == 2
                                      ? AppColors.colorOrange
                                      : AppColors.colorWhite,
                                  fontSize: AppFontSizes.fs12),
                            ),
                          ),
                          GestureDetector(
                            child: Text(
                              "Đã sửa",
                              style: TextStyle(
                                  color: _reportBloc.statusTab == 3
                                      ? AppColors.colorOrange
                                      : AppColors.colorWhite,
                                  fontSize: AppFontSizes.fs12),
                            ),
                            onTap: () {
                              _reportBloc.add(FixedReportEvent());
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SmartRefresher(
                  enablePullDown: true,
                  enablePullUp: false,
                  header: WaterDropHeader(),
                  footer: CustomFooter(
                    builder: (BuildContext context, LoadStatus mode) {
                      Widget body;
                      if (mode == LoadStatus.idle) {
                        body = Text("pull up load");
                      } else if (mode == LoadStatus.loading) {
                        body = CupertinoActivityIndicator();
                      } else if (mode == LoadStatus.failed) {
                        body = Text("Load Failed!Click retry!");
                      } else if (mode == LoadStatus.canLoading) {
                        body = Text("release to load more");
                      } else {
                        body = Text("No more Data");
                      }
                      return Container(
                        height: 55.0,
                        child: Center(child: body),
                      );
                    },
                  ),
                  controller: _refreshController,
                  onRefresh: _onRefresh,
                  child: _reportBloc.listMessage.isNotEmpty
                      ? SingleChildScrollView(
                              child: ItemReport(
                            reportBloc: _reportBloc,
                            appBloc: _appBloc,
                          )
                        )
                      : Container(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _onRefresh() async {
    await Future.delayed(Duration(milliseconds: 1000));
    _reportBloc.add(GetAllMessage(appBloc: _appBloc));
    if(_appBloc.isUser){
      _appBloc.devicesToken = await LoginProvider().getToken(id: _appBloc.user.managerId)??"";
    }

    _refreshController.refreshCompleted();
  }

  _showDialogReport() {
    return UIHelper.showDialogLogin(
      context: context,
      widget: BlocListener(
        cubit: _reportBloc,
        listener: (context, state) {
          if (state is LoadingCreateState) {
            UIHelper.showLoadingCommon(context: context);
          }
          if (state is CreateDoneState) {
            Fluttertoast.showToast(msg: "Gửi thành công");
            Navigator.pop(context);
          }
        },
        child: BlocBuilder(
          cubit: _reportBloc,
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppDimensions.d2w),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Nhập nội dung",
                          style: TextStyle(
                              fontSize: AppFontSizes.fs14,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      CloseDialog(
                        color: AppColors.colorBlack_54,
                        onClose: () {
                          Navigator.pop(context);
//                        _reportBloc.add(UpdateUIReportEvent());
                        },
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(AppDimensions.d1h),
                  child: GestureDetector(
                    child: Container(
                      width: AppDimensions.d100w,
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.colorGrey_300),
                        borderRadius: BorderRadius.all(
                          Radius.circular(AppDimensions.radius1_5w),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(AppDimensions.d0_5h),
                        child: Row(
                          children: [
                            Text("${_appBloc.room1?.roomName ?? ""}"),
                            Expanded(
                              child: Container(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppDimensions.d2w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Tiêu đề",
                        style: TextStyle(
                          color: AppColors.colorBlack_87,
                          fontSize: AppFontSizes.fs10,
                        ),
                      ),
                      Container(
                        child: CupertinoTextField(
                          controller: _reportBloc.title,
                          style: TextStyle(
                              fontSize: AppFontSizes.fs10,
                              color: AppColors.colorBlack_87),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppDimensions.d2w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Nội dung",
                        style: TextStyle(
                          color: AppColors.colorBlack_87,
                          fontSize: AppFontSizes.fs10,
                        ),
                      ),
                      Container(
                        child: CupertinoTextField(
                          controller: _reportBloc.content,
                          maxLines: 10,
                          style: TextStyle(
                              fontSize: AppFontSizes.fs10,
                              color: AppColors.colorBlack_87),
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(),
                Padding(
                  padding: EdgeInsets.all(AppDimensions.d1h),
                  child: GestureDetector(
                    onTap: () {
                      _reportBloc.add(CreateMessage(appBloc: _appBloc));
                    },
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
                          "Gửi",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.colorWhite,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
