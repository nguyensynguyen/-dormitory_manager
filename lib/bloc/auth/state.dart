class AuthState {}

class LoadingLogin extends AuthState {}

class LoginDone extends AuthState {}

class LoginFail extends AuthState {}

class LogOutDone extends AuthState {}

class LogOutFail extends AuthState {}

class LoadingCreate extends AuthState {}

class CreateDone extends AuthState {}

class CreateErrors extends AuthState {}

class LoadingChangePassState extends AuthState {}

class ChangPassDoneState extends AuthState {}

class ChangePassError extends AuthState {}
class UpdateUIState extends AuthState {}
