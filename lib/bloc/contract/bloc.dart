import 'package:dormitory_manager/bloc/contract/state.dart';
import 'package:dormitory_manager/model/room.dart';
import 'package:dormitory_manager/model/user.dart';
import 'package:dormitory_manager/provider/manager_provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'event.dart';

class ContractBloc extends Bloc<ContractEvent, ContractState> {
  ContractBloc() : super(null);
  ManagerProvider _managerProvider = ManagerProvider();
  List<User> listContract = [];
  User user;
  User user1 = User();
  Room room;


  @override
  Stream<ContractState> mapEventToState(ContractEvent event) async* {
    if (event is GetAllContractEvent) {
      yield Loading();
      var res;
      if(event.appBloc.isUser){
       res = await _managerProvider.getAllContract(id: event.appBloc.user.managerId);

      }else{
       res= await _managerProvider.getAllContract(id: event.appBloc.manager.id);
      }
      if (res != null) {
        listContract = res.user;
        yield GetDone();
      }
    }

    if (event is ExtendContractEvent) {
      yield Loading();
      var res = await _managerProvider.extendContract(
          id: event.id, data: {"expiration_date": event.dateTime});
      if (res != null) {
        user.expirationDate = event.dateTime;
        yield GetDone();
      }
    }

    if (event is UpdateUIContractEvent) {
     yield UpdateUIState();
      }


    if (event is DeleteContractEvent) {
      yield Loading();
      var resM = await _managerProvider.deleteMessage(id: user.id);
      if (resM != null) {
        var resU = await _managerProvider.deleteContract(id: user.id);
        if (resU != null) {
          listContract.removeAt(event.index);
          yield GetDone();
        } else {
          yield DeleteErrors();
        }
      } else {
        yield DeleteErrors();
      }
    }

    if(event is CreateContractEvent){
      yield LoadingCreateContractState();
      var res = await _managerProvider.createUser();
      if(res != null){
        yield CreateContractDoneState();
      }
    }
  }
}
