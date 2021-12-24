import 'package:dormitory_manager/model/manager.dart';
import 'package:dormitory_manager/model/user.dart';

class LoginRespone {
  bool success;
  User userLogin;
  Manager managerLoging;

  LoginRespone({this.managerLoging,this.userLogin, this.success});

  factory LoginRespone.fromJsonLoginUser(Map<String, dynamic> json) => LoginRespone(
        success: json['success'],
        userLogin: User.fromJson(json['data'])
        // userLogin: (json['data'] is List)
        //     ? json['data'].map<User>((item) {
        //         return User.fromJson(item);
        //       }).toList()
        //     : [],
      );

  factory LoginRespone.fromJsonLoginManager(Map<String, dynamic> json) => LoginRespone(
      success: json['success'],
      managerLoging: Manager.fromJson(json['data'])
    // userLogin: (json['data'] is List)
    //     ? json['data'].map<User>((item) {
    //         return User.fromJson(item);
    //       }).toList()
    //     : [],
  );
}
