class RoomBillDetail {
  int id;
  String serviceName;
  double amountUse;
  double totalPrice;
  int roomBillId;

  RoomBillDetail(
      {this.totalPrice,
      this.id,
      this.amountUse,
      this.serviceName,
      this.roomBillId});

  factory RoomBillDetail.fromJson(Map<String, dynamic> json) => RoomBillDetail(
        id: json['id'],
        amountUse: (json['amount_use'] as num)?.toDouble(),
        serviceName: json['service_name'],
        totalPrice: (json['total_price'] as num)?.toDouble(),
        roomBillId: json['room_bill_id'],
      );
}