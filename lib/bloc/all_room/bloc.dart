import 'package:dormitory_manager/bloc/all_room/state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'event.dart';

class AllRoomBloc extends Bloc<RoomEvent, RoomState> {
  AllRoomBloc() : super(null);

  @override
  Stream<RoomState> mapEventToState(RoomEvent event) {
    if (event is GetDataRoomEvent) {

    }
  }
}
