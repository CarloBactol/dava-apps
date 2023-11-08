import 'package:flutter/material.dart';
import 'package:laravel_test_api/screens/animal.dart';
import '../models/api_response.dart';
import '../models/profile_model.dart';
import '../services/api_service.dart';

class ProfileScreen extends StatefulWidget {
  final ApiService apiService;

  ProfileScreen({required this.apiService});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<Profile> _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = widget.apiService.fetchProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Profile>(
        future: _profileFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.data == null) {
            return Center(child: Text('No profile data available'));
          } else {
            final profile = snapshot.data!;
            ApiResponse response = ApiResponse();
            response.email = profile.email;
            return ProfileDashboard(
              name: profile.name,
              email: profile.email,
            );
          }
        },
      ),
    );
  }
}

class ProfileDashboard extends StatelessWidget {
  final String name;
  final String email;

  ProfileDashboard({
    required this.name,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      verticalDirection: VerticalDirection.down,
      children: [
        Card(
          color: Colors.grey[300],
          elevation: 8.0,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            height: 150,
            width: 350,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage('assets/person.jpg'),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 8),
                          width: 150,
                          color: Colors.black54,
                          height: 2,
                        ),
                        const SizedBox(height: 4),
                        Text(email.toLowerCase()),
                        Text(name.toUpperCase()),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        ElevatedButton.icon(
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const AnimalsScreen()));
          },
          icon: const Icon(
            Icons.pets_rounded,
            size: 20,
          ),
          label: const Text('Your Pets..'),
        )
      ],
    );
  }
}
