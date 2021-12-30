import 'package:dormitory_manager/bloc/all_room/state.dart';
import 'package:dormitory_manager/model/room.dart';
import 'package:dormitory_manager/provider/manager_provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'event.dart';

class AllRoomBloc extends Bloc<RoomEvent, RoomState> {
  AllRoomBloc() : super(null);
  ManagerProvider _managerProvider = ManagerProvider();
 var lsitData = [];
  @override
  Stream<RoomState> mapEventToState(RoomEvent event) async* {
    if (event is GetDataRoomEvent) {
      if (lsitData.isEmpty) {
        yield LoadingState();
        var data =
            await _managerProvider.getAllRoom(id: event.appBloc.manager.id);
        if (data != null) {
          lsitData = data['data'];
          event.appBloc.listAllDataRoom = data['data'].map<Room>((item) {
            return Room.fromJson(item);
          }).toList();

          yield GetAllDataRoomState();
        }
      }
    }
  }
}
