import 'package:dormitory_manager/bloc/app_bloc/bloc.dart';

class RoomEvent {}

class GetDataRoomEvent extends RoomEvent {
  AppBloc appBloc;

  GetDataRoomEvent({this.appBloc});
}

class CreateRoomEvent extends RoomEvent {
  AppBloc appBloc;

  CreateRoomEvent({this.appBloc});
}

class CreateServiceEvent extends RoomEvent {
  AppBloc appBloc;

  CreateServiceEvent({this.appBloc});
}

class UpdateUIRoomEvent extends RoomEvent {}
