import 'dart:convert';
import 'package:dormitory_manager/bloc/setting/event.dart';
import 'package:dormitory_manager/bloc/setting/state.dart';
import 'package:dormitory_manager/model/manager.dart';
import 'package:dormitory_manager/model/user.dart';
import 'package:dormitory_manager/provider/login_provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingBloc extends Bloc<SettingEvent, SettingState> {
  SettingBloc() : super(null);

  @override
  Stream<SettingState> mapEventToState(SettingEvent event) async* {
    LoginProvider loginProvider = LoginProvider();

    if (event is SetDataLogin) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var dataUser = prefs.getString("user");
      var dataManager = prefs.getString("manager");

      if (dataUser != null) {
        event.appBloc.isUser = true;
        event.appBloc.profile = jsonDecode(dataUser) ?? null;
        event.appBloc.user = User.fromJson(jsonDecode(dataUser)) ?? null;
        event.appBloc.devicesToken = await loginProvider.getToken(id: event.appBloc.user.managerId)??"";
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

    if(event is GetAllManagerEvent){
      List<dynamic> allManager = await loginProvider.getAllManager();
      if(allManager != null){
        allManager.forEach((element) {
          event.appBloc.listManager.add(Manager(
            id: element['id'],
            email: element['email'],
            phone: element['phone']
          ));
        });
      }
    }
  }
//manager1@gmail.com
}
