class RoomBillDetail {
  int id;
  String serviceName;
  int amountUse;
  double totalPrice;
  int roomBillId;
  int numberStart;
  int numberEnd;

  RoomBillDetail(
      {this.totalPrice,
      this.id,
      this.amountUse,
      this.numberStart,
      this.numberEnd,
      this.serviceName,
      this.roomBillId});

  factory RoomBillDetail.fromJson(Map<String, dynamic> json) => RoomBillDetail(
        id: json['id'],
        amountUse: (json['amount_used'] as num),
        serviceName: json['service_name'],
        totalPrice: (json['total_price'] as num)?.toDouble(),
        roomBillId: json['room_bill_id'],
        numberStart: (json['number_start'] as num),
        numberEnd: (json['number_end'] as num),
      );
}
