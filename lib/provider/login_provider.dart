import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dormitory_manager/contrains/api_url.dart';
import 'package:dormitory_manager/model/response/all_room.dart';
import 'package:dormitory_manager/model/response/login.dart';

class LoginProvider {
  Dio _dio = Dio();

  Future<dynamic> loginUser({dynamic datas}) async {
    try {
      var res = await _dio.post(
        "${ApiUrl.baseUrl + ApiUrl.loginUser}",
        data: datas,
        options: Options(
            receiveDataWhenStatusError: true,
            receiveTimeout: 50,
            sendTimeout: 50),
      );
      if (res.data['success']) {
        return res.data;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
  Future<dynamic> loginManager({dynamic datas}) async {
    try {
      var res = await _dio.post(
        "${ApiUrl.baseUrl + ApiUrl.loginManager}",
        data: datas,
        options: Options(
            receiveDataWhenStatusError: true,
            receiveTimeout: 50,
            sendTimeout: 50),
      );
      if (res.data['success']) {
        return res.data;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<dynamic> getAllRoom({int id}) async {
    try {
      var res = await _dio.get(
          "${ApiUrl.baseUrl + ApiUrl.getAppRoom}/${id}");
      if (res.data['success']) {
        return res.data;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
