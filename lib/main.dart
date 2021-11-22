import 'package:dormitory_manager/resources/colors.dart';
import 'package:dormitory_manager/ui/page/home.dart';
import 'package:dormitory_manager/ui/page/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return OrientationBuilder(
          builder: (context, orientation) {
            SizerUtil().init(constraints, orientation);
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Dormitory Manager',
              theme: ThemeData.light(),
              // theme: CupertinoThemeData(
              //   primaryColor: AppColors.mainColor,
              // ),
              home: HomePage(),
            );
          },
        );
      },
    );
  }
}