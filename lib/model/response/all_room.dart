import 'package:dormitory_manager/model/room.dart';
import 'package:dormitory_manager/model/room_eqiupment.dart';
import 'package:dormitory_manager/model/service.dart';
import 'package:dormitory_manager/model/user.dart';
import 'package:dormitory_manager/ui/page/bill.dart';

class AllRoom {
  bool status;
  List<Room> room;

  AllRoom({this.room, this.status});

  factory AllRoom.fromJson(Map<String, dynamic> json) => AllRoom(
        status: json['status'],
        room: (json['data'] is List)
            ? json['data'].map<Room>((item) {
                return Room.fromJson(item);
              }).toList()
            : [],
      );
}
