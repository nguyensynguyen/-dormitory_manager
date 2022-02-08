import 'dart:io';
import 'package:dormitory_manager/bloc/app_bloc/bloc.dart';
import 'package:dormitory_manager/ui/page/home.dart';
import 'package:dormitory_manager/ui/page/report.dart';
import 'package:dormitory_manager/ui/page/splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sizer/sizer.dart';

String router = "";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('ic_launcher');
  final InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);
  await Firebase.initializeApp();
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String payload) async {
    if (payload != null) {
      if (payload == "report") {
        print("$payload");
        router = payload;
      }
    }
  });
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent, // transparent status bar
          systemNavigationBarColor: Colors.black, // navigation bar color
          statusBarIconBrightness: Platform.isAndroid
              ? Brightness.dark
              : Brightness.light, // status bar icons' color
          systemNavigationBarIconBrightness:
              Platform.isAndroid ? Brightness.light : Brightness.dark,
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return OrientationBuilder(
              builder: (context, orientation) {
                SizerUtil().init(constraints, orientation);
                return BlocProvider<AppBloc>(
                    create: (BuildContext context) => AppBloc(),
                    child: MaterialApp(
                      debugShowCheckedModeBanner: false,
                      initialRoute: "/",
                      routes: <String, WidgetBuilder>{
                        'home': (context) => HomePage(),
                        router: (context) => Report()
                      },
                      title: 'Dormitory Manager',
                      theme: ThemeData.light(),
                      // theme: CupertinoThemeData(
                      //   primaryColor: AppColors.mainColor,
                      // ),
                      home: Splash(),
                    ));
              },
            );
          },
        ));
  }
}
