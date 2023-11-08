import 'package:flutter/material.dart';
import 'package:laravel_test_api/screens/map.dart';
import 'package:laravel_test_api/services/mapping_services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LocationWidget extends StatefulWidget {
  const LocationWidget({super.key});

  @override
  State<LocationWidget> createState() => _LocationWidgetState();
}

class _LocationWidgetState extends State<LocationWidget> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: fetchDataServices(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SpinKitCircle(color: Colors.blue); // Loading indicator
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          // Display data in ListView
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return Card(
                elevation: 10,
                color: Colors.blue[100],
                child: ListTile(
                  title: Text(snapshot.data![index]['address']),
                  leading: Icon(
                    Icons.maps_home_work_rounded,
                    color: Colors.blue[400],
                    size: 30.0,
                  ),
                  subtitle: Text(
                    snapshot.data![index]['content'] ?? '',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                      color: Colors.green,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MapScreen(
                          latitude: double.parse(snapshot.data![index]['lat']),
                          longitude:
                              double.parse(snapshot.data![index]['long']),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        }
      },
    );
  }
}
