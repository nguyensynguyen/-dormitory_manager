import 'package:dormitory_manager/bloc/app_bloc/bloc.dart';

class RoomEvent{
}
class GetDataRoomEvent extends RoomEvent{
  AppBloc appBloc;
  GetDataRoomEvent({this.appBloc});
}