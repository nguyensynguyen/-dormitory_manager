import 'dart:io';
import 'package:dormitory_manager/bloc/app_bloc/bloc.dart';
import 'package:dormitory_manager/bloc/bill/bloc.dart';
import 'package:dormitory_manager/bloc/bill/event.dart';
import 'package:dormitory_manager/bloc/bill/state.dart';
import 'package:dormitory_manager/helper/input_format.dart';
import 'package:dormitory_manager/helper/string_helper.dart';
import 'package:dormitory_manager/helper/ui_helper.dart';
import 'package:dormitory_manager/model/service.dart';
import 'package:dormitory_manager/resources/colors.dart';
import 'package:dormitory_manager/resources/dimensions.dart';
import 'package:dormitory_manager/resources/fontsizes.dart';
import 'package:dormitory_manager/ui/widget/close_dialog.dart';
import 'package:dormitory_manager/ui/widget/item_bill.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Bill extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return BillState();
  }
}

class BillState extends State<Bill> {
  BillBloc _billBloc;
  AppBloc _appBloc;
  final List<TextInputFormatter> _formatter = [NumberFormats()];
  final List<TextInputFormatter> _formatter1 = [NumberFormats(isInt: true)];

  @override
  void initState() {
    _billBloc = BillBloc();
    _appBloc = BlocProvider.of<AppBloc>(context);
    _billBloc.add(GetAllBill(appBloc: _appBloc));
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var heightStatusBar = MediaQuery.of(context).padding.top;
    return BlocBuilder(
      cubit: _billBloc,
      builder: (context, state) {
        if (state is Loadings) {
          _billBloc.add(TotalPriceEvent(appBloc: _appBloc));
          return UIHelper.loading();
        }
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: AppDimensions.d100w,
              height: AppDimensions.d14h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomLeft,
                  colors: [
                    Colors.green,
                    AppColors.colorFacebook,
                  ],
                ),
                color: AppColors.mainColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(AppDimensions.radius3w),
                  bottomRight: Radius.circular(AppDimensions.radius3w),
                ),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: heightStatusBar,
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(AppDimensions.d1h),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "H??a ????n",
                            style: TextStyle(
                                color: AppColors.colorWhite,
                                fontSize: AppFontSizes.fs14,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: AppDimensions.d2_5h,
                          ),
                          _appBloc.isUser
                              ? Expanded(child: Container())
                              : Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: AppColors.colorWhite,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(
                                                AppDimensions.radius1_0w))),
                                    child: Padding(
                                      padding: EdgeInsets.all(0.0),
                                      child: Center(
                                        child: TextField(
                                          decoration: InputDecoration.collapsed(
                                            hintText: "T??m theo ph??ng",
                                            border: InputBorder.none,
                                          ),
                                          controller: _billBloc.searchBill,
                                          style: TextStyle(
                                              fontSize: AppFontSizes.fs9),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                          SizedBox(
                            width: AppDimensions.d0_5h,
                          ),
                          _appBloc.isUser
                              ? Container()
                              : GestureDetector(
                                  onTap: () {
                                    if (_billBloc.searchBill.text != "") {
                                      _billBloc.add(SearchDateEvent());
                                    }
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: AppColors.colorWhite,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(
                                                AppDimensions.radius1_0w))),
                                    child: Icon(
                                      Icons.search,
                                      color: AppColors.colorRed,
                                    ),
                                  ),
                                ),
                          SizedBox(
                            width: AppDimensions.d2_5h,
                          ),
                          GestureDetector(
                              onTap: () {
                                _showDateTime(context);
                              },
                              child: Icon(
                                Icons.filter_list,
                                color: AppColors.colorWhite,
                              )),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(AppDimensions.d1h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            _billBloc.add(AllPaidEvent());
                          },
                          child: Text(
                            "T???t c???",
                            style: TextStyle(
                                color: _billBloc.statusPaid == 1
                                    ? AppColors.colorOrange
                                    : AppColors.colorWhite,
                                fontSize: AppFontSizes.fs12,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _billBloc.add(PaidEvent());
                          },
                          child: Text(
                            "???? thanh to??n",
                            style: TextStyle(
                                color: _billBloc.statusPaid == 2
                                    ? AppColors.colorOrange
                                    : AppColors.colorWhite,
                                fontSize: AppFontSizes.fs12,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _billBloc.add(UnpaidEvent());
                          },
                          child: Text(
                            "Ch??a thanh to??n",
                            style: TextStyle(
                                color: _billBloc.statusPaid == 3
                                    ? AppColors.colorOrange
                                    : AppColors.colorWhite,
                                fontSize: AppFontSizes.fs12,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: ItemBill(
                  billBloc: _billBloc,
                  appBloc: _appBloc,
                ),
              ),
            ),
            _appBloc.isUser
                ? Container()
                : Container(
                    width: AppDimensions.d100w,
                    height: AppDimensions.d10h,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomLeft,
                        colors: [
                          Colors.green,
                          AppColors.colorFacebook,
                        ],
                      ),
                      color: AppColors.mainColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(AppDimensions.radius3w),
                        topRight: Radius.circular(AppDimensions.radius3w),
                      ),
                    ),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: AppDimensions.d2h),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "T???ng ti???n",
                                  style: TextStyle(
                                      color: AppColors.colorWhite,
                                      fontSize: AppFontSizes.fs12),
                                ),
                                SizedBox(
                                  height: AppDimensions.d1h,
                                ),
                                Text(
                                  "${StringHelper.formatCurrency(_billBloc.totalPrice)} ??",
                                  style: TextStyle(
                                      color: AppColors.colorWhite,
                                      fontSize: AppFontSizes.fs12,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () => UIHelper.showDialogCommon(
                                context: context,
                                widget: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            "L???p h??a ????n",
                                            style: TextStyle(
                                                color: AppColors.colorBlack_87,
                                                fontSize: AppFontSizes.fs14,
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        CloseDialog(
                                          color: AppColors.colorBlack_38,
                                          onClose: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ],
                                    ),
                                    Divider(),
                                    Expanded(
                                      child: BlocListener(
                                        listener: (context, state) {
                                          if (state is Loading) {
                                            UIHelper.showLoadingCommon(
                                                context: context);
                                          }
                                          if (state is CreateBillDone) {
                                            Navigator.pop(context);
                                            Fluttertoast.showToast(
                                                backgroundColor: AppColors.colorFacebook,
                                                msg: "L???p h??a ????n th??nh c??ng",
                                                toastLength:
                                                    Toast.LENGTH_SHORT);
                                          }
                                        },
                                        cubit: _billBloc,
                                        child: BlocBuilder(
                                          cubit: _billBloc,
                                          builder: (context, state) {
                                            return SingleChildScrollView(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  _buildTop(),
                                                  Divider(),
                                                  _buildfirst(),
                                                  Divider(),
                                                  _buildSecond(_appBloc),
                                                  Divider(),
                                                  _buildBottom(_appBloc),
                                                  Divider(),
                                                  _buildButton()
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    )
                                  ],
                                )),
                            behavior: HitTestBehavior.opaque,
                            child: Container(
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: AppColors.colorWhite),
                                  borderRadius: BorderRadius.circular(
                                      AppDimensions.radius1_0w)),
                              child: Padding(
                                padding: EdgeInsets.all(AppDimensions.d1h),
                                child: Text(
                                  "L???p h??a ????n",
                                  style: TextStyle(
                                      color: AppColors.colorWhite,
                                      fontSize: AppFontSizes.fs12),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          ],
        );
      },
    );
  }

  _buildTop() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppDimensions.d1h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Th??ng tin h??a ????n",
            style: TextStyle(
              color: AppColors.colorBlack_87,
              fontSize: AppFontSizes.fs14,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "Nh???p ?????y ????? th??ng tin v??o ????y",
            style: TextStyle(
              color: AppColors.colorBlack_87,
              fontSize: AppFontSizes.fs10,
            ),
          ),
        ],
      ),
    );
  }

  _buildfirst() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppDimensions.d2h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Th??ng ch???t *",
            style: TextStyle(
              color: AppColors.colorBlack,
              fontSize: AppFontSizes.fs12,
            ),
          ),
          SizedBox(
            height: AppDimensions.d1h,
          ),
          GestureDetector(
            child: Container(
                width: AppDimensions.d100w,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.colorGrey_300),
                  borderRadius: BorderRadius.all(
                    Radius.circular(AppDimensions.radius1_5w),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(AppDimensions.d1h),
                  child: Row(
                    children: [
                      Text("${DateTime.now().month}/${DateTime.now().year}"),
                      Expanded(
                        child: Container(),
                      ),
                      Icon(
                        Icons.content_paste,
                        color: AppColors.colorGrey_400,
                      )
                    ],
                  ),
                )),
          ),
          SizedBox(
            height: AppDimensions.d1h,
          ),
          Text(
            "Ph??ng *",
            style: TextStyle(
              color: AppColors.colorBlack,
              fontSize: AppFontSizes.fs12,
            ),
          ),
          SizedBox(
            height: AppDimensions.d1h,
          ),
          GestureDetector(
            onTap: () {
              _showDialog(_appBloc);
            },
            child: Container(
              width: AppDimensions.d100w,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.colorGrey_300),
                borderRadius: BorderRadius.all(
                  Radius.circular(AppDimensions.radius1_5w),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(AppDimensions.d1h),
                child: Row(
                  children: [
                    Text(_appBloc.room?.roomName ?? ""),
                    Expanded(
                      child: Container(),
                    ),
                    Icon(
                      Icons.keyboard_arrow_down,
                      color: AppColors.colorGrey_400,
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildSecond(AppBloc appBloc) {
    List<Widget> widget = []..insert(
        0,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "D???ch v??? s??? d???ng",
                style: TextStyle(
                  color: AppColors.colorBlack_87,
                  fontSize: AppFontSizes.fs14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text(
              "H??y ch???n d???ch v??? kh??ch s??? d???ng",
              style: TextStyle(
                color: AppColors.colorBlack_87,
                fontSize: AppFontSizes.fs10,
              ),
            ),
            SizedBox(
              height: AppDimensions.d1h,
            ),
          ],
        ));
    // appBloc.listService =
    //     appBloc.room?.service ?? appBloc.listAllDataRoom[0].service;
    if (appBloc.room != null) {
      appBloc.listService = appBloc.room.service;
      for (int i = 0; i < appBloc.listService?.length; i++) {
        if (appBloc.listService[i].startNumberTextEdit.text == "") {
          appBloc.listService[i].startNumberTextEdit.text =
              appBloc.listService[i].numberStart.toString();
        }
        widget.add(Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //??i???n
            appBloc.listService[i]?.unit != ""
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: AppDimensions.d1h,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: AppColors.colorOrange,
                            size: AppFontSizes.fs18,
                          ),
                          SizedBox(
                            width: AppDimensions.d0_5h,
                          ),
                          RichText(
                            text: TextSpan(children: <TextSpan>[
                              TextSpan(
                                text: "${appBloc.listService[i].serviceName}\n",
                                style: TextStyle(
                                  color: AppColors.colorBlack_87,
                                  fontSize: AppFontSizes.fs10,
                                ),
                              ),
                              TextSpan(
                                text:
                                    "${StringHelper.formatCurrency(appBloc.listService[i].unitPrice)} ${appBloc.listService[i].unit ?? ''}",
                                style: TextStyle(
                                  color: AppColors.colorBlack_87,
                                  fontSize: AppFontSizes.fs8,
                                ),
                              ),
                            ]),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: AppDimensions.d1h,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "S??? c?? *",
                                  style: TextStyle(
                                    color: AppColors.colorBlack_87,
                                    fontSize: AppFontSizes.fs10,
                                  ),
                                ),
                                Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: AppColors.colorGrey_300),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(AppDimensions.radius1_5w),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(AppDimensions.d1h),
                                      child: Row(
                                        children: [
                                          Text("${appBloc
                                              .listService[i].numberStart}"),
                                          Expanded(
                                            child: Container(),
                                          ),

                                        ],
                                      ),
                                    )),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: AppDimensions.d1h,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "S??? m???i *",
                                  style: TextStyle(
                                    color: AppColors.colorBlack_87,
                                    fontSize: AppFontSizes.fs10,
                                  ),
                                ),

                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: AppColors.colorGrey_300),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(AppDimensions.radius1_5w),
                                    ),
                                  ),
                                  child: CupertinoTextField(
                                    decoration: BoxDecoration(border: null),
                                    inputFormatters: _formatter,
                                    controller: appBloc
                                        .listService[i].endNumberTextEdit,
                                    onChanged: (text) {
                                      if (appBloc.listService[i]
                                              .endNumberTextEdit?.text ==
                                          "") {
                                        appBloc.listService[i].totalService =
                                            0.0;
                                      } else {
                                        appBloc.listService[i].totalService =
                                            (int.tryParse(appBloc
                                                        .listService[i]
                                                        .endNumberTextEdit
                                                        ?.text) -
                                                    int.tryParse(appBloc
                                                        .listService[i]
                                                        .startNumberTextEdit
                                                        .text)) *
                                                appBloc
                                                    .listService[i].unitPrice;
                                      }
                                      _billBloc.add(UpdateUIEvent());
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: AppDimensions.d1h,
                      ),
                      RichText(
                        text: TextSpan(children: <TextSpan>[
                          TextSpan(
                            text: "Th??nh Ti???n ",
                            style: TextStyle(
                              color: AppColors.colorBlack_87,
                              fontSize: AppFontSizes.fs10,
                            ),
                          ),
                          TextSpan(
                            text: appBloc.listService[i].totalService < 0
                                ? "0.0 ??"
                                : "${StringHelper.formatCurrency(appBloc.listService[i].totalService)} ??",
                            style: TextStyle(
                                color: AppColors.colorBlack_87,
                                fontSize: AppFontSizes.fs10,
                                fontWeight: FontWeight.bold),
                          ),
                        ]),
                      ),
                      Divider(),
                    ],
                  )
                :
                //v??? sinh
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          appBloc.listService[i].isCheck
                              ? GestureDetector(
                                  onTap: () {
                                    appBloc.listService[i].isCheck = false;
                                    appBloc.listService[i].totalService = 0;
                                    _billBloc.add(UpdateUIEvent());
                                  },
                                  child: Icon(
                                    Icons.check_circle,
                                    color: AppColors.colorOrange,
                                    size: AppFontSizes.fs18,
                                  ),
                                )
                              : GestureDetector(
                                  onTap: () {
                                    appBloc.listService[i].isCheck = true;
                                    appBloc.listService[i].totalService =
                                        appBloc.listService[i].unitPrice;
                                    _billBloc.add(UpdateUIEvent());
                                  },
                                  child: Icon(
                                    Icons.check_circle,
                                    color: AppColors.colorBlack,
                                    size: AppFontSizes.fs18,
                                  ),
                                ),
                          SizedBox(
                            width: AppDimensions.d0_5h,
                          ),
                          RichText(
                            text: TextSpan(children: <TextSpan>[
                              TextSpan(
                                text: "${appBloc.listService[i].serviceName}\n",
                                style: TextStyle(
                                  color: AppColors.colorBlack_87,
                                  fontSize: AppFontSizes.fs10,
                                ),
                              ),
                              TextSpan(
                                text:
                                    "${StringHelper.formatCurrency(appBloc.listService[i].unitPrice)} ??",
                                style: TextStyle(
                                  color: AppColors.colorBlack_87,
                                  fontSize: AppFontSizes.fs8,
                                ),
                              ),
                            ]),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: AppDimensions.d1h,
                      ),
                      RichText(
                        text: TextSpan(children: <TextSpan>[
                          TextSpan(
                            text: "Th??nh Ti???n ",
                            style: TextStyle(
                              color: AppColors.colorBlack_87,
                              fontSize: AppFontSizes.fs10,
                            ),
                          ),
                          TextSpan(
                            text:
                                "${StringHelper.formatCurrency(appBloc.listService[i].unitPrice)} ??",
                            style: TextStyle(
                                color: AppColors.colorBlack_87,
                                fontSize: AppFontSizes.fs10,
                                fontWeight: FontWeight.bold),
                          ),
                        ]),
                      ),
                    ],
                  )
          ],
        ));
      }
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppDimensions.d2h),
      child: Column(
        children: widget.map<Widget>((item) {
          return item;
        }).toList(),
      ),
    );
  }

  _buildBottom(AppBloc appBloc) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppDimensions.d1h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "T???ng h???p",
            style: TextStyle(
              color: AppColors.colorBlack_87,
              fontSize: AppFontSizes.fs14,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "Xem l???i th??ng tin tr?????c khi x??c nh???n",
            style: TextStyle(
              color: AppColors.colorBlack_87,
              fontSize: AppFontSizes.fs10,
            ),
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("T???ng ti???n"),
              Text(
                totalPriceServiceInput(appBloc) < 0
                    ? "0.0 ??"
                    : "${StringHelper.formatCurrency(totalPriceServiceInput(appBloc))} ??",
                style: TextStyle(
                    fontSize: AppFontSizes.fs12,
                    color: AppColors.colorOrange,
                    fontWeight: FontWeight.bold),
              ),
            ],
          )
        ],
      ),
    );
  }

  _buildButton() {
    return Padding(
      padding: EdgeInsets.all(AppDimensions.d1h),
      child: GestureDetector(
        onTap: () {
          _billBloc.add(CreateBill(appBloc: _appBloc));
        },
        behavior: HitTestBehavior.opaque,
        child: Container(
          alignment: Alignment.center,
          width: AppDimensions.d100w,
          decoration: BoxDecoration(
            boxShadow: [],
            color: AppColors.colorOrange,
            borderRadius: BorderRadius.all(
              Radius.circular(AppDimensions.radius1_0w),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(AppDimensions.d2h),
            child: Text(
              "X??c nh???n",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.colorWhite,
              ),
            ),
          ),
        ),
      ),
    );
  }

  double totalPriceServiceInput(AppBloc appBloc) {
    appBloc.totalPrice = 0.0;

    appBloc.listService?.forEach((element) {
      appBloc.totalPrice += element.totalService;
    });
    return appBloc.totalPrice;
  }

  _showDialog(AppBloc appBloc) {
    List<Widget> widget = []..insert(
        0,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppDimensions.d2w),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  "Ch???n ph??ng",
                  style: TextStyle(
                      fontSize: AppFontSizes.fs14, fontWeight: FontWeight.bold),
                ),
              ),
              CloseDialog(
                color: AppColors.colorBlack_54,
                onClose: () {
                  Navigator.pop(context);
                },
              )
            ],
          ),
        ),
      );
    for (int i = 0; i < appBloc.listAllDataRoom.length; i++) {
      DateTime _dateCheck = DateTime.fromMillisecondsSinceEpoch(
          appBloc.listAllDataRoom[i].dateCreateBill * 1000);
      DateTime _currentTime = DateTime.now();
      if (_dateCheck.month != _currentTime.month) {
        widget.add(Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: AppDimensions.d1h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppDimensions.d2w),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  appBloc.room = appBloc.listAllDataRoom[i];
                  // appBloc.index = i;
                  Navigator.pop(context);
                  _billBloc.add(UpdateUIEvent());
                },
                child: Text(
                  "${appBloc.listAllDataRoom[i].roomName}",
                  style: TextStyle(fontSize: AppFontSizes.fs12),
                ),
              ),
            ),
            Divider(),
            SizedBox(
              height: AppDimensions.d1h,
            ),
          ],
        ));
      }
    }
    return UIHelper.showDialogLogin(
      context: context,
      widget: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: widget.map<Widget>((e) {
            return e;
          }).toList(),
        ),
      ),
    );
  }

  DateTime _showDateTime(BuildContext context) {
    return UIHelper.showDialogLogin(
      context: context,
      widget: Padding(
        padding: EdgeInsets.all(AppDimensions.d1h),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "H???y",
                  style: TextStyle(
                      color: AppColors.colorFacebook,
                      fontWeight: FontWeight.bold),
                ),
              ),
              GestureDetector(
                onTap: () {
                  _billBloc.add(FilterDateEvent());
                  Navigator.pop(context);
                  _billBloc.add(UpdateUIEvent());
                },
                child: Text(
                  "X??c nh???n",
                  style: TextStyle(
                      color: AppColors.colorFacebook,
                      fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
          Container(
            height: AppDimensions.d30h,
            child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                initialDateTime: DateTime.now(),
                onDateTimeChanged: (dateTime) {
                  _billBloc.time = dateTime;
                }),
          )
        ]),
      ),
    );
  }
}
