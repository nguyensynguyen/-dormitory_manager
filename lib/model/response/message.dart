import 'package:dormitory_manager/model/message.dart';
import 'package:dormitory_manager/model/room.dart';
import 'package:dormitory_manager/model/room_eqiupment.dart';
import 'package:dormitory_manager/model/service.dart';
import 'package:dormitory_manager/model/user.dart';
import 'package:dormitory_manager/ui/page/bill.dart';

class MessageResponse {
  bool status;
  List<Message> mess;

  MessageResponse({this.mess, this.status});

  factory MessageResponse.fromJson(Map<String, dynamic> json) => MessageResponse(
    status: json['status'],
    mess: (json['data'] is List)
        ? json['data'].map<Message>((item) {
      return Message.fromJson(item);
    }).toList()
        : [],
  );
}
