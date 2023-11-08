import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:laravel_test_api/models/fc_animal.dart';
import 'package:laravel_test_api/services/fc_animal_services.dart';
import 'package:intl/intl.dart';

class AnimalUtil extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Animals>>(
        future: fetchAnimalFunction(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: SpinKitCircle(color: Colors.blue));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final animal = snapshot.data;
            return Column(children: [
              const ListTile(
                title: Center(
                  child: Text(
                    'Your Pets List',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: animal!.length,
                  itemBuilder: (ctx, int index) {
                    final pets = animal[index];
                    return AnimalCard(animal: pets);
                  },
                ),
              )
            ]);
          }
        },
      ),
    );
  }

  Future<List<Animals>> fetchAnimalFunction() async {
    final res = await FCUserAnimals.fetchAnimal();
    return res;
  }
}

class AnimalCard extends StatelessWidget {
  final Animals animal;

  const AnimalCard({required this.animal});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Handle card click here, e.g., navigate to a detailed view
        // You can use Navigator for navigation, for example:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => CourseDetailPage(animal: animal),
        ));
      },
      child: Card(
        elevation: 5,
        color: Colors.blue[100],
        margin: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
        child: ListTile(
          leading: const CircleAvatar(
            backgroundImage: AssetImage('assets/dog.jpg'),
          ),
          title: Text(
            '${animal.name} - ${animal.owner.ownerEmail}',
            style: const TextStyle(
              fontStyle: FontStyle.italic,
            ),
          ),
          // You can add more widgets here as needed
        ),
      ),
    );
  }
}

class CourseDetailPage extends StatelessWidget {
  final Animals animal;

  CourseDetailPage({required this.animal});

  @override
  Widget build(BuildContext context) {
    final inputDate = animal.dateOfBirth;
    final parsedDate = DateTime.parse(inputDate);

    final formattedDate = DateFormat.yMMMMd('en_US').format(parsedDate);
    return Scaffold(
      appBar: AppBar(
        title: Text(animal.name),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Card(
          elevation: 10,
          color: Colors.blue[100],
          child: Column(
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10),
                    const CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage(
                          'assets/dog.jpg'), // Add your profile picture asset
                    ),
                    const SizedBox(height: 20),
                    Text(
                      '${animal.name} ', // Replace with the user's name
                      style: const TextStyle(
                          fontSize: 20,
                          color: Color.fromARGB(255, 6, 200, 226),
                          fontStyle: FontStyle.italic),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'Breed: ${animal.breed}', // Replace with user's description
                          style: const TextStyle(
                            fontSize: 15,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        Text(
                          'Species: ${animal.species}', // Replace with user's description
                          style: const TextStyle(
                            fontSize: 15,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'Gender: ${animal.gender}', // Replace with user's description
                          style: const TextStyle(
                            fontSize: 15,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        Text(
                          'Color: ${animal.color}', // Replace with user's description
                          style: const TextStyle(
                            fontSize: 15,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'Date of Birth: $formattedDate',
                          style: const TextStyle(
                            fontSize: 15,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Medical Records",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20,
                        fontStyle: FontStyle.italic,
                        color: Colors.cyan),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              CardMedRecord(animal: animal),
            ],
          ),
        ),
      ),
    );
  }
}

class CardMedRecord extends StatelessWidget {
  const CardMedRecord({
    super.key,
    required this.animal,
  });

  final Animals animal;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: animal.medicalRecords.length,
        itemBuilder: (context, index) {
          final med = animal.medicalRecords[index];
          final inputDate = med.createdAt;
          final parsedDate = DateTime.parse(inputDate);
          final formattedDate = DateFormat.yMMMMd('en_US').format(parsedDate);
          return Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: Card(
                        elevation: 5,
                        color: Colors.cyan,
                        margin: const EdgeInsets.all(5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 10,
                                top: 5,
                              ),
                              child: Text(
                                'Veterinary: ${med.veterinarian.veterinarianEmail.toUpperCase()}',
                                textAlign: TextAlign.start,
                                style: const TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10, top: 10),
                              child: Text(
                                'Procedure: ${med.procedure.toUpperCase()}',
                                textAlign: TextAlign.start,
                                style: const TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 10,
                                top: 5,
                              ),
                              child: Text(
                                'Procedure Type: ${med.typeOfProcedure.toUpperCase()}',
                                textAlign: TextAlign.start,
                                style: const TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 10,
                                top: 5,
                              ),
                              child: Text(
                                'Cost: ${med.cost} PHP',
                                textAlign: TextAlign.start,
                                style: const TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 10,
                                top: 5,
                                bottom: 10,
                              ),
                              child: Text(
                                'Date Confined: ${formattedDate}',
                                textAlign: TextAlign.start,
                                style: const TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        )),
                  ),
                ],
              )
            ],
          );
        },
      ),
    );
  }
}
