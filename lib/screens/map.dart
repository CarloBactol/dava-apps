import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  final double latitude;
  final double longitude;

  MapScreen({required this.latitude, required this.longitude});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapping'),
      ),
      body: FutureBuilder(
        future: _initializeMap(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                target: LatLng(widget.latitude, widget.longitude),
                zoom: 12,
              ),
              onMapCreated: (GoogleMapController controller) {
                _mapController = controller;
              },
              markers: {
                Marker(
                  markerId: MarkerId('selected_location'),
                  position: LatLng(widget.latitude, widget.longitude),
                ),
              },
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Future<void> _initializeMap() async {
    // Add any necessary initialization code here.
    await Future.delayed(
        Duration(seconds: 1)); // Simulate some initialization process.
  }
}
