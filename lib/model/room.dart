import 'package:dormitory_manager/model/room_bill.dart';
import 'package:dormitory_manager/model/room_eqiupment.dart';
import 'package:dormitory_manager/model/service.dart';
import 'package:dormitory_manager/model/user.dart';
import 'package:flutter/cupertino.dart';

class Room {
  int id;
  String roomName;
  int maxPeople;
  int totalCurrentPeople;
  int managerId;
  double roomAmount;
  List<User> user;
  List<RoomEquipment> roomEquipment;
  List<Service> service;

  Room(
      {this.id,
      this.roomName,
      this.managerId,
      this.maxPeople,
      this.roomAmount,
      this.totalCurrentPeople,
      this.roomEquipment,
      this.service,
      this.user});

  factory Room.fromJson(Map<String, dynamic> json) => Room(
        id: json['id'],
        roomName: json['room_name'],
        maxPeople: json['max_people'],
        totalCurrentPeople: json['total_current_people'],
        managerId: json['manager_id'],
        roomAmount:( json['room_amount'] as num)?. toDouble(),
        user: (json['Users'] is List)
            ? json['Users'].map<User>((item) {
                return User.fromJson(item);
              }).toList()
            : [],
        roomEquipment: (json['room_equipments'] is List)
            ? json['room_equipments'].map<RoomEquipment>((item) {
                return RoomEquipment.fromJson(item);
              }).toList()
            : [],
        service: (json['services'] is List)
            ? json['services'].map<Service>((item) {
                return Service.fromJson(item);
              }).toList()
            : [],
      );
}
