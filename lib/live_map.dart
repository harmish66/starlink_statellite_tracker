import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(LiveMapScreen());
}

class LiveMapScreen extends StatefulWidget {
  const LiveMapScreen({Key? key}) : super(key: key);

  @override
  State<LiveMapScreen> createState() => _LiveMapScreenState();
}

class _LiveMapScreenState extends State<LiveMapScreen> {
  late GoogleMapController mapController;
  final Set<Polyline> _polylines = {};
  final Set<Marker> _markers = {};
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _fetchSatelliteData();
    _timer = Timer.periodic(
        Duration(seconds: 10), (Timer t) => _fetchSatelliteData());
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<void> _fetchSatelliteData() async {
    final response = await http.get(Uri.parse(
        'https://api.findstarlink.com/v1/findstarlinkpath?client=new_v2_android'));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);

      _polylines.clear();
      _markers.clear();

      data.forEach((satelliteId, satelliteData) async {
        var polylineCoordinates = <LatLng>[];
        for (var coord in satelliteData['path']) {
          polylineCoordinates.add(LatLng(coord[0], coord[1]));
        }

        _polylines.add(Polyline(
          polylineId: PolylineId(satelliteId),
          visible: true,
          points: polylineCoordinates,
          color: _getColor(satelliteId),
          width: 2,
        ));

        var markerPosition = polylineCoordinates.last;
        final BitmapDescriptor customIcon =
            await BitmapDescriptor.fromAssetImage(
          ImageConfiguration(size: Size(1, 1)),
          'assets/satellite.png', // Path ```to your custom icon
        );
        _markers.add(Marker(
          // icon: customIcon,
          markerId: MarkerId(satelliteId),
          position: markerPosition,
          infoWindow: InfoWindow(
            title: satelliteData['title'],
          ),
        ));
      });

      setState(() {});
    } else {
      throw Exception('Failed to load satellite data');
    }
  }

  Color _getColor(String satelliteId) {
    return Colors.primaries[satelliteId.hashCode % Colors.primaries.length];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Starlink Tracker'),
      ),
      body: GoogleMap(
        onMapCreated: (controller) {
          mapController = controller;
        },
        initialCameraPosition: CameraPosition(
          target: LatLng(0, 0),
          zoom: 0.5,
        ),
        polylines: _polylines,
        markers: _markers,
      ),
    );
  }
}
