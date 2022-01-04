import 'dart:math';

import 'package:dormitory_manager/bloc/bill/event.dart';
import 'package:dormitory_manager/bloc/bill/state.dart';
import 'package:dormitory_manager/model/room.dart';
import 'package:dormitory_manager/model/room_bill.dart';
import 'package:dormitory_manager/provider/manager_provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BillBloc extends Bloc<BillEvent, BillState> {
  BillBloc() : super(null);
  List<RoomBill> listRoomBill = [];
  ManagerProvider _managerProvider = ManagerProvider();
  RoomBill bill;

  @override
  Stream<BillState> mapEventToState(BillEvent event) async* {
    if (event is GetAllBill) {
      yield Loading();
      var res = await _managerProvider.getAllBill(id: event.appBloc.manager.id);
      if ((res?.roomBill?.isNotEmpty ?? false) && res != null) {
        listRoomBill = res.roomBill;
        yield LoadDataBillDone();
      } else {
        yield LoadDataBillFail();
      }
    }

    if (event is CreateBill) {
      Map bill = {
        "total_price": event.appBloc.room.roomAmount + event.appBloc.totalPrice,
        "total_service": event.appBloc.totalPrice,
        "date_create": DateTime.now().millisecondsSinceEpoch ~/ 1000,
        "room_id": event.appBloc.room.id,
        "manager_id": event.appBloc.room.managerId,
        "status": "unpaid"
      };

      yield Loading();
      var res = await _managerProvider.createBill(data: bill);
      if (res != null && res['data'].isNotEmpty) {
        double price = event.appBloc.totalPrice;
        event.appBloc.totalPrice = 0.0;
        var billDetail = [];
        event.appBloc.listService.map((e) async {
          billDetail.add({
            "service_name": e.serviceName,
            "amount_used": (int.tryParse(e.endNumberTextEdit.text == ""
                    ? '0'
                    : e.endNumberTextEdit.text) -
                int.tryParse(e.startNumberTextEdit.text)),
            "total_price": e.totalService,
            "number_start": int.tryParse(e.startNumberTextEdit.text),
            "number_end": int.tryParse(e.endNumberTextEdit.text == ""
                ? '0'
                : e.endNumberTextEdit.text),
            "room_bill_id": res['data']['id']
          });
          await _managerProvider.updateService(
              data: {"number_start": int.tryParse(e.endNumberTextEdit.text)},
              id: e.id);
          e.startNumberTextEdit.clear();
          e.endNumberTextEdit.clear();
          e.totalService = 0.0;
          e.isCheck = false;
        }).toList();

        var resd = await _managerProvider.createBillDetail(data: billDetail);
        if (resd != null) {
          event.appBloc.room.dateCreateBill =
              DateTime.now().millisecondsSinceEpoch ~/ 1000;
          await _managerProvider.updateRoom(
              data: {"date_create_bill": event.appBloc.room.dateCreateBill},
              id: event.appBloc.room.id);

          // if(event.appBloc.index >=  event.appBloc.listAllDataRoom.length){
          //   event.appBloc.room = null;
          //
          // }else{
          //   event.appBloc.room = event.appBloc.listAllDataRoom[event.appBloc.index + 1];
          //   event.appBloc.listService = null;
          //
          // }
          listRoomBill.add(
            RoomBill(
              id: res['data']['id'],
              totalPrice: event.appBloc.room.roomAmount + price,
              totalService: price,
              dateCreate: DateTime.now().millisecondsSinceEpoch ~/ 1000,
              roomId: event.appBloc.room.id,
              status: "unpaid",
              room: Room(
                  roomName: event.appBloc.room.roomName,
                  roomAmount: event.appBloc.room.roomAmount),
            ),
          );
          event.appBloc.room = null;
          yield CreateBillDone();
        }
      } else {
        yield CreateBillFail();
      }
    }

    if (event is UpdateBill) {
      yield LoadingUpdateBillState();
      var data = await _managerProvider
          .updateBill(data: {"status": event.status}, id: event.id);
      if (data) {
        bill.status = event.status;
        yield UpdateBillState();
      }
    }

    if (event is UpdateUIEvent) {
      yield UpdateUIState();
    }
  }
}
