import 'dart:math';

import 'package:dormitory_manager/bloc/all_room/state.dart';
import 'package:dormitory_manager/model/room.dart';
import 'package:dormitory_manager/model/room_eqiupment.dart';
import 'package:dormitory_manager/model/service.dart';
import 'package:dormitory_manager/provider/manager_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'event.dart';

class AllRoomBloc extends Bloc<RoomEvent, RoomState> {
  AllRoomBloc() : super(null);
  ManagerProvider _managerProvider = ManagerProvider();
  List<Room> listRoom = [];
  List<Room> tempListRoom = [];
  List<Service> listService = [];
  List<RoomEquipment> listEquipment = [];
  TextEditingController textRoomName = TextEditingController();
  TextEditingController textPrice = TextEditingController();
  TextEditingController textMaxP = TextEditingController();
  TextEditingController textWater = TextEditingController();
  TextEditingController textElectron = TextEditingController();
  TextEditingController textUnitWater = TextEditingController();
  TextEditingController textUnitElectron = TextEditingController();
  TextEditingController textInternet = TextEditingController();
  TextEditingController textVs = TextEditingController();
  TextEditingController textGx = TextEditingController();
  TextEditingController textEquipment = TextEditingController();

  List<bool> checkDv = [false, false, false];
  int roomId;
  Room room;
  String status = 'Hoạt động';

