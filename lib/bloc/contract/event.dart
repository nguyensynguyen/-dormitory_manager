import 'package:dormitory_manager/bloc/app_bloc/bloc.dart';

class ContractEvent {}

class GetAllContractEvent extends ContractEvent {
  AppBloc appBloc;

  GetAllContractEvent({this.appBloc});
}

class UpdateContractEvent extends ContractEvent {
  int id;
}

class ExtendContractEvent extends ContractEvent {
  int id;
  int dateTime;

  ExtendContractEvent({this.dateTime, this.id});
}

class DeleteContractEvent extends ContractEvent {
  int index;

  DeleteContractEvent({this.index});
}

class UpdateUIContractEvent extends ContractEvent {}

class CreateContractEvent extends ContractEvent {
  AppBloc appBloc;
  CreateContractEvent({this.appBloc});
}
class ExpiredEvent extends ContractEvent {}
class DueEvent extends ContractEvent {}
class AllContractEvent extends ContractEvent {}
class SearchContractEvent extends ContractEvent {}

