import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:starlink_statellite/choose_language.dart';

import 'home_screen.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 5), () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool isIntroScreenOpened = prefs.getBool("isIntroScreenOpened") ?? false;
      bool isLanguageChosen = prefs.getBool("isLanguageChosen") ?? false;

      if (isLanguageChosen) {
        if (isIntroScreenOpened) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => OnboardingScreen()),
          );
        }
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ChooseLanguage()),
        );
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                alignment: Alignment.topCenter,
                image: AssetImage("assets/splash/bg.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Image.asset(
                        "assets/splash/logo.png",
                        alignment: Alignment.center,
                        fit: BoxFit.contain,
                        height: 500.h,
                      ),
                    ),
                    SizedBox(height: 30.h),
                    RichText(
                        text: TextSpan(
                      children: [
                        TextSpan(
                            text: "Starlink ",
                            style: TextStyle(
                                fontSize: 80.sp, color: Color(0xFFFFFFFF))),
                        TextSpan(
                            text: "Satellite ",
                            style: TextStyle(
                                fontSize: 80.sp, color: Color(0xFF2585C2))),
                        TextSpan(
                            text: "Tracker",
                            style: TextStyle(
                                fontSize: 80.sp, color: Color(0xFFFFFFFF))),
                      ],
                    )),
                    SizedBox(height: 100.h),
                    Lottie.asset(
                      "assets/splash/loader.json",
                      alignment: Alignment.bottomCenter,
                      height: 100.h,
                      animate: true,
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
