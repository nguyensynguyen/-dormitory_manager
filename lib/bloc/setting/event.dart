import 'package:dormitory_manager/bloc/app_bloc/bloc.dart';

class SettingEvent{
}
class SetDataLogin extends SettingEvent{
  AppBloc appBloc;
  SetDataLogin({this.appBloc});
}

class GetAllManagerEvent extends SettingEvent{
  AppBloc appBloc;
  GetAllManagerEvent({this.appBloc});
}