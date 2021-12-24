import 'package:dormitory_manager/model/room_bill.dart';

class AllBillResponse {
  bool status;
  List<RoomBill> roomBill;
  AllBillResponse({this.status, this.roomBill});

  factory AllBillResponse.fromJson(Map<String, dynamic> json) =>
      AllBillResponse(
          status: json['status'],
          roomBill: (json['data'] is List)
              ? json['data'].map<RoomBill>((item) {
                  return RoomBill.fromJson(item);
                }).toList()
              : []);
}
