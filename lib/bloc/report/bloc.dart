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
  List<Message> tempListMessage = [];
  Message message;
  int statusTab = 1;
  TextEditingController title = TextEditingController();
  TextEditingController content = TextEditingController();
  TextEditingController search = TextEditingController();

  @override
  Stream<ReportState> mapEventToState(ReportEvent event) async* {
    if (event is GetAllMessage) {
      yield LoadingReportState();
      var res;
      if (event.appBloc.isUser) {
        res = await _managerProvider.getAllMessage(
            id: event.appBloc.user.managerId);
      } else {
        res =
            await _managerProvider.getAllMessage(id: event.appBloc.manager.id);
      }

      if (res != null) {
        listMessage = res.mess;
        listMessage.forEach((element) {
          tempListMessage.add(element);
        });
      }
      yield LoadDoneReportState();
    }

    if (event is UpdateMessage) {
      yield LoadingReportState();
      var res = await _managerProvider
          .updateContract(id: event.id, data: {"status": event.status});
      if (res != null) {
        message.status = event.status;
        tempListMessage.forEach((element) {
          if (message.id == element.id) {
            element.status = event.status;
          }
        });
        if (statusTab == 1) {
          yield* mapEventToState(AllReportEvent());
        } else if (statusTab == 4) {
          yield* mapEventToState(SearchReportEvent());
        } else {
          if (event.status == "fixing") {
            yield* mapEventToState(FixedReportEvent());
          } else {
            yield* mapEventToState(FixingReportEvent());
          }
        }
        yield LoadDoneReportState();
      }
    }

    if (event is CreateMessage) {
      Map data = {
        "title": title.text,
        "content": content.text,
        "status": "fixing",
        "date_create": DateTime.now().millisecondsSinceEpoch ~/ 1000,
        "room_id": event.appBloc.room1.id,
        "manager_id": event.appBloc.user.managerId,
        "user_id": event.appBloc.user.id,
      };
      yield LoadingCreateState();
      var res = await _managerProvider.createReport(data: data);
      if (res != null) {
        listMessage.add(Message(
            title: title.text,
            content: content.text,
            status: "fixing",
            dateCreate: DateTime.now().millisecondsSinceEpoch ~/ 1000,
            room: Room(roomName: event.appBloc.room1.roomName),
            user: User(userName: event.appBloc.user.userName),
            userId: event.appBloc.user.id));

        tempListMessage.add(Message(
            title: title.text,
            content: content.text,
            status: "fixing",
            dateCreate: DateTime.now().millisecondsSinceEpoch ~/ 1000,
            room: Room(roomName: event.appBloc.room1.roomName),
            user: User(userName: event.appBloc.user.userName),
            userId: event.appBloc.user.id));
        title.text = "";
        content.text = "";
        yield CreateDoneState();
      }
    }

    if (event is FixingReportEvent) {
      statusTab = 2;
      listMessage.clear();
      tempListMessage.forEach((element) {
        if (element.status == "fixing") {
          listMessage.add(element);
        }
      });
      yield UpdateState();
    }

    if (event is FixedReportEvent) {
      statusTab = 3;
      listMessage.clear();
      tempListMessage.forEach((element) {
        if (element.status != "fixing") {
          listMessage.add(element);
        }
      });
      yield UpdateState();
    }

    if (event is AllReportEvent) {
      statusTab = 1;
      listMessage.clear();
      tempListMessage.forEach((element) {
        listMessage.add(element);
      });
      yield UpdateState();
    }

    if (event is SearchReportEvent) {
      statusTab = 4;
      listMessage.clear();
      tempListMessage.forEach((element) {
        if (element.room.roomName == search.text) {
          listMessage.add(element);
        }
      });
      yield UpdateState();
    }
//
//    if(event is UpdateUIReportEvent){
//      yield UpdateState();
//    }
  }
}
