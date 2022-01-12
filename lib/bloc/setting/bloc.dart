import 'dart:convert';
import 'package:dormitory_manager/bloc/setting/event.dart';
import 'package:dormitory_manager/bloc/setting/state.dart';
import 'package:dormitory_manager/model/manager.dart';
import 'package:dormitory_manager/model/user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingBloc extends Bloc<SettingEvent, SettingState> {
  SettingBloc() : super(null);

  @override
  Stream<SettingState> mapEventToState(SettingEvent event) async* {
    if (event is SetDataLogin) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var dataUser = prefs.getString("user");
      var dataManager = prefs.getString("manager");

      if (dataUser != null) {
        event.appBloc.isUser = true;
        event.appBloc.profile = jsonDecode(dataUser) ?? null;
        event.appBloc.user = User.fromJson(jsonDecode(dataUser)) ?? null;
        event.appBloc.displayManagerForUsre = Manager.fromJson(jsonDecode(dataUser)['Manager']) ?? null;
        yield AuthSuccess();
      } else if (dataManager != null) {
        event.appBloc.isUser = false;
        event.appBloc.profile = jsonDecode(dataManager) ?? null;
        event.appBloc.manager =
            Manager.fromJson(jsonDecode(dataManager)) ?? null;
        yield AuthSuccess();
      } else {
        yield AuthFail();
      }
    }
  }
//manager1@gmail.com
}
