import 'dart:math';
import 'package:flutter/material.dart';
import 'package:laravel_test_api/provider/location_provider.dart';
import 'package:laravel_test_api/screens/location_details_screen.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationScreen extends StatefulWidget {
  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  Location location = Location();
  LocationData? _locationData;

  @override
  void initState() {
    super.initState();
    getLoc();
    final myState = Provider.of<LocationProvider>(context, listen: false);
    myState.reset();
  }

  Future<void> getLoc() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    print(_locationData?.latitude); // Print the user's latitude
    print(_locationData?.longitude); // Print the user's longitude

    setState(() {
      // After fetching the location data, update the widget's state to rebuild it
    });
  }

  @override
  Widget build(BuildContext context) {
    final serviceProvider = Provider.of<LocationProvider>(context);

    double calculateDistance(double userLat, double userLong, double serviceLat,
        double serviceLong) {
      if (_locationData == null) {
        // Handle the case where user location data is not available
        return 0.0;
      }

      const double earthRadius = 6371.0; // Radius of the Earth in kilometers
      final double lat1Rad =
          _locationData!.latitude! * (3.141592653589793 / 180);
      final double long1Rad =
          _locationData!.longitude! * (3.141592653589793 / 180);
      final double lat2Rad = serviceLat * (3.141592653589793 / 180);
      final double long2Rad = serviceLong * (3.141592653589793 / 180);

      final double latDiff = lat2Rad - lat1Rad;
      final double longDiff = long2Rad - long1Rad;

      final double a = (sin(latDiff / 2) * sin(latDiff / 2)) +
          (cos(lat1Rad) * cos(lat2Rad) * sin(longDiff / 2) * sin(longDiff / 2));
      final double c = 2 * atan2(sqrt(a), sqrt(1 - a));
      final double distance = earthRadius * c;

      return distance;
    }

    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            onChanged: (query) => serviceProvider.filterServices(query),
            decoration: const InputDecoration(
              labelText: 'Search Services',
              prefixIcon: Icon(Icons.search),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: serviceProvider.services.length,
            itemBuilder: (context, index) {
              final service = serviceProvider.services[index];

              final distance = calculateDistance(_locationData?.latitude ?? 0.0,
                  _locationData?.longitude ?? 0.0, service.lat, service.long);

              return Card(
                  color: Colors.white,
                  elevation: 10,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: const Icon(
                          Icons.location_on,
                          color: Colors.green,
                          textDirection: TextDirection.ltr,
                        ),
                        title: Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            service.content,
                            style: const TextStyle(
                              fontStyle: FontStyle.italic,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text(
                                "OPEN",
                                style: TextStyle(color: Colors.green),
                              ),
                            ),
                            const Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: const Text("Opens Hours: 8pm - 6pm"),
                            ),
                            const Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: const Text("Days Open: Monday to Friday"),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 5, bottom: 10),
                              child: Text(
                                  "Distance: ${distance.toStringAsFixed(2)} Km"),
                            ),
                          ],
                        ),
                        hoverColor: Colors.green[300],
                        onTap: () {
                          // Create a LatLng for the service's location
                          LatLng serviceLatLng =
                              LatLng(service.lat, service.long);
                          // Navigate to the service detail screen when tapped
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LocationDetailScreen(
                                serviceName: service.content,
                                serviceLocation: serviceLatLng,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ));
            },
          ),
        ),
      ],
    );
  }
}
