import 'dart:convert';
import 'dart:io';

import 'package:dormitory_manager/bloc/app_bloc/state.dart';
import 'package:dormitory_manager/model/manager.dart';
import 'package:dormitory_manager/model/response/all_room.dart';
import 'package:dormitory_manager/model/room.dart';
import 'package:dormitory_manager/model/room_bill.dart';
import 'package:dormitory_manager/model/room_bill_detail.dart';
import 'package:dormitory_manager/model/room_eqiupment.dart';
import 'package:dormitory_manager/model/service.dart';
import 'package:dormitory_manager/model/user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'event.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc() : super(null);

  AppState get initialState => Initial();
  User user;
  Manager manager;
  Manager displayManager;
  bool isUser = false;
  dynamic profile;
  List<Room> listAllDataRoom;
  List<Room> listAllDataRoomDisplay;
  RoomEquipment equipment;
  Room roomContract;
  Room roomDisplay;
  Room room;
  Room room1;
  RoomBill roomBill;
  Manager displayManagerForUsre;
  List<RoomBillDetail> roomBillDetail = [];
  List<Service> listService;
  double totalPrice = 0.0;
  int index = 0;
  String roomName = "";
  int roomId;

  @override
  Stream<AppState> mapEventToState(AppEvent event) async* {}
}
