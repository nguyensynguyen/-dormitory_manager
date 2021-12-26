import 'dart:math';

import 'package:dormitory_manager/bloc/bill/event.dart';
import 'package:dormitory_manager/bloc/bill/state.dart';
import 'package:dormitory_manager/model/room_bill.dart';
import 'package:dormitory_manager/provider/manager_provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BillBloc extends Bloc<BillEvent, BillState> {
  BillBloc() : super(null);
  List<RoomBill> listRoomBill = [];
  ManagerProvider _managerProvider = ManagerProvider();

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
      print(event.appBloc.listService[1].endNumberTextEdit.text);
      print(event.appBloc.room.id);
      Map bill = {
        "total_price": event.appBloc.room.roomAmount + event.appBloc.totalPrice,
        "total_service": event.appBloc.totalPrice,
        "date_create": 3325425154,
        "room_id": event.appBloc.room.id,
        "manager_id": event.appBloc.room.managerId,
        "status": "unpaid"
      };

      yield Loading();
      var res = await _managerProvider.createBill(data: bill);
      if (res != null && res['data'].isNotEmpty) {
        event.appBloc.totalPrice = 0.0;
        var billDetail = [];
        event.appBloc.listService.map((e) {
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

          e.startNumberTextEdit.clear();
          e.endNumberTextEdit.clear();
          e.totalService = 0.0;
          e.isCheck = false;
        }).toList();

        var resd = await _managerProvider.createBillDetail(data: billDetail);
        if (resd != null) {

          yield CreateBillDone();
        }
      } else {
        yield CreateBillFail();
      }
    }

    if (event is UpdateUIEvent) {
      yield UpdateUIState();
    }
  }
}
