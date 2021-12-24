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
      Map bill ={
        "total_price":200000,
        "total_service":200000,
        "date_create":3325425154,
        "room_id": 1,
        "manager_id":1,
        "status":"paid"
      };

      yield Loading();
      var res = await _managerProvider.createBill(data: bill);
      if (res != null && res['data'].isNotEmpty) {
    var billDetail = [{
    "service_name":"điệnss",
    "amount_used":3,
    "total_price":198000,
    "room_bill_id":res['data']['id']

    },{
    "service_name":"điệnss",
    "amount_used":800,
    "total_price":105800,
    "room_bill_id":res['data']['id']
    }];
       var resd =  await _managerProvider.createBillDetail(data: billDetail);
       if(resd != null){
         yield CreateBillDone();
       }
      } else {
        yield CreateBillFail();
      }
    }
  }
}
