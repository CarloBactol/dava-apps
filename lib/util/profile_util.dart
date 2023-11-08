import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:laravel_test_api/models/user_profile.dart';
import 'package:laravel_test_api/screens/animal.dart';
import 'package:laravel_test_api/services/user_profile_services.dart';

class ProfileUtil extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<UserProfile>(
        future: fetchUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: SpinKitCircle(color: Colors.blue));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final profile = snapshot.data;
            return ProfileCard(
              firstName: profile!.firstName,
              lastName: profile.lastName,
              email: profile.email,
            );
          }
        },
      ),
    );
  }

  Future<UserProfile> fetchUser() async {
    final res = await UserProfileApi.fetchProfileApi();
    return res;
  }
}

class ProfileCard extends StatelessWidget {
  final String firstName;
  final String lastName;
  final String email;

  ProfileCard({
    required this.firstName,
    required this.lastName,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 3,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 70,
            backgroundImage:
                AssetImage('assets/logo-get.png'), // Add your image asset here
          ),
          const SizedBox(height: 10),
          Text(
            '${firstName} ${lastName}',
            style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic),
          ),
          const SizedBox(height: 10),
          Text(
            'Email: ${email}',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                label: const Text('Your Pets Details'),
                icon: Icon(Icons.catching_pokemon),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const AnimalsScreen()));
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
