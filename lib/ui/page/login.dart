import 'package:dormitory_manager/bloc/app_bloc/bloc.dart';
import 'package:dormitory_manager/bloc/app_bloc/event.dart';
import 'package:dormitory_manager/bloc/auth/bloc.dart';
import 'package:dormitory_manager/bloc/auth/event.dart';
import 'package:dormitory_manager/bloc/auth/state.dart';
import 'package:dormitory_manager/helper/input_format.dart';
import 'package:dormitory_manager/helper/ui_helper.dart';
import 'package:dormitory_manager/provider/login_provider.dart';
import 'package:dormitory_manager/resources/colors.dart';
import 'package:dormitory_manager/resources/dimensions.dart';
import 'package:dormitory_manager/resources/fontsizes.dart';
import 'package:dormitory_manager/ui/page/home.dart';
import 'package:dormitory_manager/ui/widget/close_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoginState();
  }
}

class LoginState extends State<Login> {
  String typeAccount = "Quản lý";
  AuthBloc _authBloc;
  AppBloc _appBloc;
  final List<TextInputFormatter> _formatter1 = [NumberFormats(isInt: true)];

  @override
  void initState() {
    _authBloc = AuthBloc();
    _appBloc = BlocProvider.of<AppBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
        cubit: _authBloc,
        listener: (ctx, state) {
          if (state is LoadingLogin) {
            UIHelper.showLoadingCommon(context: ctx);
          }
          if (state is LoginDone) {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => HomePage()),
                (Route<dynamic> route) => false);
          }

