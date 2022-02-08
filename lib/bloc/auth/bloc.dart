import 'dart:convert';
import 'package:dormitory_manager/bloc/auth/state.dart';
import 'package:dormitory_manager/model/manager.dart';
import 'package:dormitory_manager/model/response/all_room.dart';
import 'package:dormitory_manager/model/room.dart';
import 'package:dormitory_manager/model/user.dart';
import 'package:dormitory_manager/provider/login_provider.dart';
import 'package:dormitory_manager/provider/manager_provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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
  TextEditingController oldPass = TextEditingController();
  TextEditingController newPass = TextEditingController();
  String errorsMessage = "";
  FirebaseMessaging messaging = FirebaseMessaging();

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
          event.appBloc.displayManagerForUsre =
              Manager.fromJson(res['data']['Manager']);
          event.appBloc.devicesToken =
              event.appBloc.displayManagerForUsre.deviceToken;

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
          messaging.getToken().then((token) {
            event.appBloc.devicesToken = token;
            print('Device token: $token'); // Print the Token in Console
          });
          event.appBloc.profile = Manager.fromJson(res['data']);
          event.appBloc.manager = Manager.fromJson(res['data']);
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString("manager", jsonEncode(res['data']));
          await _loginProvider.changeProfileManager(
              id: event.appBloc.manager.id,
              datas: {"device_token": event.appBloc.devicesToken});
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
        await _loginProvider.changeProfileManager(
            id: event.appBloc.manager.id, datas: {"device_token": ""});
//       await messaging.deleteInstanceID();
        await prefs.remove('manager');
      }
      event.appBloc.manager = null;
      event.appBloc.user = null;
      event.appBloc.isUser = false;
      event.appBloc.profile = null;
      yield LogOutDone();
    }

    if (event is CreateManager) {
      yield LoadingCreate();

      if (nameManager.text == "") {
        errorsMessage = "Hãy nhập họ tên";
        yield CreateErrors();
        return;
      }
      if (emailManager.text == "") {
        errorsMessage = "Hãy nhập email";
        yield CreateErrors();
        return;
      }
      if (phoneManager.text == "") {
        errorsMessage = "Hãy nhập số điện thoại";
        yield CreateErrors();
        return;
      }
      if (addressManager.text == "") {
        errorsMessage = "Hãy nhập địa chỉ ";
        yield CreateErrors();
        return;
      }
      if (passwordManager.text == "") {
        errorsMessage = "Hãy nhập mật khẩu ";
        yield CreateErrors();
        return;
      }
      for (int i = 0; i < event.appBloc.listManager.length; i++) {
        if (emailManager.text == event.appBloc.listManager[i].email) {
          errorsMessage = "Email đã được đăng ký trước đó";
          yield CreateErrors();
          return;
        }
      }
      Map data = {
        "manager_name": nameManager.text,
        "email": emailManager.text,
        "phone": phoneManager.text,
        "address": addressManager.text,
        "password": passwordManager.text,
      };
      var res = await _managerProvider.createManager(data: data);
      if (res != null) {
        nameManager.text = "";
        emailManager.text = "";
        phoneManager.text = "";
        addressManager.text = "";
        passwordManager.text = "";

        yield CreateDone();
      } else {
        errorsMessage = "Tạo tài khoản thất bại";
        yield CreateErrors();
      }
    }
    if (event is ChangePassWordManager) {
      Map data = {
        "email": event.appBloc.manager.email,
        "old_password": oldPass.text,
        "password": newPass.text,
      };
      yield LoadingChangePassState();
      var res = await _loginProvider.changePassManager(datas: data);
      if (res != null) {
        oldPass.text = "";
        newPass.text = "";
        yield ChangPassDoneState();
      } else {
        yield ChangePassError();
      }
    }

    if (event is ChangeProfileManager) {
      Map data = {
        "id": event.appBloc.manager.id,
        "email": emailManager.text,
        "manager_name": nameManager.text,
        "phone": int.tryParse(phoneManager.text),
        "address": addressManager.text,
      };
      yield LoadingChangePassState();
      var res = await _loginProvider.changeProfileManager(
          datas: data, id: event.appBloc.manager.id);
      if (res != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("manager", jsonEncode(data));
        var updateM = prefs.get("manager");

        event.appBloc.manager = Manager.fromJson(jsonDecode(updateM));
        nameManager.text = "";
        emailManager.text = "";
        phoneManager.text = "";
        addressManager.text = "";
        yield ChangPassDoneState();
      } else {
        yield ChangePassError();
      }
    }
  }
}
