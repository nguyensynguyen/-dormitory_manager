import 'package:dormitory_manager/bloc/all_room/bloc.dart';
import 'package:dormitory_manager/bloc/all_room/event.dart';
import 'package:dormitory_manager/bloc/all_room/state.dart';
import 'package:dormitory_manager/bloc/app_bloc/bloc.dart';
import 'package:dormitory_manager/bloc/auth/bloc.dart';
import 'package:dormitory_manager/bloc/auth/event.dart';
import 'package:dormitory_manager/bloc/auth/state.dart';
import 'package:dormitory_manager/helper/ui_helper.dart';
import 'package:dormitory_manager/resources/colors.dart';
import 'package:dormitory_manager/resources/dimensions.dart';
import 'package:dormitory_manager/resources/fontsizes.dart';
import 'package:dormitory_manager/ui/page/contract.dart';
import 'package:dormitory_manager/ui/page/notification.dart';
import 'package:dormitory_manager/ui/page/report.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Trang chủ",
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
            Expanded(
              child: BlocListener(
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
                    child: Text("logout"),
                  ),
                ),
              ),
            )
            // Expanded(
            //   child: SingleChildScrollView(
            //     child: ItemContract(
            //       contractBloc: _contractBloc,
            //     ),
            //   ),
            // ),
          ],
        ));
  }
}
