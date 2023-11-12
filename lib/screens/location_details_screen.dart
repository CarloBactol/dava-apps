import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:laravel_test_api/screens/booking.dart';
import 'package:url_launcher/url_launcher.dart';

class LocationDetailScreen extends StatelessWidget {
  final String serviceName;
  final String serviceBranch;
  final String isOpen;
  final LatLng serviceLocation;

  LocationDetailScreen({
    required this.serviceName,
    required this.serviceLocation,
    required this.isOpen,
    required this.serviceBranch,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Service Details'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('Service Name: $serviceName'),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              child: GoogleMap(
                trafficEnabled: true,
                initialCameraPosition: CameraPosition(
                  target: serviceLocation,
                  zoom: 14,
                ),
                markers: <Marker>{
                  Marker(
                    markerId: MarkerId('serviceMarker'),
                    position: serviceLocation,
                  ),
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              onPressed: () {
                _launchMap(serviceLocation);
              },
              icon: Icon(Icons.location_history),
              label: const Text('Show route'),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the booking page with parameters
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BookingScreen(
                serviceName: serviceName,
                serviceLocation: serviceLocation,
                serviceBranch: serviceBranch,
                isOpen: isOpen,
              ),
            ),
          );
        },
        child: Icon(Icons.book),
      ),
    );
  }

  void _launchMap(LatLng destination) async {
    final url =
        'https://www.google.com/maps/dir/?api=1&destination=${destination.latitude},${destination.longitude}';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
