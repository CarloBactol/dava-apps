import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:laravel_test_api/models/services.dart';
import 'package:laravel_test_api/services/services_services.dart';

class HomeUtil extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<ServiceModel>>(
        future: fetchServices(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: SpinKitCircle(color: Colors.blue));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final services = snapshot.data;
            return Column(children: [
              const ListTile(
                title: Center(
                  child: Text(
                    'Overview of Services',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: services!.length,
                  itemBuilder: (ctx, int index) {
                    final service = services[index];
                    return CourseCard(service: service);
                  },
                ),
              )
            ]);
          }
        },
      ),
    );
  }

  Future<List<ServiceModel>> fetchServices() async {
    final res = await ServiceApi.fetchService();
    return res;
  }
}

class CourseCard extends StatelessWidget {
  final ServiceModel service;

  const CourseCard({required this.service});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Handle card click here, e.g., navigate to a detailed view
        // You can use Navigator for navigation, for example:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => CourseDetailPage(services: service),
        ));
      },
      child: Card(
        color: Colors.blue[100],
        margin: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: AssetImage('assets/avatar.png'),
            backgroundColor: Colors.blue[200],
          ),
          title: Text(service.name),
          // You can add more widgets here as needed
        ),
      ),
    );
  }
}

class CourseDetailPage extends StatelessWidget {
  final ServiceModel services;
  CourseDetailPage({required this.services});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(services.name),
      ),
      body: Card(
        margin: EdgeInsets.all(10.0),
        elevation: 10,
        color: Colors.blue[100],
        child: ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.blue[200],
              backgroundImage: const AssetImage('assets/avatar.png'),
            ),
          ),
          title: Text(
            services.name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
            ),
          ),
          subtitle: Padding(
            padding:
                const EdgeInsets.only(left: 0, right: 0, top: 10, bottom: 10),
            child: Text(services.description),
          ),
          // You can add more widgets here as needed
        ),
      ),
    );
  }
}
