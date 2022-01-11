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
import 'package:dormitory_manager/ui/widget/equipment_item.dart';
import 'package:dormitory_manager/ui/widget/item_room.dart';
import 'package:dormitory_manager/ui/widget/item_service.dart';
import 'package:dormitory_manager/ui/widget/show_dialog_create_contract.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'bill.dart';
import 'login.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_mailer/flutter_mailer.dart';

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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            "Dormitory",
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
                                  MaterialPageRoute(builder: (ctx) => Login()),
                                  (Route<dynamic> route) => true);
                            }
                          },
                          cubit: _authBloc,
                          child: Center(
                            child: GestureDetector(
                              onTap: () {
                                _authBloc.add(LogOutEvent(appBloc: _appBloc));
                              },
                              child: Container(
                                alignment: Alignment.center,
                                height: AppDimensions.d10h,
                                decoration: BoxDecoration(
                                  color: AppColors.colorOrange,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(AppDimensions.radius1_0w),
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(AppDimensions.d1h),
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
                        )
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
          _appBloc.isUser ? _buildUser() : _buildManager()
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
            Navigator.pop(context);
            _showDialogCreateService(
                allRoomBloc: allRoomBloc, context: context);
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
                                placeholderStyle:
                                    TextStyle(color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: AppDimensions.d1h,
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
            Navigator.pop(context);
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
                  Text(
                    "Dịch vụ *",
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
                              "Điện *",
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
                              "Đơn giá *",
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
                              "Nước *",
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
                              "Đơn giá *",
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
                  SizedBox(
                    width: AppDimensions.d1h,
                  ),
                  Text("Dịch vụ khác "),
                  SizedBox(
                    width: AppDimensions.d1h,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Internet",
                        style: TextStyle(
                          color: AppColors.colorBlack_87,
                          fontSize: AppFontSizes.fs10,
                        ),
                      ),
                      CupertinoTextField(
                        controller: allRoomBloc.textInternet,
                        inputFormatters: _formatter1,
                        placeholder: "Nhập đơn giá",
                      ),
                    ],
                  ),
                  SizedBox(
                    width: AppDimensions.d1h,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Vệ sinh",
                        style: TextStyle(
                          color: AppColors.colorBlack_87,
                          fontSize: AppFontSizes.fs10,
                        ),
                      ),
                      CupertinoTextField(
                        controller: allRoomBloc.textVs,
                        inputFormatters: _formatter1,
                        placeholder: "Nhập đơn giá",
                      ),
                    ],
                  ),
                  SizedBox(
                    width: AppDimensions.d1h,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        " Gửi xe",
                        style: TextStyle(
                          color: AppColors.colorBlack_87,
                          fontSize: AppFontSizes.fs10,
                        ),
                      ),
                      CupertinoTextField(
                        controller: allRoomBloc.textGx,
                        inputFormatters: _formatter1,
                        placeholder: "Nhập đơn giá",
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
                              unitPrice: double.tryParse(
                                  allRoomBloc.textUnitWater.text),
                              totalService: 0.0,
                              isCheck: false,
                              startNumberTextEdit: TextEditingController(),
                              endNumberTextEdit: TextEditingController(),
                            ),
                          );
                          if (allRoomBloc.textInternet.text != "") {
                            allRoomBloc.listService.add(
                              Service(
                                serviceName: "Internet",
                                numberStart: 0,
                                unit: "",
                                roomId: allRoomBloc.roomId,
                                unitPrice: double.tryParse(
                                    allRoomBloc.textInternet.text),
                                totalService: 0.0,
                                isCheck: false,
                                startNumberTextEdit: TextEditingController(),
                                endNumberTextEdit: TextEditingController(),
                              ),
                            );
                          }

                          if (allRoomBloc.textVs.text != "") {
                            allRoomBloc.listService.add(
                              Service(
                                serviceName: "Vệ sinh",
                                numberStart: 0,
                                unit: "",
                                roomId: allRoomBloc.roomId,
                                unitPrice:
                                    double.tryParse(allRoomBloc.textVs.text),
                                totalService: 0.0,
                                isCheck: false,
                                startNumberTextEdit: TextEditingController(),
                                endNumberTextEdit: TextEditingController(),
                              ),
                            );
                          }
                          if (allRoomBloc.textGx.text != "") {
                            allRoomBloc.listService.add(
                              Service(
                                serviceName: "Gửi xe",
                                numberStart: 0,
                                unit: "",
                                roomId: allRoomBloc.roomId,
                                unitPrice:
                                    double.tryParse(allRoomBloc.textGx.text),
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
                msg: "Thêm thành công", toastLength: Toast.LENGTH_SHORT);
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
                  Text(
                    "Chọn phòng *",
                    style: TextStyle(
                      color: AppColors.colorBlack_87,
                      fontSize: AppFontSizes.fs10,
                    ),
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
                  Container(
                    child: CupertinoTextField(
                      controller: allRoomBloc.textEquipment,
                      placeholder: "Nhập tên thiết bị",
                      placeholderStyle: TextStyle(
                          color: Colors.grey, fontSize: AppFontSizes.fs10),
                    ),
                  ),
                  Text(
                    "Tình trạng",
                    style: TextStyle(
                      color: AppColors.colorBlack_87,
                      fontSize: AppFontSizes.fs10,
                    ),
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
                              msg: "Chọn phòng",
                              toastLength: Toast.LENGTH_SHORT);
                          return;
                        } else if (allRoomBloc.textEquipment.text == "") {
                          Fluttertoast.showToast(
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
