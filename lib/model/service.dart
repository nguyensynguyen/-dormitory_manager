import 'package:flutter/cupertino.dart';

class Service {
  int id;
  String serviceName;
  double unitPrice;
  int numberStart;
  int roomId;
  String unit;
  TextEditingController startNumberTextEdit;
  TextEditingController endNumberTextEdit;
  double totalService;
  bool isCheck;

  Service(
      {this.roomId,
      this.id,
      this.serviceName,
      this.unitPrice,
      this.numberStart,
      this.unit,
      this.endNumberTextEdit,
      this.totalService,
        this.isCheck,
      this.startNumberTextEdit});

  factory Service.fromJson(Map<String, dynamic> json) => Service(
      id: json['id'],
      serviceName: json['service_name'],
      unitPrice: (json['unit_price'] as num)?.toDouble(),
      roomId: json['room_id'],
      numberStart: json['number_start'],
      unit: json['unit'],
      totalService: 0.0,
      isCheck: false,
      startNumberTextEdit: TextEditingController(),
      endNumberTextEdit: TextEditingController(),
    );
}