  @override
  Stream<RoomState> mapEventToState(RoomEvent event) async* {
    if (event is GetDataRoomEvent) {
      yield LoadingState();
      var data;
      if(event.appBloc.isUser){
        data = await _managerProvider.getAllRoom(id: event.appBloc.user.managerId);

      }else{
        data = await _managerProvider.getAllRoom(id: event.appBloc.manager.id);
      }
      if (data != null) {
        listRoom = data['data'].map<Room>((item) {
          return Room.fromJson(item);
        }).toList();
        listRoom.forEach((element) {
          tempListRoom.add(element);
        });
        event.appBloc.listAllDataRoom = data['data'].map<Room>((item) {
          return Room.fromJson(item);
        }).toList();
        event.appBloc.listAllDataRoomDisplay = data['data'].map<Room>((item) {
          return Room.fromJson(item);
        }).toList();
        if(event.appBloc.isUser){
          event.appBloc.listAllDataRoom.forEach((element) {
            if(event.appBloc.user.roomId == element.id){
              event.appBloc.room1 = Room(id: element.id,roomName: element.roomName);
            }
          });
        }

        yield GetAllDataRoomState();
      }
    }

    if (event is CreateRoomEvent) {
      DateTime date_create_bill = DateTime.now().subtract(Duration(days: 30));
      yield LoadingCreateRoomState();
      Map data = {
        "room_name": textRoomName.text,
        "room_amount": double.tryParse(textPrice.text),
        "max_people": int.tryParse(textMaxP.text),
        "total_current_people":0,
        "manager_id": event.appBloc.manager.id,
        "date_create_bill": date_create_bill.millisecondsSinceEpoch ~/ 1000
      };
      var res = await _managerProvider.createRoom(data: data);
      if (res != null) {
        roomId = res['data']['id'];
        listRoom.add(Room(
          id: res['data']['id'],
          roomName: res['data']['room_name'],
          dateCreateBill: res['data']['date_create_bill'],
          maxPeople: res['data']['max_people'],
          totalCurrentPeople:0,
          roomAmount: data['room_amount'],
        ));

        tempListRoom.add(Room(
          id: res['data']['id'],
          roomName: res['data']['room_name'],
          dateCreateBill: res['data']['date_create_bill'],
          maxPeople: res['data']['max_people'],
          totalCurrentPeople:0,
          roomAmount: data['room_amount'],
        ));
        room = Room(
            id: res['data']['id'],
            roomName: res['data']['room_name'],
            dateCreateBill: res['data']['date_create_bill'],
            maxPeople: res['data']['max_people'],
            totalCurrentPeople: res['data']['total_current_people'],
            roomAmount: data['room_amount'],
            managerId: event.appBloc.manager.id);
        yield CreateRoomDone();
      }
    }

    if (event is CreateServiceEvent) {
      yield LoadingCreateServiceState();
      var data = [];
      listService.map((e) {
        data.add({
          "service_name": e.serviceName,
          "unit_price": e.unitPrice,
          "number_start": e.numberStart,
          "unit": e.unit,
          "room_id": room.id
        });
      }).toList();
      var res = await _managerProvider.createService(data: data);
      if (res != null) {

        event.appBloc.listAllDataRoom.add(Room(
            id: room.id,
            roomName: room.roomName,
            dateCreateBill: room.dateCreateBill,
            maxPeople: room.maxPeople,
            totalCurrentPeople: 0,
            roomAmount: room.roomAmount,
            service: listService,
            roomEquipment: [],
            user: [],
            managerId: event.appBloc.manager.id));

        event.appBloc.listAllDataRoomDisplay.add(Room(
            id: room.id,
            roomName: room.roomName,
            dateCreateBill: room.dateCreateBill,
            maxPeople: room.maxPeople,
            totalCurrentPeople: 0,
            roomAmount: room.roomAmount,
            service: listService,
            roomEquipment: [],
            user: [],
            managerId: event.appBloc.manager.id));

        reset();
        yield CreateServiceDone();
      }
    }

    if(event is CreateEquipmentEvent){

      yield LoadingCreateEquipmentState();
      Map data = {
        "room_equipment_name":textEquipment.text,
        "room_id":room.id,
        "status":status
      };
      var res = await _managerProvider.createEquipment(data: data);
      if(res != null){
        room.roomEquipment.add(RoomEquipment(
          roomEquipmentName: textEquipment.text,
          roomId: room.id,
          status: status
        ));
        room = null;
        textEquipment.text = "";
        yield CreateEquipmentDoneState();
      }
    }

    if (event is UpdateUIRoomEvent) {
      yield UpdateUIRoomState();
    }

    if(event is RoomLiveEvent){
      event.appBloc.listAllDataRoomDisplay.clear();
      tempListRoom.forEach((room) {
        if(room.user == null){
          room.user =[];
        }
        if(room.user.length >0 && room.user.length < room.maxPeople){
          event.appBloc.listAllDataRoomDisplay.add(room);
        }
      });
      yield UpdateUIRoomState();
    }

    if(event is RoomFullEvent){

      event.appBloc.listAllDataRoomDisplay.clear();
      tempListRoom.forEach((room) {
        if(room.user == null){
          room.user =[];
        }
        if(room.user.length >0 && room.user.length >= room.maxPeople){
          event.appBloc.listAllDataRoomDisplay.add(room);
        }
      });
      yield UpdateUIRoomState();
    }

    if(event is RoomEmptyEvent){

      event.appBloc.listAllDataRoomDisplay.clear();
      tempListRoom.forEach((room) {
        if(room.user == null){
          room.user =[];
        }
        if(room.user.length <=0 ){
          event.appBloc.listAllDataRoomDisplay.add(room);
        }
      });
      yield UpdateUIRoomState();
    }
    if(event is RoomAllEvent){
      event.appBloc.listAllDataRoomDisplay.clear();
      tempListRoom.forEach((room) {
          event.appBloc.listAllDataRoomDisplay.add(room);
      });
      yield UpdateUIRoomState();
    }
    if(event is UpdateRoomEquipmentEvent){
      yield UpdateServicesState();
      var data = await _managerProvider.updateEquipment(id:event.appBloc.equipment.id ,data:{"status":status});
      if(data != null){
        event.appBloc.equipment.status = status;
        yield UpdateServicesDoneState();
      }
    }
  }

  reset() {
    listService = [];
    textRoomName.text = "";
    textPrice.text = "";
    textMaxP.text = "";
    textWater.text = "";
    textElectron.text = "";
    textUnitWater.text = "";
    textUnitElectron.text = "";
    textInternet.text = "";
    textVs.text = "";
    textGx.text = "";
    checkDv = [false, false, false];
    room = null;
  }
}
