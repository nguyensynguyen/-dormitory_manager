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

class CreateEquipmentEvent extends RoomEvent {
  AppBloc appBloc;

  CreateEquipmentEvent({this.appBloc});
}

class RoomLiveEvent extends RoomEvent {
  AppBloc appBloc;

  RoomLiveEvent({this.appBloc});
}

class RoomFullEvent extends RoomEvent {
  AppBloc appBloc;

  RoomFullEvent({this.appBloc});
}

class RoomEmptyEvent extends RoomEvent {
  AppBloc appBloc;

  RoomEmptyEvent({this.appBloc});
}
class RoomAllEvent extends RoomEvent {
  AppBloc appBloc;

  RoomAllEvent({this.appBloc});
}


