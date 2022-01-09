import 'dart:convert';
import 'package:dormitory_manager/bloc/auth/state.dart';
import 'package:dormitory_manager/model/manager.dart';
import 'package:dormitory_manager/model/response/all_room.dart';
import 'package:dormitory_manager/model/room.dart';
import 'package:dormitory_manager/model/user.dart';
import 'package:dormitory_manager/provider/login_provider.dart';
import 'package:dormitory_manager/provider/manager_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'event.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(null);
  LoginProvider _loginProvider = LoginProvider();
  ManagerProvider _managerProvider = ManagerProvider();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  TextEditingController emailManager = TextEditingController();
  TextEditingController passwordManager = TextEditingController();
  TextEditingController nameManager = TextEditingController();
  TextEditingController phoneManager = TextEditingController();
  TextEditingController addressManager = TextEditingController();
  String errorsMessage = "";

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    if (event is LoginEvent) {
      Map data = {
        "email": email.text ?? "",
        "password": password.text ?? "",
//        "manager_id": 1
      };
      yield LoadingLogin();
      if (event.appBloc.isUser) {
        var res = await _loginProvider.loginUser(datas: data);
        if (res != null) {
          event.appBloc.profile = User.fromJson(res['data']);
          event.appBloc.user = User.fromJson(res['data']);
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString("user", jsonEncode(res['data']));
          yield LoginDone();
        } else {
          errorsMessage = "Email hoặc mật khẩu không đúng";
          yield LoginFail();
        }
      } else {
        var res = await _loginProvider.loginManager(datas: data);
        if (res != null) {
          event.appBloc.profile = Manager.fromJson(res['data']);
          event.appBloc.manager = Manager.fromJson(res['data']);
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString("manager", jsonEncode(res['data']));
          // yield* mapEventToState(GetDataRoomEvent(appBloc: event.appBloc));
          yield LoginDone();
        } else {
          errorsMessage = "Email hoặc mật khẩu không đúng";
          yield LoginFail();
        }
      }
    }


    if (event is LogOutEvent) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (event.appBloc.isUser) {
        await prefs.remove('user');
      } else {
        await prefs.remove('manager');
      }
      event.appBloc.manager = null;
      event.appBloc.user = null;
      event.appBloc.isUser = false;
      event.appBloc.profile = null;
      yield LogOutDone();
    }

    if(event is CreateManager){
      yield LoadingCreate();
      if(nameManager.text == ""){
        errorsMessage = "Hãy nhập họ tên";
        yield CreateErrors();
        return;
      }
      if(emailManager.text == ""){
        errorsMessage = "Hãy nhập email";
        yield CreateErrors();
        return;
      }
      if(phoneManager.text == ""){
        errorsMessage = "Hãy nhập số điện thoại";
        yield CreateErrors();
        return;
      }
      if(addressManager.text == ""){
        errorsMessage = "Hãy nhập địa chỉ ";
        yield CreateErrors();
        return;
      }
      if(passwordManager.text == ""){
        errorsMessage = "Hãy nhập mật khẩu ";
        yield CreateErrors();
        return;
      }
      Map data ={
        "manager_name":nameManager.text,
        "email":emailManager.text,
        "phone":phoneManager.text ,
        "address":addressManager.text,
        "password":passwordManager.text,
      };
     var res = await _managerProvider.createManager(data: data);
     if(res != null){
       nameManager.text ="";
       emailManager.text ="";
       phoneManager.text ="";
       addressManager.text ="";
       passwordManager.text ="";

       yield CreateDone();
     }else{
       errorsMessage = "Tạo tài khoản thất bại";
       yield CreateErrors();
     }
    }
  }
}