          if (state is LoginFail) {
            Fluttertoast.showToast(
              msg: _authBloc.errorsMessage,
              toastLength: Toast.LENGTH_LONG,
              backgroundColor: AppColors.colorFacebook,
            );
            Navigator.pop(context);
          }
        },
        child: BlocBuilder(
          cubit: _authBloc,
          builder: (context, state) {
            return Scaffold(
              body: SingleChildScrollView(
                child: Container(
                  height: AppDimensions.d100h,
                  width: AppDimensions.d100w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: AppDimensions.d100w,
                        height: AppDimensions.d50h,
                        child: Image.asset(
                          'asset/image/logo_login.png',
                          fit: BoxFit.fill,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          width: AppDimensions.d100w,
                          decoration: BoxDecoration(
                            color: AppColors.colorAppBarDefault,
                            borderRadius: BorderRadius.only(
                              topLeft:
                                  Radius.circular(AppDimensions.radius2_5w),
                              topRight:
                                  Radius.circular(AppDimensions.radius2_5w),
                            ),
                          ),
                          child: Column(
                            children: [
                              Text(
                                "Đăng Nhập",
                                style: TextStyle(
                                    color: AppColors.colorBlack_54,
                                    fontSize: AppFontSizes.fs20,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: AppDimensions.d1h,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: AppColors.colorGrey_300),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(AppDimensions.radius1_5w),
                                  ),
                                ),
                                width: AppDimensions.d70w,
                                child: CupertinoTextField(
                                    controller: _authBloc.email,
                                    placeholder: "Email"),
                              ),
                              SizedBox(
                                height: AppDimensions.d1h,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: AppColors.colorGrey_300),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(AppDimensions.radius1_5w),
                                  ),
                                ),
                                width: AppDimensions.d70w,
                                child: CupertinoTextField(
                                  controller: _authBloc.password,
                                  obscureText: true,
                                  placeholder: "Mật khẩu",
                                ),
                              ),
                              SizedBox(
                                height: AppDimensions.d1h,
                              ),
                              GestureDetector(
                                onTap: () => _showDialog(),
                                child: Container(
                                  width: AppDimensions.d70w,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: AppColors.colorGrey_300),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(AppDimensions.radius1_5w),
                                    ),
                                  ),
                                  child: Padding(
                                    padding:
                                        EdgeInsets.all(AppDimensions.d0_5h),
                                    child: Row(
                                      children: [
                                        Text(typeAccount),
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
                              SizedBox(
                                height: AppDimensions.d2h,
                              ),
                              GestureDetector(
                                onTap: () {
                                  _authBloc.add(LoginEvent(appBloc: _appBloc));
                                },
                                behavior: HitTestBehavior.opaque,
                                child: Container(
                                  alignment: Alignment.center,
                                  width: AppDimensions.d70w,
                                  decoration: BoxDecoration(
                                    boxShadow: [],
                                    color: AppColors.colorOrange,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(AppDimensions.radius1_5w),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(AppDimensions.d2h),
                                    child: Text(
                                      "Đăng nhập",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.colorWhite,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: AppDimensions.d1h,
                              ),
                              GestureDetector(
                                onTap: () {
                                  _showDialogCreateManager();
//                                  _authBloc.add(LoginEvent(appBloc: _appBloc));
                                },
                                behavior: HitTestBehavior.opaque,
                                child: Container(
                                  alignment: Alignment.center,
                                  width: AppDimensions.d70w,
                                  decoration: BoxDecoration(
                                    boxShadow: [],
                                    color: AppColors.colorFacebook,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(AppDimensions.radius1_5w),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(AppDimensions.d2h),
                                    child: Text(
                                      "Đăng ký",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.colorWhite,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ));
  }

  _showDialog() {
    return UIHelper.showDialogLogin(
        context: context,
        widget: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppDimensions.d2w),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "Chọn loại tài khoản",
                      style: TextStyle(
                          fontSize: AppFontSizes.fs14,
                          fontWeight: FontWeight.bold),
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
            Divider(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppDimensions.d2w),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  setState(() {
                    _appBloc.isUser = false;
                    typeAccount = "Quản lý";
                  });
                  Navigator.pop(context);
                },
                child: Text(
                  "Quản lý",
                  style: TextStyle(fontSize: AppFontSizes.fs12),
                ),
              ),
            ),
            Divider(),
            SizedBox(
              height: AppDimensions.d1h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppDimensions.d2w),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  setState(() {
                    _appBloc.isUser = true;
                    typeAccount = "Người thuê";
                  });
                  Navigator.pop(context);
                },
                child: Text(
                  "Người thuê",
                  style: TextStyle(fontSize: AppFontSizes.fs12),
                ),
              ),
            ),
            SizedBox(
              height: AppDimensions.d1h,
            ),
          ],
        ));
  }

  _showDialogCreateManager() {
    return UIHelper.showDialogCommon(
      context: context,
      widget: Padding(
        padding: EdgeInsets.all(AppDimensions.d1h),
        child: BlocListener(
          cubit: _authBloc,
          listener: (context, state) {
            if (state is CreateDone) {
              Navigator.pop(context);
              Fluttertoast.showToast(
                  backgroundColor: AppColors.colorFacebook,
                  msg: "Đăng ký thành công",
                  toastLength: Toast.LENGTH_LONG);
            }
            if (state is CreateErrors) {
              Navigator.pop(context);
              Fluttertoast.showToast(
                  backgroundColor: AppColors.colorFacebook,
                  msg: _authBloc.errorsMessage,
                  toastLength: Toast.LENGTH_LONG);
            }
            if (state is LoadingCreate) {
              UIHelper.showLoadingCommon(context: context);
            }
          },
          child: BlocBuilder(
              cubit: _authBloc,
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
                                "Đăng ký tài khoản cho người quản lý",
                                style: TextStyle(
                                    color: AppColors.colorFacebook,
                                    fontSize: AppFontSizes.fs16,
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
                        child: Column(
                          children: [
                            _intput(
                                title: "Họ tên",
                                hintText: "Nhập họ tên",
                                textEditingController: _authBloc.nameManager),
                            _intput(
                                title: "Email",
                                hintText: "Nhập email",
                                textEditingController: _authBloc.emailManager),
                            _intput(
                                title: "Số điện thoại",
                                hintText: "Nhập số điện thoại",
                                textEditingController: _authBloc.phoneManager,
                                formatter1: _formatter1),
                            _intput(
                                title: "Địa chỉ",
                                hintText: "Nhập địa chỉ",
                                textEditingController:
                                    _authBloc.addressManager),
                            _intput(
                                title: "Mật khẩu",
                                hintText: "Nhập mật khẩu",
                                isPassword: true,
                                textEditingController:
                                    _authBloc.passwordManager),
                            _buildButton(ontap: () {
                              _authBloc.add(CreateManager(appBloc: _appBloc));
                            })
                          ],
                        ),
                      ),
                    )
                  ],
                );
              }),
        ),
      ),
    );
  }

  _buildButton({Function ontap}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppDimensions.d1h),
      child: GestureDetector(
        onTap: ontap,
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
              "Xác nhận",
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

  _intput(
      {String title,
      String hintText,
      TextEditingController textEditingController,
        bool isPassword,
      List<TextInputFormatter> formatter1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${title} *",
          style: TextStyle(
              color: AppColors.colorBlack_87,
              fontSize: AppFontSizes.fs12,
              fontWeight: FontWeight.bold),
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.colorGrey_300),
            borderRadius: BorderRadius.all(
              Radius.circular(AppDimensions.radius1_5w),
            ),
          ),
          child: CupertinoTextField(
            inputFormatters: formatter1 == null ? [] : formatter1,
            controller: textEditingController,
            obscureText: isPassword ?? false,
            placeholder: "",
            placeholderStyle:
                TextStyle(color: Colors.grey, fontSize: AppFontSizes.fs12),
          ),
        ),
        SizedBox(
          height: AppDimensions.d1h,
        ),
      ],
    );
  }
}
