import 'dart:convert';
import 'package:dormitory_manager/bloc/auth/state.dart';
import 'package:dormitory_manager/model/manager.dart';
import 'package:dormitory_manager/model/response/all_room.dart';
import 'package:dormitory_manager/model/room.dart';
import 'package:dormitory_manager/model/user.dart';
import 'package:dormitory_manager/provider/login_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'event.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(null);
  LoginProvider _loginProvider = LoginProvider();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    if (event is LoginEvent) {
      Map data = {
        "email": email.text ?? "",
        "password": password.text ?? "",
        "manager_id": 1
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
          yield LoginFail();
        }
      }
    }

    if (event is GetDataRoomEvent) {
      yield LoadingLogin();
      var data = await _loginProvider.getAllRoom(id: event.appBloc.manager.id);
      if (data != null) {
        event.appBloc.listAllDataRoom = data['data'].map<Room>((item) {
          return Room.fromJson(item);
        }).toList();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('room', jsonEncode(data['data']));
        yield GetDataRoom();
      }
    }

    if (event is LogOutEvent) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (event.appBloc.isUser) {
        await prefs.remove('user');
      } else {
        await prefs.remove('manager');
        await prefs.remove('room');
      }
      event.appBloc.manager = null;
      event.appBloc.user = null;
      event.appBloc.isUser = false;
      event.appBloc.profile = null;
      yield LogOutDone();
    }
  }
}
