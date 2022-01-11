import 'dart:math';

import 'package:dormitory_manager/bloc/bill/event.dart';
import 'package:dormitory_manager/bloc/bill/state.dart';
import 'package:dormitory_manager/model/room.dart';
import 'package:dormitory_manager/model/room_bill.dart';
import 'package:dormitory_manager/model/room_bill_detail.dart';
import 'package:dormitory_manager/provider/manager_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BillBloc extends Bloc<BillEvent, BillState> {
  BillBloc() : super(null);
  List<RoomBill> listRoomBill = [];
  ManagerProvider _managerProvider = ManagerProvider();
  RoomBill bill;
  double totalPrice = 0;
  List<RoomBill> tempListBill = [];
  List<RoomBill> tempAllBill = [];
  int statusPaid = 1;
  DateTime time = DateTime.now();
  TextEditingController searchBill = TextEditingController();

  @override
  Stream<BillState> mapEventToState(BillEvent event) async* {
    if (event is GetAllBill) {
      yield Loadings();
      var res;
      if (event.appBloc.isUser) {
        res =
            await _managerProvider.getAllBill(id: event.appBloc.user.managerId);
      } else {
        res = await _managerProvider.getAllBill(id: event.appBloc.manager.id);
      }
      if ((res?.roomBill?.isNotEmpty ?? false) && res != null) {
        listRoomBill = res.roomBill;
        for (int k = 0; k < listRoomBill.length; k++) {
          tempListBill.add(listRoomBill[k]);
          tempAllBill.add(listRoomBill[k]);
        }
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
        totalPrice += event.appBloc.room.roomAmount + event.appBloc.totalPrice;
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
              roomBillDetail:billDetail.map<RoomBillDetail>((item) {
                return RoomBillDetail.fromJson(item);
              }).toList(),
              room: Room(
                  roomName: event.appBloc.room.roomName,
                  roomAmount: event.appBloc.room.roomAmount),
            ),
          );
          tempListBill.add(
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
          tempAllBill.add(
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
        tempListBill.forEach((element) {
          if (element.id == event.id) {
            element.status = event.status;
          }
        });
        tempAllBill.forEach((element) {
          if (element.id == event.id) {
            element.status = event.status;
          }
        });
        if (statusPaid == 1) {
          yield* mapEventToState(AllPaidEvent());
        } else {
          if (event.status == "paid") {
            yield* mapEventToState(UnpaidEvent());
          } else {
            yield* mapEventToState(PaidEvent());
          }
        }

        yield UpdateBillState();
      }
    }

    if (event is UpdateUIEvent) {
      yield UpdateUIState();
    }

    if (event is TotalPriceEvent) {
      totalPrice = 0;
      for (int i = 0; i < listRoomBill.length; i++) {
        totalPrice += listRoomBill[i].totalPrice;
      }
      yield TotalPriceState();
    }

    if (event is PaidEvent) {
      statusPaid = 2;
      yield Loadings();
      listRoomBill.clear();
      for (int i = 0; i < tempListBill.length; i++) {
        if (tempListBill[i].status == "paid") {
          listRoomBill.add(tempListBill[i]);
        }
      }
      yield* mapEventToState(TotalPriceEvent());
      yield LoadDataBillDone();
    }

    if (event is UnpaidEvent) {
      statusPaid = 3;
      yield Loadings();
      listRoomBill.clear();
      for (int i = 0; i < tempListBill.length; i++) {
        if (tempListBill[i].status != "paid") {
          listRoomBill.add(tempListBill[i]);
        }
      }
      yield* mapEventToState(TotalPriceEvent());
      yield LoadDataBillDone();
    }

    if (event is AllPaidEvent) {
      statusPaid = 1;
      yield Loadings();
      listRoomBill.clear();
      for (int i = 0; i < tempListBill.length; i++) {
        listRoomBill.add(tempListBill[i]);
      }
      yield* mapEventToState(TotalPriceEvent());
      yield LoadDataBillDone();
    }

    if (event is FilterDateEvent) {
      statusPaid = 1;
      yield Loadings();
      listRoomBill.clear();
      tempListBill.clear();
      for (int i = 0; i < tempAllBill.length; i++) {
        if (DateTime.fromMillisecondsSinceEpoch(
                    tempAllBill[i].dateCreate * 1000)
                .year ==
            time.year) {
          if (DateTime.fromMillisecondsSinceEpoch(
                      tempAllBill[i].dateCreate * 1000)
                  .month ==
              time.month) {
            listRoomBill.add(tempAllBill[i]);
            tempListBill.add(tempAllBill[i]);
          }
        }
      }
      yield* mapEventToState(TotalPriceEvent());
      yield LoadDataBillDone();
    }
    if(event is SearchDateEvent){
      listRoomBill.clear();
      tempListBill.forEach((element) {
        if(element.room.roomName == searchBill.text){
          listRoomBill.add(element);
        }
      });
      yield SearchDoneState();
    }
  }

}
