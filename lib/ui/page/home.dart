import 'package:dormitory_manager/bloc/all_room/bloc.dart';
import 'package:dormitory_manager/bloc/all_room/event.dart';
import 'package:dormitory_manager/bloc/all_room/state.dart';
import 'package:dormitory_manager/bloc/app_bloc/bloc.dart';
import 'package:dormitory_manager/bloc/auth/bloc.dart';
import 'package:dormitory_manager/bloc/auth/event.dart';
import 'package:dormitory_manager/bloc/auth/state.dart';
import 'package:dormitory_manager/bloc/contract/event.dart';
import 'package:dormitory_manager/helper/input_format.dart';
import 'package:dormitory_manager/helper/ui_helper.dart';
import 'package:dormitory_manager/model/service.dart';
import 'package:dormitory_manager/resources/colors.dart';
import 'package:dormitory_manager/resources/dimensions.dart';
import 'package:dormitory_manager/resources/fontsizes.dart';
import 'package:dormitory_manager/ui/page/contract.dart';
import 'package:dormitory_manager/ui/page/notification.dart';
import 'package:dormitory_manager/ui/page/report.dart';
import 'package:dormitory_manager/ui/widget/close_dialog.dart';
import 'package:dormitory_manager/ui/widget/item_room.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'bill.dart';
import 'login.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int _curentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  final _tab = [
    BuildHome(),
    Bill(),
    Contract(),
    Notifications(),
    Container(
      child: Report(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _curentIndex,
        children: _tab.map<Widget>((ui) {
          return ui;
        }).toList(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _curentIndex,
        type: BottomNavigationBarType.fixed,
        fixedColor: AppColors.colorFacebook,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Center(child: Text("Trang chủ")),
              backgroundColor: Colors.green),
          BottomNavigationBarItem(
              icon: Icon(Icons.library_books),
              title: Text("Hóa đơn"),
              backgroundColor: Colors.blue),
          BottomNavigationBarItem(
              icon: Icon(Icons.perm_identity),
              title: Text("Hợp đồng"),
              backgroundColor: Colors.blue),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications_active),
              title: Text("Thông báo"),
              backgroundColor: Colors.blue),
          BottomNavigationBarItem(
              icon: Icon(Icons.error),
              title: Text("Sự cố"),
              backgroundColor: Colors.blue),
        ],
        onTap: (index) {
          setState(() {
            _curentIndex = index;
          });
        },
      ),
    );
  }
}

class BuildHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _buildHome();
  }
}

class _buildHome extends State<BuildHome> {
  AuthBloc _authBloc;
  AppBloc _appBloc;
  AllRoomBloc _allRoomBloc;
  final List<TextInputFormatter> _formatter = [NumberFormat()];
  final List<TextInputFormatter> _formatter1 = [NumberFormat(isInt: true)];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _authBloc = AuthBloc();
    _appBloc = BlocProvider.of<AppBloc>(context);
    _allRoomBloc = AllRoomBloc();

