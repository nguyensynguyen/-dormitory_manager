import 'package:dormitory_manager/bloc/report/state.dart';
import 'package:dormitory_manager/model/message.dart';
import 'package:dormitory_manager/provider/manager_provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'event.dart';

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  ReportBloc() : super(null);
  ManagerProvider _managerProvider = ManagerProvider();
  List<Message> listMessage = [];
  Message message;

  @override
  Stream<ReportState> mapEventToState(ReportEvent event) async* {
    if (event is GetAllMessage) {
      yield LoadingReportState();
      var res =
          await _managerProvider.getAllMessage(id: event.appBloc.manager.id);
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
  }
}
