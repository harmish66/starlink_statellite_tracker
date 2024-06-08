import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:starlink_statellite/select_location.dart';
import 'package:starlink_statellite/service/image_press_unpress.dart';
import 'package:starlink_statellite/variable.dart';
import 'live_map.dart';
import 'model/city_model.dart';
import 'model/country_model.dart';
import 'model/satate_model.dart';

Position? _currentPosition;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  String? _currentAddress;


  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }


  Future<void> _getCurrentLocation() async {
    await Permission.location.request();

    if (await Permission.location.isGranted) {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentPosition = position;
        curretnpositionx = position.latitude;
        curretnpositiony = position.longitude;
      });
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
            position.latitude, position.longitude);
        Placemark? place = placemarks[0];
        setState(() {
          _currentAddress = "${place?.locality}, ${place?.country}";
          countrylocation = place!.country!;
          statelocation = place.locality!;
        });
      } catch (e) {
        // Handle error
      }
    } else {
      // Handle permission denied scenario
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.black,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 100.h),
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  width: 408.w,
                  child: RichText(
                      text: TextSpan(
                    children: [
                      TextSpan(
                          text: "Starlink ",
                          style: TextStyle(
                              fontSize: 50.sp, color: Color(0xFFFFFFFF))),
                      TextSpan(
                          text: "Satellite ",
                          style: TextStyle(
                              fontSize: 50.sp, color: Color(0xFF2585C2))),
                      TextSpan(
                          text: "Tracker",
                          style: TextStyle(
                              fontSize: 50.sp, color: Color(0xFFFFFFFF))),
                    ],
                  )),
                ),
                PressUnpress(
                    onTap: () {},
                    height: 100.h,
                    width: 500.w,
                    imageAssetPress: "assets/home_screen/premium_pressed.png",
                    imageAssetUnPress:
                        "assets/home_screen/premium_unpressed.png",
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 0,
                        left: 39,
                      ),
                      child: Text("Premimum",
                          style: TextStyle(
                              fontSize: 28.sp,
                              fontFamily: "Lexend",
                              color: Color(0xFFFFFFFF))),
                    )),
                PressUnpress(
                  onTap: () {},
                  height: 100.h,
                  width: 170.w,
                  imageAssetPress: "assets/home_screen/language_pressed.png",
                  imageAssetUnPress:
                      "assets/home_screen/language_unpressed.png",
                )
              ],
            ),
            SizedBox(height: 100.h),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: PressUnpress(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => StarlinkScreen(),
                          ),
                        );
                      },
                      height: 400.h,
                      width: 480.w,
                      imageAssetPress:
                          "assets/home_screen/starlink_satellite_tracker_pressed.png",
                      imageAssetUnPress:
                          "assets/home_screen/starlink_satellite_tracker_unpressed.png",
                      child: Padding(
                        padding:
                            const EdgeInsets.only(top: 0, left: 0, bottom: 80),
                        child: Text("Starlink Satellite Tracker",
                            style: TextStyle(
                                fontSize: 50.sp,
                                fontFamily: "Lexend",
                                color: Color(0xFFFFFFFF))),
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: PressUnpress(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => LiveMapScreen()),
                        );
                      },
                      height: 400.h,
                      width: 480.w,
                      imageAssetPress:
                          "assets/home_screen/live_map_pressed.png",
                      imageAssetUnPress:
                          "assets/home_screen/live_map_unpressed.png",
                      child: Padding(
                        padding:
                            const EdgeInsets.only(top: 0, left: 0, bottom: 80),
                        child: Text("Live Map",
                            style: TextStyle(
                                fontSize: 50.sp,
                                fontFamily: "Lexend",
                                color: Color(0xFFFFFFFF))),
                      )),
                ),
              ],
            ),
            Center(
              child: PressUnpress(
                  onTap: () {},
                  height: 200.h,
                  width: 1000.w,
                  imageAssetPress: "assets/home_screen/help_pressed.png",
                  imageAssetUnPress: "assets/home_screen/help_unpressed.png",
                  child: Center(
                    child: Text("Help",
                        style: TextStyle(
                            fontSize: 50.sp,
                            fontFamily: "Lexend",
                            color: Color(0xFFFFFFFF))),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
