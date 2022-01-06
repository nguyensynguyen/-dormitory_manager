import 'package:dormitory_manager/bloc/report/state.dart';
import 'package:dormitory_manager/model/message.dart';
import 'package:dormitory_manager/model/room.dart';
import 'package:dormitory_manager/model/user.dart';
import 'package:dormitory_manager/provider/manager_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'event.dart';

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  ReportBloc() : super(null);
  ManagerProvider _managerProvider = ManagerProvider();
  List<Message> listMessage = [];
  Message message;
  TextEditingController title = TextEditingController();
  TextEditingController content = TextEditingController();
  @override
  Stream<ReportState> mapEventToState(ReportEvent event) async* {
    if (event is GetAllMessage) {
      yield LoadingReportState();
      var res;
      if(event.appBloc.isUser){
        res =  await _managerProvider.getAllMessage(id: event.appBloc.user.managerId);
      }else{
        res =  await _managerProvider.getAllMessage(id: event.appBloc.manager.id);

      }

      if (res != null) {
        listMessage = res.mess;
      }
      yield LoadDoneReportState();
    }

    if (event is UpdateMessage) {
      yield LoadingReportState();
      var res = await _managerProvider
          .updateContract(id: event.id, data: {"status": event.status});
      if (res != null) {
        message.status = event.status;
        yield LoadDoneReportState();
      }
    }

    if(event is CreateMessage){
      Map data = {
        "title":title.text,
        "content":content.text,
        "status":"fixing",
        "date_create":DateTime.now().millisecondsSinceEpoch ~/ 1000,
        "room_id":event.appBloc.room.id,
        "manager_id":event.appBloc.user.managerId,
        "user_id":event.appBloc.user.id,
      };
      yield LoadingCreateState();
      var res = await _managerProvider.createReport(data: data);
      if(res != null){
        listMessage.add(Message(
          title: title.text,
          content: content.text,
          status: "fixing",
          dateCreate: DateTime.now().millisecondsSinceEpoch ~/ 1000,
          room: Room(roomName: event.appBloc.room.roomName),
          user: User(userName: event.appBloc.user.userName),
          userId: event.appBloc.user.id
        ));
        title.text = "";
        content.text = "";
        yield CreateDoneState();
      }

    }
//
//    if(event is UpdateUIReportEvent){
//      yield UpdateState();
//    }
  }
}
