import 'package:dormitory_manager/model/room.dart';
import 'package:dormitory_manager/model/room_bill_detail.dart';

class RoomBill {
  int id;
  double totalPrice;
  String status;
  int dateCreate;
  int roomId;
  double totalService;
  List<RoomBillDetail> roomBillDetail;
  Room room;
  RoomBill(
      {this.id,
      this.roomId,
      this.dateCreate,
      this.status,
      this.totalPrice,
        this.room,
      this.totalService,this.roomBillDetail});

  factory RoomBill.fromJson(Map<String, dynamic> json) => RoomBill(
        id: json['id'],
        totalPrice: (json['total_price'] as num)?.toDouble(),
        status: json['status'],
        dateCreate: json['date_create'],
        roomId: json['room_id'],
        totalService: (json['total_service']as num)?.toDouble(),
       room: Room.fromJson(json['Room']),
       roomBillDetail: (json['room_bill_details'] is List) ?json['room_bill_details'].map<RoomBillDetail>((item) {
         return RoomBillDetail.fromJson(item);
       }).toList()
           : []);
}
