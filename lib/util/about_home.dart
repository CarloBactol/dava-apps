import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // About DAVA
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'About DAVA',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'DAVA is not just a veterinary service; it\'s a community dedicated to the well-being '
                        'of your pets. Our team of passionate and skilled professionals is committed to providing '
                        'modern and compassionate care. With a focus on pet welfare and community engagement, '
                        'we aim to create a positive impact in every pet owner\'s life.',
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),

              // Our Team
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Our Team',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Meet our team of experienced veterinarians and support staff. '
                        'Each member is dedicated to delivering the highest standards of care '
                        'and ensuring the comfort and health of your beloved pets.',
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),

              // Community Engagement
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Community Engagement',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'DAVA actively engages with the community to promote responsible pet ownership. '
                        'We conduct educational workshops, participate in local events, and support '
                        'animal welfare initiatives. By working together with the community, we strive '
                        'to create a nurturing environment for pets and their owners.',
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),

              // Why Choose DAVA?
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Why Choose DAVA?',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8),
                      Text(
                        '✓ Modern Services: Utilizing the latest technologies for accurate diagnostics and treatment.',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        '✓ Fast Service Delivery: We value your time and aim for prompt and efficient care.',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        '✓ High Ratings: Trusted by pet owners with consistently positive feedback.',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),

              // User Feedback
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text(
                        'User Feedback',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey),
                        ),
                        padding: EdgeInsets.all(16),
                        child: const Column(
                          children: [
                            Text(
                              '⭐⭐⭐⭐⭐',
                              style: TextStyle(fontSize: 24),
                            ),
                            Text(
                              'Amazing service! Our dog received the best care from DAVA. '
                              'The staff is friendly, and the facilities are top-notch. Highly recommend!',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),

              // Contact Us
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Contact us:',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Email: info@dava.com',
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        'Phone: +1 234 567 890',
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
