import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;

class SatelliteList extends StatefulWidget {
  final double latitude;
  final double longitude;

  SatelliteList({Key? key, required this.latitude, required this.longitude})
      : super(key: key);

  @override
  State<SatelliteList> createState() => _SatelliteListState();
}

class _SatelliteListState extends State<SatelliteList> {
  List<dynamic> _starlinkData = [];
  bool _isLoading = true;
  String? _address;
  String? sunrise;
  String? sunset;

  @override
  void initState() {
    super.initState();
    fetchStarlinkData();
    fetchAddress();
  }

  Future<void> fetchStarlinkData() async {
    final url = Uri.parse(
      'https://api.findstarlink.com/v1.1/findstarlink?latitude=${widget.latitude}&longitude=${widget.longitude}&numDays=5&client=new_v2_android',
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      print('JSON response: $jsonResponse');
      if (jsonResponse is Map<String, dynamic> &&
          jsonResponse.containsKey('timings')) {
        setState(() {
          _starlinkData = jsonResponse['timings'];
          sunrise = jsonResponse['sunrise'];
          sunset = jsonResponse['sunset'];
          _isLoading = false;
        });
      } else {
        throw Exception('Unexpected JSON format');
      }
    } else {
      print('Failed to load Starlink data: ${response.statusCode}');
      print('Response body: ${response.body}');
      setState(() {
        _isLoading = false;
      });
      throw Exception('Failed to load Starlink data');
    }
  }

  Future<void> fetchAddress() async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(widget.latitude, widget.longitude);
      Placemark place = placemarks.first;
      setState(() {
        _address =
            "${place.locality}, ${place.administrativeArea}, ${place.country}";
      });
    } catch (e) {
      print('Failed to get address: $e');
      setState(() {
        _address = 'Unknown location';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('StarLink Pass Times'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(
              textAlign: TextAlign.left,
              _address ?? 'Fetching address...',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(
              textAlign: TextAlign.start,
              "Sunrise:${sunrise} Sunset:${sunset}",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Expanded(
                  child: ListView.builder(
                    itemCount: _starlinkData.length,
                    itemBuilder: (context, index) {
                      final item = _starlinkData[index];
                      double startElev = item['startElev'];
                      double maxElev = item['maxElev'];
                      double endElev = item['endElev'];
                      double startDir = item['startDir'];
                      double endDir = item['endDir'];
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${item['start']['time']} , ${item['start']['date']}',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text("${item['title']}"),
                              Row(
                                children: [
                                  Text.rich(
                                    TextSpan(
                                      children: [
                                        const TextSpan(text: "Look From "),
                                        TextSpan(
                                          text: "${item['startDirText']}"
                                              .toUpperCase(),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13),
                                        ),
                                        TextSpan(text: "(${startDir.round()}\u00B0) to "),
                                        TextSpan(
                                          text: "${item['endDirText']} "
                                              .toUpperCase(),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13),
                                        ),
                                        TextSpan(text: "(${endDir.round()}\u00B0)"),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                "Elevation (from horizon):start ${startElev.round()}\u00B0,max:${maxElev.round()}\u00B0,end:${endElev.round()}\u00B0",
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
