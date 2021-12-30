import 'package:dio/dio.dart';
import 'package:dormitory_manager/bloc/app_bloc/bloc.dart';
import 'package:dormitory_manager/contrains/api_url.dart';
import 'package:dormitory_manager/model/message.dart';
import 'package:dormitory_manager/model/response/all_bill.dart';
import 'package:dormitory_manager/model/response/all_room.dart';
import 'package:dormitory_manager/model/response/contract.dart';
import 'package:dormitory_manager/model/response/message.dart';
import 'package:dormitory_manager/model/user.dart';

class ManagerProvider {
  Dio dio = Dio();

  Future<dynamic> getAllRoom({int id}) async {
    try {
      var res = await dio.get("${ApiUrl.baseUrl + ApiUrl.getAppRoom}/${id}");
      if (res.data['success']) {
        return res.data;
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

  Future<MessageResponse> getAllMessage({int id}) async {
    try {
      var res = await dio.get("${ApiUrl.baseUrl + ApiUrl.getAllMessage}/${id}");
      if (res.data['success']) {
        return MessageResponse.fromJson(res.data);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<AllContractResponse> getAllContract({int id}) async {
    try {
      var res =
          await dio.get("${ApiUrl.baseUrl + ApiUrl.getAllContract}/${id}");
      if (res.data['success']) {
        return AllContractResponse.fromJson(res.data);
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

  Future<dynamic> updateService({dynamic data, int id}) async {
    try {
      var res = await dio.post("${ApiUrl.baseUrl + ApiUrl.updateService}/$id",
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

  Future<dynamic> updateRoom({dynamic data, int id}) async {
    try {
      var res = await dio.post("${ApiUrl.baseUrl + ApiUrl.updateRoom}/$id",
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

  Future<dynamic> updateBill({dynamic data, int id}) async {
    try {
      var res = await dio.post("${ApiUrl.baseUrl + ApiUrl.updateBill}/$id",
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

  Future<dynamic> updateContract({dynamic data, int id}) async {
    try {
      var res = await dio.post("${ApiUrl.baseUrl + ApiUrl.updateMessage}/$id",
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

  Future<dynamic> extendContract({dynamic data, int id}) async {
    try {
      var res = await dio.post("${ApiUrl.baseUrl + ApiUrl.extendContract}/$id",
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

  Future<dynamic> deleteContract({int id}) async {
    try {
      var res =
          await dio.delete("${ApiUrl.baseUrl + ApiUrl.deleteContract}/$id");
      if (res.data['success']) {
        return true;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<dynamic> deleteMessage({int id}) async {
    try {
      var res =
          await dio.delete("${ApiUrl.baseUrl + ApiUrl.deleteMessage}/$id");
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