    _allRoomBloc.add(GetDataRoomEvent(appBloc: _appBloc));
  }

  @override
  Widget build(BuildContext context) {
    var heightStatusBar = MediaQuery.of(context).padding.top;
    return BlocListener(
      listener: (context, st) {
        if (st is LoadingState) {
          UIHelper.showLoadingCommon(context: context);
        }

        if (st is GetAllDataRoomState) {
          Navigator.pop(context);
        }
      },
      cubit: _allRoomBloc,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Dormitory",
                          style: TextStyle(
                              color: AppColors.colorWhite,
                              fontSize: AppFontSizes.fs14,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(AppDimensions.d1h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [],
                  ),
                ),
              ],
            ),
          ),
          // Expanded(
          //   child: BlocListener(
          //     listener: (context, state) {
          //       if (state is LogOutDone) {
          //         Navigator.of(context).pushAndRemoveUntil(
          //             MaterialPageRoute(builder: (ctx) => Login()),
          //             (Route<dynamic> route) => true);
          //       }
          //     },
          //     cubit: _authBloc,
          //     child: Center(
          //       child: GestureDetector(
          //         onTap: () {
          //           _authBloc.add(LogOutEvent(appBloc: _appBloc));
          //         },
          //         child: Text("logout"),
          //       ),
          //     ),
          //   ),
          // ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(AppDimensions.d1h),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Khởi tạo dữ liệu",
                        style: TextStyle(
                          color: AppColors.colorBlack_87,
                          fontWeight: FontWeight.bold,
                          fontSize: AppFontSizes.fs12,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: AppDimensions.d0_5h,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            child: Container(
                              child: Column(
                                children: [
                                  Image.asset(
                                    'asset/image/report1.png',
                                    width: AppDimensions.d10w,
                                  ),
                                  Text(
                                    "Quanr lý phòng",
                                    style: TextStyle(
                                      color: AppColors.colorBlack_54,
                                      fontSize: AppFontSizes.fs10,
                                    ),
                                  ),
                                  SizedBox(
                                    height: AppDimensions.d0_5h,
                                  ),
                                ],
                              ),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: AppColors.colorGrey_400),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(AppDimensions.radius2w))),
                            ),
                            onTap: () {
                              _showDialogRoom();
                            },
                          ),
                        ),
                        SizedBox(
                          width: AppDimensions.d2w,
                        ),
                        Expanded(
                          child: GestureDetector(
                            child: Container(
                              child: Column(
                                children: [
                                  Image.asset(
                                    'asset/image/report1.png',
                                    width: AppDimensions.d10w,
                                  ),
                                  Text(
                                    "Quản lý dịch vụ",
                                    style: TextStyle(
                                      color: AppColors.colorBlack_54,
                                      fontSize: AppFontSizes.fs10,
                                    ),
                                  ),
                                  SizedBox(
                                    height: AppDimensions.d0_5h,
                                  ),
                                ],
                              ),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: AppColors.colorGrey_400),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(AppDimensions.radius2w))),
                            ),
                            onTap: () {},
                          ),
                        ),
                        SizedBox(
                          width: AppDimensions.d2w,
                        ),
                        Expanded(
                          child: GestureDetector(
                            child: Container(
                              child: Column(
                                children: [
                                  Image.asset(
                                    'asset/image/report1.png',
                                    width: AppDimensions.d10w,
                                  ),
                                  Text(
                                    "Thêm hợp đồng",
                                    style: TextStyle(
                                      color: AppColors.colorBlack_54,
                                      fontSize: AppFontSizes.fs10,
                                    ),
                                  ),
                                  SizedBox(
                                    height: AppDimensions.d0_5h,
                                  ),
                                ],
                              ),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: AppColors.colorGrey_400),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(AppDimensions.radius2w))),
                            ),
                            onTap: () {},
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _showDialogRoom() {
    return UIHelper.showDialogCommon(
        context: context,
        widget: Padding(
          padding: EdgeInsets.all(AppDimensions.d1h),
          child: BlocBuilder(
              cubit: _allRoomBloc,
              builder: (context, state) {
                return Column(
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            _showDialogCreateRoom(
                                context: context, allRoomBloc: _allRoomBloc);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: AppColors.colorOrange,
                              borderRadius: BorderRadius.all(
                                Radius.circular(AppDimensions.radius1_0w),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(AppDimensions.d1h),
                              child: Text(
                                "Thêm phòng",
                                style: TextStyle(
                                  color: AppColors.colorWhite,
                                  fontSize: AppFontSizes.fs12,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(),
                        ),
                        CloseDialog(
                          color: AppColors.colorBlack,
                          onClose: () {
                            Navigator.pop(context);
                          },
                        )
                      ],
                    ),
                    Divider(),
                    Expanded(
                      child: SingleChildScrollView(
                        child: ItemRoom(
                          allRoomBloc: _allRoomBloc,
                        ),
                      ),
                    )
                  ],
                );
              }),
        ));
  }

  _showDialogCreateRoom({BuildContext context, AllRoomBloc allRoomBloc}) {
    return UIHelper.showDialogCommon(
      context: context,
      widget: BlocListener(
        cubit: allRoomBloc,
        listener: (context, state) async {
          if (state is LoadingCreateRoomState) {
            UIHelper.showLoadingCommon(context: context);
          }
          if (state is CreateRoomDone) {
            Navigator.pop(context);
            Navigator.pop(context);
            _showDialogCreateService(
                allRoomBloc: allRoomBloc, context: context);
          }
        },
        child: BlocBuilder(
          cubit: allRoomBloc,
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Thêm phòng",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    CloseDialog(
                      color: AppColors.colorBlack,
                      onClose: () {
                        Navigator.pop(context);
                        // allRoomBloc.add(UpdateUIRoomEvent());
                      },
                    )
                  ],
                ),
                SizedBox(
                  height: AppDimensions.d1h,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Tên Phòng *",
                      style: TextStyle(
                        color: AppColors.colorBlack_87,
                        fontSize: AppFontSizes.fs10,
                      ),
                    ),
                    Container(
                      child: CupertinoTextField(
                        controller: allRoomBloc.textRoomName,
                        placeholderStyle: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: AppDimensions.d1h,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Giá tiền *",
                      style: TextStyle(
                        color: AppColors.colorBlack_87,
                        fontSize: AppFontSizes.fs10,
                      ),
                    ),
                    Container(
                      child: CupertinoTextField(
                        inputFormatters: _formatter,
                        controller: allRoomBloc.textPrice,
                        placeholderStyle: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: AppDimensions.d1h,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Số người/phòng *",
                            style: TextStyle(
                              color: AppColors.colorBlack_87,
                              fontSize: AppFontSizes.fs10,
                            ),
                          ),
                          Container(
                            child: CupertinoTextField(
                              controller: allRoomBloc.textMaxP,
                              inputFormatters: _formatter1,
                              placeholderStyle: TextStyle(color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: AppDimensions.d1h,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Số người hiện tại *",
                            style: TextStyle(
                              color: AppColors.colorBlack_87,
                              fontSize: AppFontSizes.fs10,
                            ),
                          ),
                          Container(
                            child: CupertinoTextField(
                              controller: allRoomBloc.textCurP,
                              inputFormatters: _formatter1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: AppDimensions.d1h,
                ),
                _buildButton(
                    allRoomBloc: allRoomBloc,
                    ontap: () {
                      if (allRoomBloc.textRoomName.text == "") {
                        Fluttertoast.showToast(
                            msg: "Nhập tên phòng",
                            toastLength: Toast.LENGTH_SHORT);
                        return;
                      } else if (allRoomBloc.textPrice.text == "") {
                        Fluttertoast.showToast(
                            msg: "Nhập giá phòng",
                            toastLength: Toast.LENGTH_SHORT);
                        return;
                      } else if (allRoomBloc.textMaxP.text == "") {
                        Fluttertoast.showToast(
                            msg: "Nhập số người tối đa trong phòng",
                            toastLength: Toast.LENGTH_SHORT);
                        return;
                      } else if (allRoomBloc.textCurP.text == "") {
                        Fluttertoast.showToast(
                            msg: "Nhập số người hiện tại trong phòng",
                            toastLength: Toast.LENGTH_SHORT);
                        return;
                      } else {
                        allRoomBloc.add(CreateRoomEvent(appBloc: _appBloc));
                      }
                    })
              ],
            );
          },
        ),
      ),
    );
  }

  _showDialogCreateService({BuildContext context, AllRoomBloc allRoomBloc}) {
    return UIHelper.showDialogCommon(
      context: context,
      widget: BlocListener(
        cubit: allRoomBloc,
        listener: (context, state) {
          if (state is LoadingCreateServiceState) {
            UIHelper.showLoadingCommon(context: context);
          }
          if (state is CreateServiceDone) {
            Navigator.pop(context);
            Navigator.pop(context);
            return;
          }
        },
        child: BlocBuilder(
          cubit: allRoomBloc,
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Dịch vụ",
                  textAlign: TextAlign.start,
                ),
                SizedBox(
                  height: AppDimensions.d1h,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Điện",
                            style: TextStyle(
                              color: AppColors.colorBlack_87,
                              fontSize: AppFontSizes.fs10,
                            ),
                          ),
                          Container(
                            child: CupertinoTextField(
                              controller: allRoomBloc.textElectron,
                              inputFormatters: _formatter1,
                              placeholder: "Nhập số cũ",
                              placeholderStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: AppFontSizes.fs10),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: AppDimensions.d1h,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Đơn giá ",
                            style: TextStyle(
                              color: AppColors.colorBlack_87,
                              fontSize: AppFontSizes.fs10,
                            ),
                          ),
                          Container(
                            child: CupertinoTextField(
                              controller: allRoomBloc.textUnitElectron,
                              inputFormatters: _formatter,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: AppDimensions.d1h,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Nước ",
                            style: TextStyle(
                              color: AppColors.colorBlack_87,
                              fontSize: AppFontSizes.fs10,
                            ),
                          ),
                          Container(
                            child: CupertinoTextField(
                              controller: allRoomBloc.textWater,
                              inputFormatters: _formatter1,
                              placeholder: "Nhập số cũ",
                              placeholderStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: AppFontSizes.fs10),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: AppDimensions.d1h,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Đơn giá",
                            style: TextStyle(
                              color: AppColors.colorBlack_87,
                              fontSize: AppFontSizes.fs10,
                            ),
                          ),
                          Container(
                            child: CupertinoTextField(
                              controller: allRoomBloc.textUnitWater,
                              inputFormatters: _formatter,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                _buildButton(
                    allRoomBloc: allRoomBloc,
                    ontap: () {
                      if (allRoomBloc.textElectron.text == "") {
                        Fluttertoast.showToast(
                            msg: "Nhập số điện",
                            toastLength: Toast.LENGTH_SHORT);
                        return;
                      } else if (allRoomBloc.textWater.text == "") {
                        Fluttertoast.showToast(
                            msg: "Nhập số nước",
                            toastLength: Toast.LENGTH_SHORT);
                        return;
                      } else if (allRoomBloc.textUnitWater.text == "") {
                        Fluttertoast.showToast(
                            msg: "Nhập đon giá nước",
                            toastLength: Toast.LENGTH_SHORT);
                        return;
                      } else if (allRoomBloc.textUnitElectron.text == "") {
                        Fluttertoast.showToast(
                            msg: "Nhập đơn giá điện",
                            toastLength: Toast.LENGTH_SHORT);
                        return;
                      } else {
                        allRoomBloc.listService.add(
                          Service(
                            serviceName: "điện",
                            numberStart:
                                int.tryParse(allRoomBloc.textElectron.text),
                            unit: "kw/h",
                            roomId: allRoomBloc.roomId,
                            unitPrice: double.tryParse(
                                allRoomBloc.textUnitElectron.text),
                            totalService: 0.0,
                            isCheck: false,
                            startNumberTextEdit: TextEditingController(),
                            endNumberTextEdit: TextEditingController(),
                          ),
                        );
                        allRoomBloc.listService.add(
                          Service(
                            serviceName: "nước",
                            numberStart:
                                int.tryParse(allRoomBloc.textWater.text),
                            unit: "đ/m3",
                            roomId: allRoomBloc.roomId,
                            unitPrice:
                                double.tryParse(allRoomBloc.textUnitWater.text),
                            totalService: 0.0,
                            isCheck: false,
                            startNumberTextEdit: TextEditingController(),
                            endNumberTextEdit: TextEditingController(),
                          ),
                        );
                        allRoomBloc.add(CreateServiceEvent(appBloc: _appBloc));
                      }
                    })
              ],
            );
          },
        ),
      ),
    );
  }

  _buildButton({AllRoomBloc allRoomBloc, Function ontap}) {
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
}
