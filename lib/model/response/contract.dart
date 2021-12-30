import 'package:dormitory_manager/model/room_bill.dart';
import 'package:dormitory_manager/model/user.dart';

class AllContractResponse {
  bool status;
  List<User> user;
  AllContractResponse({this.status,this.user});

  factory AllContractResponse.fromJson(Map<String, dynamic> json) =>
      AllContractResponse(
          status: json['status'],
          user: (json['data'] is List)
              ? json['data'].map<User>((item) {
            return User.fromJson(item);
          }).toList()
              : []);
}
