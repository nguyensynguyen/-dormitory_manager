import 'package:dormitory_manager/bloc/app_bloc/bloc.dart';
import 'package:dormitory_manager/bloc/app_bloc/event.dart';
import 'package:dormitory_manager/bloc/setting/bloc.dart';
import 'package:dormitory_manager/bloc/setting/event.dart';
import 'package:dormitory_manager/bloc/setting/state.dart';
import 'package:dormitory_manager/resources/colors.dart';
import 'package:dormitory_manager/resources/dimensions.dart';
import 'package:dormitory_manager/ui/page/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';

import 'home.dart';

class Splash extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SplashState();
  }
}

class SplashState extends State<Splash> {
  AppBloc _appBloc;
  SettingBloc _settingBloc;

  @override
  void initState() {
    super.initState();
    _appBloc = BlocProvider.of<AppBloc>(context);
    _settingBloc = SettingBloc();
    _settingBloc.add(SetDataLogin(appBloc: _appBloc));
    _settingBloc.add(GetAllManagerEvent(appBloc: _appBloc));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorWhite,
      body:BlocListener(
        cubit: _settingBloc,
        listener: (ctx,state) async{
          if(state is AuthSuccess){
            Navigator.of(ctx).pushAndRemoveUntil(
                MaterialPageRoute(builder: (ctx) => HomePage()),
                    (Route<dynamic> route) => false);
          }
          if(state is AuthFail){
            Navigator.of(ctx).pushAndRemoveUntil(
                MaterialPageRoute(builder: (ctx) => Login()),
                    (Route<dynamic> route) => false);
          }
        },
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(AppDimensions.radius2w),
              topLeft: Radius.circular(AppDimensions.radius2w),
            ),
          ),
          child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.all(
                      Radius.circular(AppDimensions.radius1_0w))),
              child: LiquidCircularProgressIndicator(
                value: 0.5,
                // Defaults to 0.5.
                valueColor: AlwaysStoppedAnimation(Colors.white),
                // Defaults to the current Theme's accentColor.
                backgroundColor: Colors.transparent,
                // Defaults to the current Theme's backgroundColor.
                borderColor: Colors.white,
                borderWidth: 2.0,
                direction: Axis
                    .vertical, // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.vertical.
              )),
        ),
      ),
    );
  }
}
