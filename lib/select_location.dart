import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocode/geocode.dart';
import 'model/city_model.dart';
import 'model/country_model.dart';
import 'model/satate_model.dart';

class StarlinkScreen extends StatefulWidget {
  @override
  StarlinkScreenState createState() => StarlinkScreenState();
}

class StarlinkScreenState extends State<StarlinkScreen> {
  final TextEditingController countryCont = TextEditingController();
  final TextEditingController stateCont = TextEditingController();
  final TextEditingController cityCont = TextEditingController();

  List<CountryModel> _countryList = [];
  List<StateModel> _stateList = [];
  List<CityModel> _cityList = [];

  String? _selectedCountry;
  String? _selectedState;
  String? _selectedCity;

  @override
  void initState() {
    super.initState();
    _getCountry();
  }

  Future<void> _getCountry() async {
    var jsonString = await rootBundle
        .loadString('packages/country_state_city_pro/assets/country.json');
    List<dynamic> body = json.decode(jsonString);
    setState(() {
      _countryList = body.map((dynamic item) => CountryModel.fromJson(item)).toList();
    });
  }

  Future<void> _getState(String countryId) async {
    var jsonString = await rootBundle
        .loadString('packages/country_state_city_pro/assets/state.json');
    List<dynamic> body = json.decode(jsonString);
    setState(() {
      _stateList = body.map((dynamic item) => StateModel.fromJson(item))
          .where((state) => state.countryId == countryId)
          .toList();
    });
  }

  Future<void> _getCity(String stateId) async {
    var jsonString = await rootBundle
        .loadString('packages/country_state_city_pro/assets/city.json');
    List<dynamic> body = json.decode(jsonString);
    setState(() {
      _cityList = body.map((dynamic item) => CityModel.fromJson(item))
          .where((city) => city.stateId == stateId)
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            foregroundColor: Colors.white,
            backgroundColor: Colors.black,
            title: Text("Select Your Location",
                style: TextStyle(
                    fontSize: 50.sp,
                    fontFamily: "Lexend",
                    color: Color(0xFFFFFFFF)))),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          color: Colors.black,
          child: Column(
            children: [
              SizedBox(height: 50.h,),
              Container(
                width: 850.w,
                height: 150.h,
                decoration: BoxDecoration(
                  // color: Colors.white,
                    borderRadius: BorderRadius.circular(55)
                ),
                child: Image.asset("assets/location_by_coordinates/by_coordinates_unpressed.png",fit: BoxFit.cover),
              ),
              SizedBox(height: 80.h,),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  height: 800.h,
                  width:  750.h,
                  child: Stack(
                    children: [
                      Image.asset("assets/location_by_coordinates/popup_text_bg.png"),
                      Column(
                        children: [
                          SizedBox(height: 50.h,),
                          Padding(
                            padding: const EdgeInsets.only(left: 25.0, top: 25),
                            child: Row(
                              children: [
                                Text("Country:", style: TextStyle(
                                    fontSize: 40.sp,
                                    fontFamily: "Lexend",
                                    color: Color(0xFFFFFFFF))),
                                SizedBox(width: 50.w,),
                                Stack(
                                  children: [
                                    Image.asset("assets/location_by_name/type_bg.png",width: 600.w,height: 300.h,),
                                  ],
                                ),
                               /* DropdownButton<String>(
                                  isExpanded: true,
                                  hint: Text("Select Country", style: TextStyle(color: Colors.white)),
                                  value: _selectedCountry,
                                  items: _countryList.map((CountryModel country) {
                                    return DropdownMenuItem<String>(
                                      value: country.id,
                                      child: Text(country.name),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedCountry = value;
                                      _selectedState = null;
                                      _selectedCity = null;
                                      _stateList.clear();
                                      _cityList.clear();
                                      _getState(value!);
                                    });
                                  },
                                ),*/
                              ],
                            ),
                          ),

                          SizedBox(height: 20.h,),
                          if (_stateList.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(left: 25.0, top: 25),
                              child: Row(
                                children: [
                                  Text("State:", style: TextStyle(
                                      fontSize: 40.sp,
                                      fontFamily: "Lexend",
                                      color: Color(0xFFFFFFFF))),
                                ],
                              ),
                            ),
                          if (_stateList.isNotEmpty)
                            DropdownButton<String>(
                              isExpanded: true,
                              hint: Text("Select State", style: TextStyle(color: Colors.white)),
                              value: _selectedState,
                              items: _stateList.map((StateModel state) {
                                return DropdownMenuItem<String>(
                                  value: state.id,
                                  child: Text(state.name),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedState = value;
                                  _selectedCity = null;
                                  _cityList.clear();
                                  _getCity(value!);
                                });
                              },
                            ),
                          SizedBox(height: 20.h,),
                          if (_cityList.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(left: 25.0, top: 25),
                              child: Row(
                                children: [
                                  Text("City:", style: TextStyle(
                                      fontSize: 40.sp,
                                      fontFamily: "Lexend",
                                      color: Color(0xFFFFFFFF))),
                                ],
                              ),
                            ),
                          if (_cityList.isNotEmpty)
                            DropdownButton<String>(
                              isExpanded: true,
                              hint: Text("Select City", style: TextStyle(color: Colors.white)),
                              value: _selectedCity,
                              items: _cityList.map((CityModel city) {
                                return DropdownMenuItem<String>(
                                  value: city.id,
                                  child: Text(city.name),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedCity = value;
                                });
                              },
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }

  Future<Map<String, dynamic>> fetchCoordinates(String city) async {
    GeoCode geoCode = GeoCode();
    try {
      Coordinates coordinates = await geoCode.forwardGeocoding(address: city);
      print("Latitude: ${coordinates.latitude}");
      print("Longitude: ${coordinates.longitude}");
      return {'lat': coordinates.latitude, 'lng': coordinates.longitude};
    } catch (e) {
      print(e);
    }
    return {'lat': 0.0, 'lng': 0.0};
  }
}
