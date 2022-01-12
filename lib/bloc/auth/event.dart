import 'package:dormitory_manager/bloc/app_bloc/bloc.dart';

class AuthEvent{
}
class LoginEvent extends AuthEvent{
  AppBloc appBloc;
  LoginEvent({this.appBloc});
}
class LogOutEvent extends AuthEvent{
  AppBloc appBloc;
  LogOutEvent({this.appBloc});
}

class CreateManager extends AuthEvent{
}

class ChangePassWordManager extends AuthEvent{
  AppBloc appBloc;
  ChangePassWordManager({this.appBloc});
}

class ChangeProfileManager extends AuthEvent{
  AppBloc appBloc;
  ChangeProfileManager({this.appBloc});
}

class UpdateUI extends AuthEvent{}