import 'package:dormitory_manager/bloc/app_bloc/bloc.dart';

class ReportEvent{}
class GetAllMessage extends ReportEvent{
  AppBloc appBloc;
  GetAllMessage({this.appBloc});
}

class UpdateMessage extends ReportEvent{
  int id;
  String status;
  UpdateMessage({this.id,this.status});
}

class CreateMessage extends ReportEvent{
  AppBloc appBloc;
  CreateMessage({this.appBloc});
}

class UpdateUIReportEvent extends ReportEvent{

}