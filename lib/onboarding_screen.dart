import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:starlink_statellite/home_screen.dart';
import 'package:starlink_statellite/service/image_press_unpress.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  List<OnboardingScreen> pages = [];
  bool pressGeoON = false;
  bool cmbscritta = false;
  bool ispressed = false;
  final PageController _controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            onPageChanged: (value) {
              setState(() {
                pressGeoON = !pressGeoON;
                cmbscritta = !cmbscritta;
              });
            },
            controller: _controller,
            children: [
              //Screen1
              Container(
                color: Colors.black,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                        width: 800.w,
                        height: 1000.h,
                        child: Image.asset(
                          "assets/onboarding1/intro_logo_1.png",
                          fit: BoxFit.cover,
                        )),
                    Text("Satellite Finder",
                        style: TextStyle(
                            fontSize: 70.sp,
                            color: Colors.white,
                            fontFamily: "Lexend",
                            fontWeight: FontWeight.w700)),
                    SizedBox(
                      height: 20.h,
                    ),
                    Text("Using satellite, you will be able to find",
                        style: TextStyle(
                            fontSize: 55.sp,
                            fontFamily: "Lexend",
                            color: Colors.white)),
                    Text("satellite anywhere in the world.",
                        style: TextStyle(
                            fontSize: 55.sp,
                            fontFamily: "Lexend",
                            color: Colors.white)),
                    SizedBox(
                      height: 150.h,
                    ),
                  ],
                ),
              ),
              //Screen2
              Container(
                color: Colors.black,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                        width: 800.w,
                        height: 1000.h,
                        child: Image.asset(
                          "assets/onboarding2/logo.png",
                          fit: BoxFit.cover,
                        )),
                    Text("Multiple Satellite",
                        style: TextStyle(
                            fontSize: 70.sp,
                            fontFamily: "Lexend",
                            color: Colors.white,
                            fontWeight: FontWeight.w700)),
                    SizedBox(
                      height: 20.h,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                      child: Text("You will now be able to view a list of",
                          style: TextStyle(
                            fontSize: 55.sp,
                            fontFamily: "Lexend",
                            color: Colors.white,
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                      child: Text("multiple satellites at the same time.",
                          style: TextStyle(
                            fontSize: 55.sp,
                            fontFamily: "Lexend",
                            color: Colors.white,
                          )),
                    ),
                    SizedBox(
                      height: 150.h,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                PressUnpress(
                  height: 150.h,
                  width: 850.w,
                  imageAssetPress: "assets/onboarding2/done_pressed.png",
                  imageAssetUnPress: "assets/onboarding2/done_unpressed.png",
                  onTap: () async {
                    if (_controller.page!.toInt() != 1) {
                      _controller.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeIn);
                    } else {
                      SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                      prefs.setBool("isIntroScreenOpened", true);
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomeScreen()));
                    }
                  },
                  child: cmbscritta
                      ? const Center(
                          child: Text(
                            "Done",
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        )
                      : const Center(
                          child: Text(
                            "Next",
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        ),
                ),
                SizedBox(
                  height: 200.h,
                  child: Container(
                    alignment: Alignment.center,
                    child: SmoothPageIndicator(
                      controller: _controller,
                      count: 2,
                      effect: const SlideEffect(
                        dotHeight: 10,
                        dotColor: Color(0xFF252525),
                        activeDotColor: Color(0xFF449CD3),
                        dotWidth: 10,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
