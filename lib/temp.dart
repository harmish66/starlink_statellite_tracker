// import 'package:country_state_city_pro/country_state_city_pro.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:geocode/geocode.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:starlink_statellite/satellite_list.dart';
// import 'package:starlink_statellite/service/image_press_unpress.dart';
// import 'package:starlink_statellite/variable.dart';
//
// import 'help.dart';
// import 'live_map.dart';
//
// Position? _currentPosition;
//
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({Key? key}) : super(key: key);
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   int _selectedIndex = 0;
//   String? _currentAddress;
//
//   @override
//   void initState() {
//     super.initState();
//     _getCurrentLocation();
//   }
//
//   Future<void> _getCurrentLocation() async {
//     await Permission.location.request();
//
//     if (await Permission.location.isGranted) {
//       Position position = await Geolocator.getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.high);
//       setState(() {
//         _currentPosition = position;
//         curretnpositionx = position.latitude;
//         curretnpositiony = position.longitude;
//       });
//       try {
//         List<Placemark> placemarks = await placemarkFromCoordinates(
//             position.latitude, position.longitude);
//         Placemark? place = placemarks[0];
//         setState(() {
//           _currentAddress = "${place?.locality}, ${place?.country}";
//           countrylocation = place!.country!;
//           statelocation = place.locality!;
//         });
//       } catch (e) {
//         // Handle error
//       }
//     } else {
//       // Handle permission denied scenario
//     }
//   }
//
//   final List<Widget> _screens = [
//     StarlinkScreen(),
//     const LiveMapScreen(),
//     const HelpScreen(),
//   ];
//
//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _screens[_selectedIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         items: const <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.map),
//             label: 'Live Map',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.help),
//             label: 'Help',
//           ),
//         ],
//         currentIndex: _selectedIndex,
//         selectedItemColor: Colors.blue,
//         onTap: _onItemTapped,
//       ),
//     );
//   }
// }
//
// class StarlinkScreen extends StatefulWidget {
//   @override
//   StarlinkScreenState createState() => StarlinkScreenState();
// }
//
// class StarlinkScreenState extends State<StarlinkScreen> {
//   final TextEditingController countryCont = TextEditingController();
//   final TextEditingController stateCont = TextEditingController();
//   final TextEditingController cityCont = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text('Select your location',
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 20),
//             CountryStateCityPicker(
//                 country: countryCont,
//                 state: stateCont,
//                 city: cityCont,
//                 dialogColor: Colors.grey.shade200,
//                 textFieldDecoration: const InputDecoration(
//                     suffixIcon: Icon(Icons.arrow_drop_down_outlined),
//                     border: OutlineInputBorder())),
//             ElevatedButton(
//               onPressed: () async {
//                 FocusScope.of(context).requestFocus(FocusNode());
//                 if (countryCont != null &&
//                     stateCont != null &&
//                     cityCont != null) {
//                   try {
//                     var coordinates = await fetchCoordinates(cityCont.text);
//                     Navigator.of(context).push(
//                       MaterialPageRoute(
//                         builder: (context) => SatelliteList(
//                           latitude: coordinates['lat'] ?? 0.0,
//                           longitude: coordinates['lng'] ?? 0.0,
//                         ),
//                       ),
//                     );
//                   } catch (e) {
//                     // Handle error
//                   }
//                 } else {
//                   if (cityCont.text.isNotEmpty) {
//                     Fluttertoast.showToast(
//                       msg: "Please select a valid city",
//                       toastLength: Toast.LENGTH_SHORT,
//                       gravity: ToastGravity.BOTTOM,
//                       timeInSecForIosWeb: 1,
//                       backgroundColor: Colors.black,
//                       textColor: Colors.white,
//                       fontSize: 14.0,
//                     );
//                   } else {
//                     Fluttertoast.showToast(
//                       msg: "Please enter a city",
//                       toastLength: Toast.LENGTH_SHORT,
//                       gravity: ToastGravity.BOTTOM,
//                       timeInSecForIosWeb: 1,
//                       backgroundColor: Colors.black,
//                       textColor: Colors.white,
//                       fontSize: 14.0,
//                     );
//                   }
//                 }
//               },
//               child: const Text('FIND VISIBLE TIMES'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Future<Map<String, dynamic>> fetchCoordinates(String city) async {
//     GeoCode geoCode = GeoCode();
//     try {
//       Coordinates coordinates = await geoCode.forwardGeocoding(address: city);
//       print("Latitude: ${coordinates.latitude}");
//       print("Longitude: ${coordinates.longitude}");
//       return {'lat': coordinates.latitude, 'lng': coordinates.longitude};
//     } catch (e) {
//       print(e);
//     }
//     return {'lat': 0.0, 'lng': 0.0};
//   }
// }
