import 'dart:convert';
import 'dart:io';

import 'package:dormitory_manager/bloc/app_bloc/state.dart';
import 'package:dormitory_manager/model/manager.dart';
import 'package:dormitory_manager/model/response/all_room.dart';
import 'package:dormitory_manager/model/room.dart';
import 'package:dormitory_manager/model/room_bill.dart';
import 'package:dormitory_manager/model/room_bill_detail.dart';
import 'package:dormitory_manager/model/service.dart';
import 'package:dormitory_manager/model/user.dart';
import 'package:dormitory_manager/provider/login_provider.dart';
import 'package:dormitory_manager/provider/manager_provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'event.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc() : super(null);

  AppState get initialState => Initial();
  User user;
  Manager manager;
  bool isUser = false;
  dynamic profile;
  int managerId;
  List<Room> listAllDataRoom;
  Room room;
  RoomBill roomBill;
  List<RoomBillDetail> roomBillDetail = [];
  List<Service> listService;
  double totalPrice = 0.0;

  @override
  Stream<AppState> mapEventToState(AppEvent event) async* {}
}
