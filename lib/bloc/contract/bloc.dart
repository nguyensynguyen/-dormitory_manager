import 'package:dormitory_manager/bloc/contract/state.dart';
import 'package:dormitory_manager/model/room.dart';
import 'package:dormitory_manager/model/user.dart';
import 'package:dormitory_manager/provider/login_provider.dart';
import 'package:dormitory_manager/provider/manager_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_mailer/flutter_mailer.dart';

import 'event.dart';

class ContractBloc extends Bloc<ContractEvent, ContractState> {
  ContractBloc() : super(null);
  ManagerProvider _managerProvider = ManagerProvider();
  List<User> listContract = [];
  User user;
  User user1 = User();
  Room room;
  DateTime time;
  TextEditingController name = TextEditingController();
  TextEditingController mail = TextEditingController();
  TextEditingController idCard = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController search = TextEditingController();
  TextEditingController oldPass = TextEditingController();
  TextEditingController newPass = TextEditingController();
  String messageErrors = "";
  List<User> tempContract = [];
  List<User> tempAllContract = [];
  int statusTab = 1;
  LoginProvider loginProvider = LoginProvider();

  @override
  Stream<ContractState> mapEventToState(ContractEvent event) async* {
    if (event is GetAllContractEvent) {
      yield Loading();
      var res;
      if (event.appBloc.isUser) {
        res = await _managerProvider.getAllContract(
            id: event.appBloc.user.managerId);
      } else {
        res =
            await _managerProvider.getAllContract(id: event.appBloc.manager.id);
      }
      if (res != null) {

        listContract = res.user;
        listContract.forEach((element) {
          tempAllContract.add(element);
          tempContract.add(element);
        });
        if (event.appBloc.listAllDataRoom != null) {
          event.appBloc.listAllDataRoom.forEach((room) {
            listContract.forEach((user) {
              if (user.roomId == room.id) {
                user.room = {"room_name": room.roomName};
              }
            });
          });
        } else {
          listContract.forEach((user) {
            event.appBloc.listAllDataRoom = [];
//            if (user.roomId == room.id) {
//              user.room = {"room_name": ""};
//            }
          });
        }

        yield GetDone();
      }
    }

    if (event is ExtendContractEvent) {
      yield Loading();
      var res = await _managerProvider.extendContract(
          id: event.id, data: {"expiration_date": event.dateTime});
      if (res != null) {
        user.expirationDate = event.dateTime;
        tempContract.forEach((element) {
          if (element.id == event.id) {
            element.expirationDate = event.dateTime;
          }
        });

        if (statusTab == 1) {
          yield* mapEventToState(AllContractEvent());
        } else if (statusTab == 4) {
          yield* mapEventToState(SearchContractEvent());
        } else {
          yield* mapEventToState(DueEvent());
        }
        yield GetDone();
      }
    }

    if (event is UpdateUIContractEvent) {
      yield UpdateUIState();
    }

    if (event is DeleteContractEvent) {
      yield Loading();
      var resM = await _managerProvider.deleteMessage(id: user.id);
      if (resM != null) {
        var resU = await _managerProvider.deleteContract(id: user.id);
        if (resU != null) {
          listContract.removeAt(event.index);
          yield GetDone();
        } else {
          yield DeleteErrors();
        }
      } else {
        yield DeleteErrors();
      }
    }

    if (event is CreateContractEvent) {
      yield LoadingCreateContractState();
      for (int i = 0; i < listContract.length; i++) {
        if (listContract[i].email == mail.text ?? "") {
          messageErrors = "Email đã được đăng ký trước đó";
          yield CreateContractErrorsState();
          return;
        } else if (listContract[i].phone == int.tryParse(phone.text)) {
          messageErrors = "Số điện thoại đã được đăng ký trước đó";
          yield CreateContractErrorsState();
          return;
        }
      }
      if (name.text == "") {
        messageErrors = "Nhập tên";
        yield CreateContractErrorsState();
        return;
      }
      if (mail.text == "") {
        messageErrors = "Nhập email";
        yield CreateContractErrorsState();
        return;
      }
      if (idCard.text == null) {
        messageErrors = "Nhập số căn cước";
        yield CreateContractErrorsState();
        return;
      }
      if (address.text == "") {
        messageErrors = "Nhập địa chỉ";
        yield CreateContractErrorsState();
        return;
      }
      if (phone.text == "") {
        messageErrors = "Nhập số điện thoại";
        yield CreateContractErrorsState();
        return;
      }
      if (room == null) {
        messageErrors = "Chọn phòng";
        yield CreateContractErrorsState();
        return;
      }
      if (user1.birthDay == null) {
        messageErrors = "Nhập ngày sinh";
        yield CreateContractErrorsState();
        return;
      }
      if (user1.registrationDate == null) {
        messageErrors = "Nhập ngày đến";
        yield CreateContractErrorsState();
        return;
      }
      if (user1.expirationDate == null) {
        messageErrors = "Nhập ngày hết hạn";
        yield CreateContractErrorsState();
        return;
      }

      if (user1.registrationDate > user1.expirationDate) {
        messageErrors = "Ngày hết hạn phải lớn hơn ngày đến";
        yield CreateContractErrorsState();
        return;
      }

      Map data = {
        "user_name": name.text,
        "email": mail.text,
        "address": address.text,
        "phone": int.tryParse(phone.text),
        "password": "1",
        "birth_day": user1.birthDay,
        "expiration_date": user1.expirationDate,
        "registration_date": user1.registrationDate,
        "manager_id": event.appBloc.manager.id,
        "room_id": room.id,
        "id_card": int.tryParse(idCard.text)
      };

      var res = await _managerProvider.createUser(data: data);
      if (res != null) {
        event.appBloc.roomContract.user.add(User(
            id: res['data']['id'],
            userName: name.text,
            email: mail.text,
            address: address.text,
            phone: int.tryParse(phone.text),
            birthDay: user1.birthDay,
            registrationDate: user1.registrationDate,
            password: "1",
            managerId: event.appBloc.manager.id,
            expirationDate: user1.expirationDate,
            room: {"room_name": room.roomName},
            roomId: room.id));
        if (event.appBloc.roomDisplay.user.length <
            event.appBloc.roomDisplay.maxPeople) {
          // yield* mapEventToState()
        }
        event.appBloc.roomDisplay.user.add(User(
            id: res['data']['id'],
            userName: name.text,
            email: mail.text,
            address: address.text,
            phone: int.tryParse(phone.text),
            birthDay: user1.birthDay,
            registrationDate: user1.registrationDate,
            password: "1",
            managerId: event.appBloc.manager.id,
            idCard: int.tryParse(idCard.text),
            expirationDate: user1.expirationDate,
            room: {"room_name": room.roomName},
            roomId: room.id));

        listContract.add(User(
            id: res['data']['id'],
            userName: name.text,
            email: mail.text,
            address: address.text,
            phone: int.tryParse(phone.text),
            birthDay: user1.birthDay,
            registrationDate: user1.registrationDate,
            password: "1",
            idCard: int.tryParse(idCard.text),
            managerId: event.appBloc.manager.id,
            expirationDate: user1.expirationDate,
            room: {"room_name": room.roomName},
            roomId: room.id));

        tempContract.add(User(
            id: res['data']['id'],
            userName: name.text,
            email: mail.text,
            address: address.text,
            phone: int.tryParse(phone.text),
            birthDay: user1.birthDay,
            registrationDate: user1.registrationDate,
            password: "1",
            idCard: int.tryParse(idCard.text),
            managerId: event.appBloc.manager.id,
            expirationDate: user1.expirationDate,
            room: {"room_name": room.roomName},
            roomId: room.id));

        const GMAIL_SCHEMA = 'com.google.android.gm';
        final bool gmailinstalled =
            await FlutterMailer.isAppInstalled(GMAIL_SCHEMA);

        if (gmailinstalled) {
          final MailOptions mailOptions = MailOptions(
            body:
                "Bạn đăng ký hợp đồng ký túc xá thành công. hãy đăng nhập vào App với: <br> email: ${mail.text} <br> password: 1",
            subject: "Đăng ký hợp đồng thành công",
            recipients: ['${mail.text}'],
            isHTML: true,
            attachments: [
              'path/to/image.png',
            ],
            appSchema: GMAIL_SCHEMA,
          );
          await FlutterMailer.send(mailOptions);
        }

        yield CreateContractDoneState();
      } else {
        messageErrors = "Tạo thất bại";
        yield CreateContractErrorsState();
      }
    }

    if (event is ExpiredEvent) {
      statusTab = 3;
      // yield Loading();
      listContract.clear();
      for (int i = 0; i < tempContract.length; i++) {
        if ((DateTime.now().millisecondsSinceEpoch ~/ 1000) -
                tempContract[i].expirationDate >=
            0) {
          listContract.add(tempContract[i]);
        }
      }
      yield Done();
    }

    if (event is DueEvent) {
      statusTab = 2;
      // yield Loading();
      listContract.clear();
      for (int i = 0; i < tempContract.length; i++) {
        if ((DateTime.now().millisecondsSinceEpoch ~/ 1000) -
                tempContract[i].expirationDate <=
            0) {
          listContract.add(tempContract[i]);
        }
      }
      yield Done();
    }

    if (event is AllContractEvent) {
      statusTab = 1;
      // yield Loading();
      listContract.clear();
      for (int i = 0; i < tempContract.length; i++) {
        listContract.add(tempContract[i]);
      }
      yield Done();
    }

    if (event is SearchContractEvent) {
      statusTab = 4;
      listContract.clear();
      for (int i = 0; i < tempContract.length; i++) {
        if (search.text == tempContract[i].room['room_name']) {
          listContract.add(tempContract[i]);
        }
        yield Done();
      }
    }

    if(event is ChangePassUserEvent){
      Map data = {
        "email": event.appBloc.user.email,
        "old_password": oldPass.text,
        "password": newPass.text,
      };
      yield LoadingChangePassState();
      var res =await loginProvider.changePassUser(datas: data);
      if(res != null){
        oldPass.text = "";
        newPass.text = "";
        yield ChangPassDoneState();
      }
      else{
        yield ChangePassError();

      }

    }
  }
}
