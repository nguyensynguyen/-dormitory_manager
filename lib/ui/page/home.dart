import 'package:dormitory_manager/bloc/all_room/bloc.dart';
import 'package:dormitory_manager/bloc/all_room/event.dart';
import 'package:dormitory_manager/bloc/all_room/state.dart';
import 'package:dormitory_manager/bloc/app_bloc/bloc.dart';
import 'package:dormitory_manager/bloc/auth/bloc.dart';
import 'package:dormitory_manager/bloc/auth/event.dart';
import 'package:dormitory_manager/bloc/auth/state.dart';
import 'package:dormitory_manager/bloc/contract/event.dart';
import 'package:dormitory_manager/helper/input_format.dart';
import 'package:dormitory_manager/helper/string_helper.dart';
import 'package:dormitory_manager/helper/ui_helper.dart';
import 'package:dormitory_manager/model/service.dart';
import 'package:dormitory_manager/resources/colors.dart';
import 'package:dormitory_manager/resources/dimensions.dart';
import 'package:dormitory_manager/resources/fontsizes.dart';
import 'package:dormitory_manager/ui/page/contract.dart';
import 'package:dormitory_manager/ui/page/notification.dart';
import 'package:dormitory_manager/ui/page/report.dart';
import 'package:dormitory_manager/ui/widget/close_dialog.dart';
import 'package:dormitory_manager/ui/widget/equipment_item.dart';
import 'package:dormitory_manager/ui/widget/item_room.dart';
import 'package:dormitory_manager/ui/widget/item_service.dart';
import 'package:dormitory_manager/ui/widget/show_dialog_create_contract.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'bill.dart';
import 'login.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int _curentIndex = 0;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('ic_launcher');
  FirebaseMessaging messaging = FirebaseMessaging();

  @override
  void initState() {
    super.initState();
    messaging.configure(
      onMessage: (Map<String, dynamic> response) async {
        print("onMessage: $response");
        _showPublicNotification(
            title: response['notification']['title'],
            content: response['notification']['body']);
      },
      onLaunch: (Map<String, dynamic> response) async {
        print("onLaunch: l");
      },
      onResume: (Map<String, dynamic> response) async {
        print("onResume: b");
      },
    );
  }

  final _tab = [
    BuildHome(),
    Bill(),
    Contract(),
    Container(
      child: Report(),
    ),
  ];

  routerPage() async {
    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String payload) async {
      if (payload != null) {
        if (payload == "report") {
          setState(() {
            _curentIndex = 3;
          });
        }
      }
    });
  }

  Future<void> _showPublicNotification({String title, String content}) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails("1000", "", "",
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker',
            visibility: NotificationVisibility.public);
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, '$title', '$content', platformChannelSpecifics,
        payload: 'report');
    routerPage();
  }

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
//          BottomNavigationBarItem(
//              icon: Icon(Icons.notifications_active),
//              title: Text("Thông báo"),
//              backgroundColor: Colors.blue),
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
  final List<TextInputFormatter> _formatter = [NumberFormats()];
  final List<TextInputFormatter> _formatter1 = [NumberFormats(isInt: true)];
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

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
      child: BlocBuilder(
        cubit: _allRoomBloc,
        builder: (context, state) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                "Trang chủ",
                                style: TextStyle(
                                    color: AppColors.colorWhite,
                                    fontSize: AppFontSizes.fs14,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            BlocListener(
                              listener: (context, state) {
                                if (state is LogOutDone) {
                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                          builder: (ctx) => Login()),
                                      (Route<dynamic> route) => true);
                                }
                              },
                              cubit: _authBloc,
                              child: Center(
                                child: GestureDetector(
                                  onTap: () {
                                    _authBloc
                                        .add(LogOutEvent(appBloc: _appBloc));
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: AppDimensions.d10h,
                                    decoration: BoxDecoration(
                                      color: AppColors.colorOrange,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(
                                            AppDimensions.radius1_0w),
                                      ),
                                    ),
                                    child: Padding(
                                      padding:
                                          EdgeInsets.all(AppDimensions.d1h),
                                      child: Text(
                                        "Đăng xuất",
                                        style: TextStyle(
                                            color: AppColors.colorWhite,
                                            fontSize: AppFontSizes.fs12,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
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
              _appBloc.isUser ? _buildUser() : _buildManager(),
              _appBloc.isUser
                  ? _buildProfileManagerForUser()
                  : _buildProfileManager()
            ],
          );
        },
      ),
    );
  }

  _buildProfileManager() {
    return BlocListener(
      listener: (context, state) {},
      cubit: _authBloc,
      child: BlocBuilder(
        cubit: _authBloc,
        builder: (context, state) {
          return Padding(
            padding: EdgeInsets.all(AppDimensions.d1h),
            child: Column(
              children: [
                Image.asset(
                  "asset/image/manager.png",
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
                                "${_appBloc?.manager?.managerName}",
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
                                "${_appBloc?.manager?.email}",
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
                                "0${_appBloc?.manager?.phone}",
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
                                "${_appBloc?.manager?.address}",
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
                          GestureDetector(
                            onTap: () {
                              _showChangeInfoManager(context);
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: AppDimensions.d8h,
                              decoration: BoxDecoration(
                                color: AppColors.colorFacebook,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(AppDimensions.radius1_0w),
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(AppDimensions.d1h),
                                child: Text(
                                  "Cập nhật thông tin",
                                  style: TextStyle(
                                      color: AppColors.colorWhite,
                                      fontSize: AppFontSizes.fs12,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: AppDimensions.d0_5h,
                          ),
                          GestureDetector(
                            onTap: () {
                              _showChangePass(context);
                            },
                            child: Container(
                              height: AppDimensions.d8h,
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
        },
      ),
    );
  }

  _showChangePass(BuildContext context, {int index}) {
    return UIHelper.showChangePass(
      newPass: _authBloc.newPass,
      oldPass: _authBloc.oldPass,
      context: context,
      message: "Đổi mật khẩu",
      widget: BlocListener(
        cubit: _authBloc,
        listener: (context, state) {
          if (state is LoadingChangePassState) {
            UIHelper.showLoadingCommon(context: context);
          }
          if (state is ChangPassDoneState) {
            Fluttertoast.showToast(
                backgroundColor: AppColors.colorFacebook,
                msg: "Đổi mật khẩu thành công",
                toastLength: Toast.LENGTH_LONG);
            Navigator.pop(context);
          }
          if (state is ChangePassError) {
            Fluttertoast.showToast(
                backgroundColor: AppColors.colorFacebook,
                msg: "Đổi mật khẩu thất bại",
                toastLength: Toast.LENGTH_LONG);
            Navigator.pop(context);
          }
        },
        child: BlocBuilder(
          cubit: _authBloc,
          builder: (context, st) {
            return Padding(
              padding: EdgeInsets.all(8.0),
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
                    style: TextStyle(
                        fontFamily: "San",
                        fontSize: AppFontSizes.fs10,
                        fontWeight: FontWeight.bold),
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
                      controller: _authBloc.oldPass,
                      placeholderStyle: TextStyle(
                          color: Colors.grey, fontSize: AppFontSizes.fs10),
                    ),
                  ),
                  SizedBox(
                    height: AppDimensions.d1h,
                  ),
                  Text(
                    "Mật khẩu mới",
                    style: TextStyle(
                        fontFamily: "San",
                        fontSize: AppFontSizes.fs10,
                        fontWeight: FontWeight.bold),
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
                      controller: _authBloc.newPass,
                      placeholderStyle: TextStyle(
                          color: Colors.grey, fontSize: AppFontSizes.fs10),
                    ),
                  ),
                  SizedBox(
                    height: AppDimensions.d1h,
                  ),
                  GestureDetector(
                    onTap: () {
                      if (_authBloc.oldPass.text == "") {
                        Fluttertoast.showToast(
                            backgroundColor: AppColors.colorFacebook,
                            msg: "Nhập mật khẩu cũ",
                            toastLength: Toast.LENGTH_LONG);
                        return;
                      }
                      if (_authBloc.newPass.text == "") {
                        Fluttertoast.showToast(
                            backgroundColor: AppColors.colorFacebook,
                            msg: "Nhập mật khẩu mới",
                            toastLength: Toast.LENGTH_LONG);
                        return;
                      }
                      _authBloc.add(ChangePassWordManager(appBloc: _appBloc));
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

  _showChangeInfoManager(BuildContext context, {int index}) {
    return UIHelper.showChangePass(
      newPass: _authBloc.newPass,
      oldPass: _authBloc.oldPass,
      context: context,
      widget: BlocListener(
        cubit: _authBloc,
        listener: (context, state) {
          if (state is LoadingChangePassState) {
            UIHelper.showLoadingCommon(context: context);
          }
          if (state is ChangPassDoneState) {
            Fluttertoast.showToast(
                backgroundColor: AppColors.colorFacebook,
                msg: "Cập nhật thông tin thành công",
                toastLength: Toast.LENGTH_LONG);
            Navigator.pop(context);
          }
          if (state is ChangePassError) {
            Fluttertoast.showToast(
                backgroundColor: AppColors.colorFacebook,
                msg: "Cập nhật thông tin thất bại",
                toastLength: Toast.LENGTH_LONG);
            Navigator.pop(context);
          }
        },
        child: BlocBuilder(
          cubit: _authBloc,
          builder: (context, st) {
            return Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Cập nhật thông tin',
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
                          _allRoomBloc.add(UpdateUIRoomEvent());
                        },
                      ),
                    ],
                  ),
                  Text(
                    "Họ tên",
                    style: TextStyle(
                        fontFamily: "San",
                        fontSize: AppFontSizes.fs10,
                        fontWeight: FontWeight.bold),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.colorGrey_300),
                      borderRadius: BorderRadius.all(
                        Radius.circular(AppDimensions.radius1_5w),
                      ),
                    ),
                    child: CupertinoTextField(
                      controller: _authBloc.nameManager,
                      placeholderStyle: TextStyle(
                          color: Colors.grey, fontSize: AppFontSizes.fs10),
                    ),
                  ),
                  SizedBox(
                    height: AppDimensions.d1h,
                  ),
                  Text(
                    "Email",
                    style: TextStyle(
                        fontFamily: "San",
                        fontSize: AppFontSizes.fs10,
                        fontWeight: FontWeight.bold),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.colorGrey_300),
                      borderRadius: BorderRadius.all(
                        Radius.circular(AppDimensions.radius1_5w),
                      ),
                    ),
                    child: CupertinoTextField(
                      controller: _authBloc.emailManager,
                      placeholderStyle: TextStyle(
                          color: Colors.grey, fontSize: AppFontSizes.fs10),
                    ),
                  ),
                  SizedBox(
                    height: AppDimensions.d1h,
                  ),
                  Text(
                    "Số điện thoại",
                    style: TextStyle(
                        fontFamily: "San",
                        fontSize: AppFontSizes.fs10,
                        fontWeight: FontWeight.bold),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.colorGrey_300),
                      borderRadius: BorderRadius.all(
                        Radius.circular(AppDimensions.radius1_5w),
                      ),
                    ),
                    child: CupertinoTextField(
                      controller: _authBloc.phoneManager,
                      placeholderStyle: TextStyle(
                          color: Colors.grey, fontSize: AppFontSizes.fs10),
                    ),
                  ),
                  SizedBox(
                    height: AppDimensions.d1h,
                  ),
                  Text(
                    "Địa chỉ",
                    style: TextStyle(
                        fontFamily: "San",
                        fontSize: AppFontSizes.fs10,
                        fontWeight: FontWeight.bold),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.colorGrey_300),
                      borderRadius: BorderRadius.all(
                        Radius.circular(AppDimensions.radius1_5w),
                      ),
                    ),
                    child: CupertinoTextField(
                      controller: _authBloc.addressManager,
                      placeholderStyle: TextStyle(
                          color: Colors.grey, fontSize: AppFontSizes.fs10),
                    ),
                  ),
                  SizedBox(
                    height: AppDimensions.d1h,
                  ),
                  GestureDetector(
                    onTap: () {
                      if (_authBloc.nameManager.text == "") {
                        Fluttertoast.showToast(
                            backgroundColor: AppColors.colorFacebook,
                            msg: "Nhập tên",
                            toastLength: Toast.LENGTH_LONG);
                        return;
                      }
                      if (_authBloc.emailManager.text == "") {
                        Fluttertoast.showToast(
                            backgroundColor: AppColors.colorFacebook,
                            msg: "Nhập email",
                            toastLength: Toast.LENGTH_LONG);
                        return;
                      }
                      if (_authBloc.phoneManager.text == "") {
                        Fluttertoast.showToast(
                            backgroundColor: AppColors.colorFacebook,
                            msg: "Nhập số điện thoại",
                            toastLength: Toast.LENGTH_LONG);
                        return;
                      }
                      if (_authBloc.addressManager.text == "") {
                        Fluttertoast.showToast(
                            backgroundColor: AppColors.colorFacebook,
                            msg: "Nhập địa chỉ",
                            toastLength: Toast.LENGTH_LONG);
                        return;
                      }
                      _authBloc.add(ChangeProfileManager(appBloc: _appBloc));
                      // _allRoomBloc.add(UpdateUIRoomEvent());
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
                          "Lưu thông tin",
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

  _buildProfileManagerForUser() {
    return Padding(
      padding: EdgeInsets.all(AppDimensions.d1h),
      child: Column(
        children: [
          Text(
            "Thông tin người quản lý ",
            style: TextStyle(
                fontSize: AppFontSizes.fs16,
                color: AppColors.colorFacebook,
                fontWeight: FontWeight.bold),
          ),
          Text(
            "Thắc mắc hãy liên hệ thông tin dưới ",
            style: TextStyle(
                fontSize: AppFontSizes.fs12,
                color: AppColors.colorFacebook,
                fontFamily: "San"),
          ),
          SizedBox(
            height: AppDimensions.d0_5h,
          ),
          Image.asset(
            "asset/image/manager.png",
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
                          "${_appBloc?.displayManagerForUsre?.managerName ?? ""}",
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
                          "${_appBloc.displayManagerForUsre.email}",
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
                          "0${_appBloc.displayManagerForUsre.phone}",
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
                          "${_appBloc.displayManagerForUsre.address}",
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
    );
  }

  _buildManager() {
    return Expanded(
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
                      child: Card(
                        color: AppColors.colorFacebook,
                        child: Padding(
                          padding: EdgeInsets.all(AppDimensions.d1h),
                          child: Column(
                            children: [
                              Image.asset(
                                'asset/image/livingroom.png',
                                width: AppDimensions.d10w,
                              ),
                              SizedBox(
                                height: AppDimensions.d1h,
                              ),
                              Text(
                                "Quản lý phòng",
                                style: TextStyle(
                                  color: AppColors.colorWhite,
                                  fontSize: AppFontSizes.fs10,
                                ),
                              ),
                              SizedBox(
                                height: AppDimensions.d0_5h,
                              ),
                            ],
                          ),
                        ),
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
                      child: Card(
                        color: AppColors.colorFacebook,
                        child: Padding(
                          padding: EdgeInsets.all(AppDimensions.d1h),
                          child: Column(
                            children: [
                              Image.asset(
                                'asset/image/service.png',
                                width: AppDimensions.d10w,
                              ),
                              SizedBox(
                                height: AppDimensions.d1h,
                              ),
                              Text(
                                "Quản lý dịch vụ",
                                style: TextStyle(
                                  color: AppColors.colorWhite,
                                  fontSize: AppFontSizes.fs10,
                                ),
                              ),
                              SizedBox(
                                height: AppDimensions.d0_5h,
                              ),
                            ],
                          ),
                        ),
                      ),
                      onTap: () {
                        _showDialogService();
                      },
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      child: Card(
                        color: AppColors.colorFacebook,
                        child: Padding(
                          padding: EdgeInsets.all(AppDimensions.d1h),
                          child: Column(
                            children: [
                              Image.asset(
                                'asset/image/repair.png',
                                width: AppDimensions.d10w,
                              ),
                              SizedBox(
                                height: AppDimensions.d1h,
                              ),
                              Text(
                                " Thiết bị phòng",
                                style: TextStyle(
                                  color: AppColors.colorWhite,
                                  fontSize: AppFontSizes.fs10,
                                ),
                              ),
                              SizedBox(
                                height: AppDimensions.d0_5h,
                              ),
                            ],
                          ),
                        ),
                      ),
                      onTap: () {
                        _showDialogEquipment();
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildUser() {
    return Container();
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
                        SizedBox(
                          width: AppDimensions.d1w,
                        ),
                        GestureDetector(
                          onTap: () {
                            _showDialog(context);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: AppColors.colorFacebook,
                              borderRadius: BorderRadius.all(
                                Radius.circular(AppDimensions.radius1_0w),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(AppDimensions.d1h),
                              child: Text(
                                "Lọc danh sách phòng",
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
                          appBloc: _appBloc,
                        ),
                      ),
                    )
                  ],
                );
              }),
        ));
  }

  _showDialog(BuildContext context) {
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
                      "Lọc danh sách phòng",
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
                  _allRoomBloc.add(RoomAllEvent(appBloc: _appBloc));
                },
                child: Text("Tất cả phòng"),
              ),
              Divider(),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  _allRoomBloc.add(RoomEmptyEvent(appBloc: _appBloc));
                },
                child: Text("phòng đang trống"),
              ),
              Divider(),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  _allRoomBloc.add(RoomLiveEvent(appBloc: _appBloc));
                },
                child: Text("Phòng đang ở"),
              ),
              Divider(),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  _allRoomBloc.add(RoomFullEvent(appBloc: _appBloc));
                },
                child: Text("Phòng full"),
              ),
              Divider(),
            ],
          ),
        ),
      ]),
    );
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
            Fluttertoast.showToast(
                backgroundColor: AppColors.colorFacebook,
                msg: "Thêm phòng thành công",
                toastLength: Toast.LENGTH_SHORT);
          }
        },
        child: BlocBuilder(
          cubit: allRoomBloc,
          builder: (context, state) {
            return Padding(
              padding: EdgeInsets.all(AppDimensions.d1h),
              child: Column(
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
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.colorGrey_300),
                          borderRadius: BorderRadius.all(
                            Radius.circular(AppDimensions.radius1_5w),
                          ),
                        ),
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
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.colorGrey_300),
                          borderRadius: BorderRadius.all(
                            Radius.circular(AppDimensions.radius1_5w),
                          ),
                        ),
                        child: CupertinoTextField(
                          inputFormatters: [
                            WhitelistingTextInputFormatter.digitsOnly,
                            CurrencyInputFormatter()
                          ],
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
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: AppColors.colorGrey_300),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(AppDimensions.radius1_5w),
                                ),
                              ),
                              child: CupertinoTextField(
                                controller: allRoomBloc.textMaxP,
                                inputFormatters: _formatter1,
                                placeholderStyle:
                                    TextStyle(color: Colors.black),
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
                              backgroundColor: AppColors.colorFacebook,
                              msg: "Nhập tên phòng",
                              toastLength: Toast.LENGTH_SHORT);
                          return;
                        } else if (allRoomBloc.textPrice.text == "") {
                          Fluttertoast.showToast(
                              backgroundColor: AppColors.colorFacebook,
                              msg: "Nhập giá phòng",
                              toastLength: Toast.LENGTH_SHORT);
                          return;
                        } else if (allRoomBloc.textMaxP.text == "") {
                          Fluttertoast.showToast(
                              backgroundColor: AppColors.colorFacebook,
                              msg: "Nhập số người tối đa trong phòng",
                              toastLength: Toast.LENGTH_SHORT);
                          return;
                        } else {
                          allRoomBloc.add(CreateRoomEvent(appBloc: _appBloc));
                        }
                      })
                ],
              ),
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
            Fluttertoast.showToast(
                backgroundColor: AppColors.colorFacebook,
                msg: "Thêm dịch vụ thành công",
                toastLength: Toast.LENGTH_SHORT);
            return;
          }
        },
        child: SingleChildScrollView(
          child: BlocBuilder(
            cubit: allRoomBloc,
            builder: (context, state) {
              return Padding(
                padding: EdgeInsets.all(AppDimensions.d1h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Dịch vụ *",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: AppColors.colorBlack,
                              fontSize: AppFontSizes.fs12,
                              fontWeight: FontWeight.bold),
                        ),
                        Expanded(
                          child: Container(),
                        ),
                        CloseDialog(
                          color: AppColors.colorBlack,
                          onClose: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                    Divider(),
                    Text(
                      "Chọn phòng *",
                      style: TextStyle(
                        color: AppColors.colorBlack_87,
                        fontSize: AppFontSizes.fs10,
                      ),
                    ),
                    SizedBox(
                      height: AppDimensions.d1h,
                    ),
                    GestureDetector(
                      onTap: () {
                        _showDialogListRoomCreateService(_appBloc);
                      },
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
                              Text(_allRoomBloc.roomCreateService?.roomName ??
                                  ""),
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
                                "Tên dịch vụ *",
                                style: TextStyle(
                                  color: AppColors.colorBlack_87,
                                  fontSize: AppFontSizes.fs10,
                                ),
                              ),
                              SizedBox(
                                height: AppDimensions.d1h,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: AppColors.colorGrey_300),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(AppDimensions.radius1_5w),
                                  ),
                                ),
                                child: CupertinoTextField(
                                  controller: allRoomBloc.textNameService,
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
                                "Đơn giá *",
                                style: TextStyle(
                                  color: AppColors.colorBlack_87,
                                  fontSize: AppFontSizes.fs10,
                                ),
                              ),
                              SizedBox(
                                height: AppDimensions.d1h,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: AppColors.colorGrey_300),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(AppDimensions.radius1_5w),
                                  ),
                                ),
                                child: CupertinoTextField(
                                    controller: allRoomBloc.textUnitService,
                                    inputFormatters: [
                                      WhitelistingTextInputFormatter.digitsOnly,
                                      CurrencyInputFormatter()
                                    ]),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: AppDimensions.d1h,
                    ),
                    Text(
                      "Kiểu dịch vụ *",
                      style: TextStyle(
                        color: AppColors.colorBlack_87,
                        fontSize: AppFontSizes.fs12,
                      ),
                    ),
                    SizedBox(
                      height: AppDimensions.d1h,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            child: Card(
                              color: _allRoomBloc.iCheckTypeService == 1
                                  ? AppColors.colorFacebook
                                  : AppColors.colorGrey_400,
                              child: Padding(
                                padding: EdgeInsets.all(AppDimensions.d1h),
                                child: Column(
                                  children: [
                                    Image.asset(
                                      'asset/image/electrical.png',
                                      width: AppDimensions.d10w,
                                    ),
                                    SizedBox(
                                      height: AppDimensions.d1h,
                                    ),
                                    Text(
                                      "Điện",
                                      style: TextStyle(
                                        color: AppColors.colorWhite,
                                        fontSize: AppFontSizes.fs10,
                                      ),
                                    ),
                                    SizedBox(
                                      height: AppDimensions.d0_5h,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            onTap: () {
                              _allRoomBloc.iCheckTypeService = 1;
                              _allRoomBloc.add(UpdateUIRoomEvent());
                            },
                          ),
                        ),
                        SizedBox(
                          height: AppDimensions.d1h,
                        ),
                        Expanded(
                          child: GestureDetector(
                            child: Card(
                              color: _allRoomBloc.iCheckTypeService == 2
                                  ? AppColors.colorFacebook
                                  : AppColors.colorGrey_400,
                              child: Padding(
                                padding: EdgeInsets.all(AppDimensions.d1h),
                                child: Column(
                                  children: [
                                    Image.asset(
                                      'asset/image/water.png',
                                      width: AppDimensions.d10w,
                                    ),
                                    SizedBox(
                                      height: AppDimensions.d1h,
                                    ),
                                    Text(
                                      "Nước",
                                      style: TextStyle(
                                        color: AppColors.colorWhite,
                                        fontSize: AppFontSizes.fs10,
                                      ),
                                    ),
                                    SizedBox(
                                      height: AppDimensions.d0_5h,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            onTap: () {
                              _allRoomBloc.iCheckTypeService = 2;
                              _allRoomBloc.add(UpdateUIRoomEvent());
                            },
                          ),
                        ),
                        SizedBox(
                          height: AppDimensions.d1h,
                        ),
                        Expanded(
                          child: GestureDetector(
                            child: Card(
                              color: _allRoomBloc.iCheckTypeService == 3
                                  ? AppColors.colorFacebook
                                  : AppColors.colorGrey_400,
                              child: Padding(
                                padding: EdgeInsets.all(AppDimensions.d1h),
                                child: Column(
                                  children: [
                                    Image.asset(
                                      'asset/image/service1.png',
                                      width: AppDimensions.d10w,
                                    ),
                                    SizedBox(
                                      height: AppDimensions.d1h,
                                    ),
                                    Text(
                                      "Dịch vụ khác",
                                      style: TextStyle(
                                        color: AppColors.colorWhite,
                                        fontSize: AppFontSizes.fs10,
                                      ),
                                    ),
                                    SizedBox(
                                      height: AppDimensions.d0_5h,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            onTap: () {
                              _allRoomBloc.iCheckTypeService = 3;
                              _allRoomBloc.add(UpdateUIRoomEvent());
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: AppDimensions.d1h,
                    ),
                    _allRoomBloc.iCheckTypeService == 1
                        ? Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Nhập số điện cũ *",
                                      style: TextStyle(
                                        color: AppColors.colorBlack_87,
                                        fontSize: AppFontSizes.fs10,
                                      ),
                                    ),
                                    SizedBox(
                                      height: AppDimensions.d1h,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: AppColors.colorGrey_300),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(
                                              AppDimensions.radius1_5w),
                                        ),
                                      ),
                                      child: CupertinoTextField(
                                        controller:
                                            allRoomBloc.textOldNumberService,
                                        inputFormatters: _formatter1,
                                        placeholderStyle: TextStyle(
                                            color: Colors.grey,
                                            fontSize: AppFontSizes.fs10),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        : _allRoomBloc.iCheckTypeService == 2
                            ? Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Nhập số nước cũ *",
                                          style: TextStyle(
                                            color: AppColors.colorBlack_87,
                                            fontSize: AppFontSizes.fs10,
                                          ),
                                        ),
                                        SizedBox(
                                          height: AppDimensions.d0_5h,
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: AppColors.colorGrey_300),
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(
                                                  AppDimensions.radius1_5w),
                                            ),
                                          ),
                                          child: CupertinoTextField(
                                            controller: allRoomBloc
                                                .textOldNumberService,
                                            inputFormatters: _formatter1,
                                            placeholderStyle: TextStyle(
                                                color: Colors.grey,
                                                fontSize: AppFontSizes.fs10),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            : Container(),
                    _buildButton(
                        allRoomBloc: allRoomBloc,
                        ontap: () {
                          if (allRoomBloc.textNameService.text == "") {
                            Fluttertoast.showToast(
                                backgroundColor: AppColors.colorFacebook,
                                msg: "Nhập tên dịch vụ",
                                toastLength: Toast.LENGTH_SHORT);
                            return;
                          } else if (allRoomBloc.textUnitService.text == "") {
                            Fluttertoast.showToast(
                                backgroundColor: AppColors.colorFacebook,
                                msg: "Nhập đơn giá",
                                toastLength: Toast.LENGTH_SHORT);
                            return;
                          } else {
                            if (_allRoomBloc.iCheckTypeService == 1) {
                              if (_allRoomBloc.textOldNumberService.text ==
                                  "") {
                                Fluttertoast.showToast(
                                    backgroundColor: AppColors.colorFacebook,
                                    msg: "Nhập số cũ",
                                    toastLength: Toast.LENGTH_SHORT);
                                return;
                              }
                              allRoomBloc.listService.add(
                                Service(
                                  serviceName:
                                      _allRoomBloc.textNameService.text,
                                  numberStart: int.tryParse(
                                      allRoomBloc.textOldNumberService.text),
                                  unit: "kw/h",
                                  roomId: allRoomBloc.roomId,
                                  unitPrice: double.tryParse(allRoomBloc
                                      .textUnitService.text
                                      .replaceAll(".", '')
                                      .trim()),
                                  totalService: 0.0,
                                  isCheck: false,
                                  startNumberTextEdit: TextEditingController(),
                                  endNumberTextEdit: TextEditingController(),
                                ),
                              );
                            } else if (_allRoomBloc.iCheckTypeService == 2) {
                              if (_allRoomBloc.textOldNumberService.text ==
                                  "") {
                                Fluttertoast.showToast(
                                    backgroundColor: AppColors.colorFacebook,
                                    msg: "Nhập số cũ",
                                    toastLength: Toast.LENGTH_SHORT);
                                return;
                              }
                              allRoomBloc.listService.add(
                                Service(
                                  serviceName:
                                      _allRoomBloc.textNameService.text,
                                  numberStart: int.tryParse(
                                      allRoomBloc.textOldNumberService.text),
                                  unit: "đ/m3",
                                  roomId: allRoomBloc.roomId,
                                  unitPrice: double.tryParse(allRoomBloc
                                      .textUnitService.text
                                      .replaceAll(".", '')
                                      .trim()),
                                  totalService: 0.0,
                                  isCheck: false,
                                  startNumberTextEdit: TextEditingController(),
                                  endNumberTextEdit: TextEditingController(),
                                ),
                              );
                            } else {
                              allRoomBloc.listService.add(
                                Service(
                                  serviceName:
                                      _allRoomBloc.textNameService.text,
                                  numberStart: 0,
                                  unit: "",
                                  roomId: allRoomBloc.roomId,
                                  unitPrice: double.tryParse(allRoomBloc
                                      .textUnitService.text
                                      .replaceAll(".", '')
                                      .trim()),
                                  totalService: 0.0,
                                  isCheck: false,
                                  startNumberTextEdit: TextEditingController(),
                                  endNumberTextEdit: TextEditingController(),
                                ),
                              );
                            }

                            allRoomBloc
                                .add(CreateServiceEvent(appBloc: _appBloc));
                          }
                        })
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  _buildButton({AllRoomBloc allRoomBloc, Function ontap}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppDimensions.d1h),
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

  _showDialogEquipment() {
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
                            _showDialogCreateEquipment(
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
                                "Thêm thiết bị",
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
                        child: ItemEquipment(
                          appBloc: _appBloc,
                          allRoomBloc: _allRoomBloc,
                        ),
                      ),
                    )
                  ],
                );
              }),
        ));
  }

  _showDialogCreateEquipment({BuildContext context, AllRoomBloc allRoomBloc}) {
    return UIHelper.showDialogCommon(
      context: context,
      widget: BlocListener(
        cubit: allRoomBloc,
        listener: (context, state) {
          if (state is LoadingCreateEquipmentState) {
            UIHelper.showLoadingCommon(context: context);
          }
          if (state is CreateEquipmentDoneState) {
            Navigator.pop(context);
            Fluttertoast.showToast(
                backgroundColor: AppColors.colorFacebook,
                msg: "Thêm thiết bị thành công",
                toastLength: Toast.LENGTH_SHORT);
            return;
          }
        },
        child: BlocBuilder(
          cubit: allRoomBloc,
          builder: (context, state) {
            return Padding(
              padding: EdgeInsets.all(AppDimensions.d1h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Thêm thiết bị",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: AppColors.colorBlack,
                              fontSize: AppFontSizes.fs12,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: AppDimensions.d1h,
                      ),
                      CloseDialog(
                        color: AppColors.colorBlack,
                        onClose: () {
                          Navigator.pop(context);
                        },
                      )
                    ],
                  ),
                  SizedBox(
                    height: AppDimensions.d1h,
                  ),
                  Text(
                    "Chọn phòng *",
                    style: TextStyle(
                      color: AppColors.colorBlack_87,
                      fontSize: AppFontSizes.fs10,
                    ),
                  ),
                  SizedBox(
                    height: AppDimensions.d1h,
                  ),
                  GestureDetector(
                    onTap: () {
                      _showDialogListRoom(_appBloc);
                    },
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
                            Text(_allRoomBloc.room?.roomName ?? ""),
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
                  SizedBox(
                    height: AppDimensions.d1h,
                  ),
                  Text(
                    "Tên thiết bị *",
                    style: TextStyle(
                      color: AppColors.colorBlack_87,
                      fontSize: AppFontSizes.fs10,
                    ),
                  ),
                  SizedBox(
                    height: AppDimensions.d1h,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.colorGrey_300),
                      borderRadius: BorderRadius.all(
                        Radius.circular(AppDimensions.radius1_5w),
                      ),
                    ),
                    child: CupertinoTextField(
                      controller: allRoomBloc.textEquipment,
                      placeholderStyle: TextStyle(
                          color: Colors.grey, fontSize: AppFontSizes.fs10),
                    ),
                  ),
                  SizedBox(
                    height: AppDimensions.d1h,
                  ),
                  Text(
                    "Tình trạng",
                    style: TextStyle(
                      color: AppColors.colorBlack_87,
                      fontSize: AppFontSizes.fs10,
                    ),
                  ),
                  SizedBox(
                    height: AppDimensions.d1h,
                  ),
                  GestureDetector(
                    onTap: () {
                      _showStatusEqipment();
                    },
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
                            Text(_allRoomBloc.status),
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
                  _buildButton(
                      allRoomBloc: allRoomBloc,
                      ontap: () {
                        if (allRoomBloc.room == null) {
                          Fluttertoast.showToast(
                              backgroundColor: AppColors.colorFacebook,
                              msg: "Chọn phòng",
                              toastLength: Toast.LENGTH_SHORT);
                          return;
                        } else if (allRoomBloc.textEquipment.text == "") {
                          Fluttertoast.showToast(
                              backgroundColor: AppColors.colorFacebook,
                              msg: "Nhập tên thiết bị",
                              toastLength: Toast.LENGTH_SHORT);
                          return;
                        } else {
                          allRoomBloc
                              .add(CreateEquipmentEvent(appBloc: _appBloc));
                        }
                      })
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  _showDialogListRoom(AppBloc appBloc) {
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
                _allRoomBloc.room = appBloc.listAllDataRoom[i];
                // appBloc.index = i;
                Navigator.pop(context);
                _allRoomBloc.add(UpdateUIRoomEvent());
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

  _showDialogListRoomCreateService(AppBloc appBloc) {
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
                _allRoomBloc.roomCreateService = appBloc.listAllDataRoom[i];
                Navigator.pop(context);
                _allRoomBloc.add(UpdateUIRoomEvent());
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

  _showStatusEqipment() {
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
                  _allRoomBloc.status = "Hỏng";

                  Navigator.pop(context);
                  _allRoomBloc.add(UpdateUIRoomEvent());
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
                  _allRoomBloc.status = "Hoạt động";

                  Navigator.pop(context);
                  _allRoomBloc.add(UpdateUIRoomEvent());
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

  _showDialogService() {
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
                            // _showDialogCreateEquipment(
                            //     context: context, allRoomBloc: _allRoomBloc);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: AppColors.colorWhite,
                              borderRadius: BorderRadius.all(
                                Radius.circular(AppDimensions.radius1_0w),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(AppDimensions.d1h),
                              child: Text(
                                "Danh sách dịch vụ từng phòng",
                                style: TextStyle(
                                    color: AppColors.colorFacebook,
                                    fontSize: AppFontSizes.fs12,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _showDialogCreateService(
                                allRoomBloc: _allRoomBloc, context: context);
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
                                "Thêm dịch vụ",
                                style: TextStyle(
                                    color: AppColors.colorWhite,
                                    fontSize: AppFontSizes.fs12,
                                    fontWeight: FontWeight.bold),
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
                        ),
                      ],
                    ),
                    Divider(),
                    Expanded(
                      child: SingleChildScrollView(
                        child: ItemService(
                          appBloc: _appBloc,
                        ),
                      ),
                    )
                  ],
                );
              }),
        ));
  }
}

class CurrencyInputFormatter extends TextInputFormatter {
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      print(true);
      return newValue;
    }

    double value = double.parse(newValue.text);

    final formatter = NumberFormat.currency(locale: 'vi');

    String newText = formatter.format(value).replaceAll('VND', '').trim();

    return newValue.copyWith(
        text: newText,
        selection: new TextSelection.collapsed(offset: newText.length));
  }
}
