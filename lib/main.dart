import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:starlink_statellite/splash_screen.dart';

import 'home_screen.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(1080, 1920),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,

          title: 'First Method',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            textTheme: Typography.englishLike2018.apply(fontSizeFactor: 1.sp),
          ),
          themeMode: ThemeMode.dark,
          darkTheme: ThemeData(
            fontFamily: 'Lexend',
            // colorScheme: ColorScheme.fromSeed(seedColor: appColor),
            // primaryColor: appColor,
          ),
          home: child,
        );
      },
      child: SplashScreen(),
    );
  }
}
