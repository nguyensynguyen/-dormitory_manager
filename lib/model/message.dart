import 'package:dormitory_manager/model/room.dart';
import 'package:dormitory_manager/model/user.dart';

class Message {
  int id;
  String title;
  String content;
  String status;
  int roomId;
  int managerId;
  int userId;
  int dateCreate;
  Room room;
  User user;

  Message(
      {this.status,
      this.id,
      this.roomId,
      this.managerId,
      this.userId,
      this.content,
      this.room,
      this.dateCreate,
      this.user,
      this.title});

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        id: json['id'],
        status: json['status'],
        roomId: json['room_id'],
        managerId: json['manager_id'],
        userId: json['user_id'],
        content: json['content'],
        title: json['title'],
        dateCreate: json['date_create'],
        room: Room.fromJson(json['Room']),
        user: User.fromJson(json['User']),
      );
}
