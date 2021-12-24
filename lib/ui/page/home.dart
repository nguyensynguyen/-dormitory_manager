import 'package:dormitory_manager/bloc/app_bloc/bloc.dart';
import 'package:dormitory_manager/bloc/auth/bloc.dart';
import 'package:dormitory_manager/bloc/auth/event.dart';
import 'package:dormitory_manager/bloc/auth/state.dart';
import 'package:dormitory_manager/helper/ui_helper.dart';
import 'package:dormitory_manager/provider/manager_provider.dart';
import 'package:dormitory_manager/resources/colors.dart';
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
  AppBloc _appBloc;
  int _curentIndex = 0;

  @override
  void initState() {
    super.initState();
    _appBloc = BlocProvider.of<AppBloc>(context);
  }

  final _tab = [
    BuildHome(),
    Bill(),
    Container(
      child: Text("hop dong"),
    ),
    Container(
      child: Text("thong bao"),
    ),
    Container(
      child: Report(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tab[_curentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _curentIndex,
        type: BottomNavigationBarType.fixed,
        fixedColor: AppColors.colorFacebook,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Center(child: Text("Home")),
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _authBloc = AuthBloc();
    _appBloc = BlocProvider.of<AppBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      listener: (ctx, st) {
        if (st is LogOutDone) {
          Navigator.of(ctx).pushAndRemoveUntil(
              MaterialPageRoute(builder: (ctx) => Login()),
              (Route<dynamic> route) => true);
        }
        if (st is LoadingLogin) {
          UIHelper.showLoadingCommon();
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
    );
  }
}
