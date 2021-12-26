import 'package:dormitory_manager/bloc/app_bloc/bloc.dart';

class BillEvent{}
class GetAllBill extends BillEvent{
  AppBloc appBloc;
  GetAllBill({this.appBloc});
}

class CreateBill extends BillEvent{
  AppBloc appBloc;
  CreateBill({this.appBloc});
}
class CreateBillDetail extends BillEvent{
  AppBloc appBloc;
  CreateBillDetail({this.appBloc});
}
class UpdateUIEvent extends BillEvent{}