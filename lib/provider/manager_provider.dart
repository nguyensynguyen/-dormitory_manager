import 'package:dio/dio.dart';
import 'package:dormitory_manager/bloc/app_bloc/bloc.dart';
import 'package:dormitory_manager/contrains/api_url.dart';
import 'package:dormitory_manager/model/response/all_bill.dart';
import 'package:dormitory_manager/model/response/all_room.dart';

class ManagerProvider {
  Dio dio = Dio();

  Future<AllRoom> getAllRoom({int id}) async {
    try {
      var res = await dio.get("${ApiUrl.baseUrl + ApiUrl.getAppRoom}/${id}");
      if (res.data['success']) {
        return AllRoom.fromJson(res.data);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<AllBillResponse> getAllBill({int id}) async {
    try {
      var res = await dio.get("${ApiUrl.baseUrl + ApiUrl.getAppBill}/${id}");
      if (res.data['success']) {
        return AllBillResponse.fromJson(res.data);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<dynamic> createBill({dynamic data}) async {
    try {
      var res =
          await dio.post("${ApiUrl.baseUrl + ApiUrl.createBill}", data: data);
      if (res.data['success']) {
        return res.data;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<dynamic> createBillDetail({dynamic data}) async {
    try {
      var res = await dio.post("${ApiUrl.baseUrl + ApiUrl.createBillDetail}",
          data: data);
      if (res.data['success']) {
        return true;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
