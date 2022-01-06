import 'package:dormitory_manager/bloc/app_bloc/bloc.dart';
import 'package:dormitory_manager/bloc/contract/bloc.dart';
import 'package:dormitory_manager/bloc/contract/event.dart';
import 'package:dormitory_manager/bloc/contract/state.dart';
import 'package:dormitory_manager/helper/ui_helper.dart';
import 'package:dormitory_manager/resources/colors.dart';
import 'package:dormitory_manager/resources/dimensions.dart';
import 'package:dormitory_manager/resources/fontsizes.dart';
import 'package:dormitory_manager/ui/widget/close_dialog.dart';
import 'package:dormitory_manager/ui/widget/item_contract.dart';
import 'package:dormitory_manager/ui/widget/show_dialog_create_contract.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Contract extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _contract();
  }
}

class _contract extends State<Contract> {
  ContractBloc _contractBloc;
  AppBloc _appBloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _appBloc = BlocProvider.of<AppBloc>(context);
    _contractBloc = ContractBloc();
    _contractBloc.add(GetAllContractEvent(appBloc: _appBloc));
  }

  @override
  Widget build(BuildContext context) {
    var heightStatusBar = MediaQuery.of(context).padding.top;
    return BlocListener(
      cubit: _contractBloc,
      listener: (context, state) {
        if (state is Loading) {
          UIHelper.showLoadingCommon(context: context);
        }
        if (state is GetDone) {
          Navigator.pop(context);
        }
      },
      child: BlocBuilder(
        cubit: _contractBloc,
        builder: (context, state) {
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
                              "Hợp Đồng",
                              style: TextStyle(
                                  color: AppColors.colorWhite,
                                  fontSize: AppFontSizes.fs14,
                                  fontWeight: FontWeight.bold),
                            ),
                            GestureDetector(
                              onTap: () {
                                _showDialogCreateContract();
                              },
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: AppColors.colorOrange,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(AppDimensions.radius1_0w),
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(AppDimensions.d0_5h),
                                  child: Text(
                                    "Thêm hợp đồng",
                                    style: TextStyle(
                                        color: AppColors.colorWhite,
                                        fontSize: AppFontSizes.fs12,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(AppDimensions.d1h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Tất cả",
                            style: TextStyle(
                                color: AppColors.colorWhite,
                                fontSize: AppFontSizes.fs12,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Còn hạn hợp đồng",
                            style: TextStyle(
                                color: AppColors.colorWhite,
                                fontSize: AppFontSizes.fs12,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Hết hạn hợp đồng",
                            style: TextStyle(
                                color: AppColors.colorWhite,
                                fontSize: AppFontSizes.fs12,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: ItemContract(
                    contractBloc: _contractBloc,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  _showDialogCreateContract() {
    return UIHelper.showDialogCommon(
      context: context,
      widget: Padding(
        padding: EdgeInsets.all(AppDimensions.d1h),
        child: BlocBuilder(
            cubit: _contractBloc,
            builder: (context, state) {
              return Column(
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          // _showDialogCreateEquipment(
                          //     context: context, allRoomBloc: _allRoomBloc);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: AppColors.colorWhite,
                            borderRadius: BorderRadius.all(
                              Radius.circular(AppDimensions.radius1_0w),
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(AppDimensions.d1h),
                            child: Text(
                              "Thêm hợp đồng",
                              style: TextStyle(
                                  color: AppColors.colorFacebook,
                                  fontSize: AppFontSizes.fs14,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(),
                      ),
                      CloseDialog(
                        color: AppColors.colorBlack,
                        onClose: () {
                          Navigator.pop(context);
                        },
                      )
                    ],
                  ),
                  Divider(),
                  Expanded(
                    child: SingleChildScrollView(
                      child: CreateContract(
                        contractBloc: _contractBloc,
                        appBloc: _appBloc,
                      ),
                    ),
                  )
                ],
              );
            }),
      ),
    );
  }

}
