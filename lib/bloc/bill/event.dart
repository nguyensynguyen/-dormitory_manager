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
class UpdateBill extends BillEvent{
  int id;
  String status;
  UpdateBill({this.status,this.id});
}
class UpdateUIEvent extends BillEvent{}
class TotalPriceEvent extends BillEvent{
  AppBloc appBloc;
  TotalPriceEvent({this.appBloc});
}

class UnpaidEvent extends BillEvent{

}

class PaidEvent extends BillEvent{

}

class AllPaidEvent extends BillEvent{

}
class FilterDateEvent extends BillEvent{

}

class SearchDateEvent extends BillEvent{

}

