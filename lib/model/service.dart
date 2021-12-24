class Service {
  int id;
  String serviceName;
  double unitPrice;
  int roomId;

  Service({
    this.roomId,
    this.id,
    this.serviceName,
    this.unitPrice,
  });

  factory Service.fromJson(Map<String, dynamic> json) => Service(
        id: json['id'],
        serviceName: json['service_name'],
        unitPrice: (json['unit_price']as num)?.toDouble(),
        roomId: json['room_id'],
      );
}
