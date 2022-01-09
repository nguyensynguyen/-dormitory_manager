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
