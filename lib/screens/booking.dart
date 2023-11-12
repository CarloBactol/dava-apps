import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:laravel_test_api/provider/booking_provider.dart';
import 'package:laravel_test_api/screens/home1.dart';
import 'package:laravel_test_api/services/user_services.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class BookingScreen extends StatefulWidget {
  final String serviceName;
  final String serviceBranch;
  final LatLng serviceLocation;
  final String isOpen;

  BookingScreen({
    super.key,
    required this.serviceName,
    required this.serviceBranch,
    required this.serviceLocation,
    required this.isOpen,
  });

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  String selectedService = "Walk-in";
  String selectedLocation = "";
  DateTime selectedDateTime = DateTime.now();
  bool isTimeValid = false;

  String? selectedTimeSlot;
  String? isOpen;
  bool isButtonEnabled = false;

  List<String> availableTimeSlots = [];

  // Function to fetch and update available time slots
  Future<void> updateAvailableTimeSlots(DateTime selectedDate) async {
    List<String> timeSlots = await fetchAvailableTimeSlots(selectedDate);
    setState(() {
      availableTimeSlots = timeSlots;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bookingProvider = Provider.of<BookingProvider>(context);
    return ChangeNotifierProvider(
      create: (context) => BookingProvider(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Book a Veterinary Service'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Consumer<BookingProvider>(
              builder: (context, bookingProvider, _) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Service Name: ${widget.serviceName}',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Branch: ${widget.serviceBranch}',
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${widget.isOpen == '1' ? 'Open' : 'Close'} now',
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 16),
                    DropdownButton<String>(
                      value: selectedService,
                      onChanged: (String? newValue) {
                        setState(() {
                          isOpen = widget.isOpen;
                          selectedService = newValue!;
                          updateButtonEnabledStatus();
                        });
                      },
                      items: ["Walk-in", "Home Services"]
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    if (selectedService == "Home Services") ...[
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: const InputDecoration(
                            labelText: 'Enter Your Address'),
                        onChanged: (value) {
                          setState(() {
                            selectedLocation = value;
                            isOpen = widget.isOpen;
                            updateButtonEnabledStatus();
                          });
                        },
                      ),
                    ],
                    const SizedBox(height: 16),
                    const Text('Select Date and Time:'),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () async {
                        DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: selectedDateTime,
                          firstDate: DateTime.now(),
                          lastDate:
                              DateTime.now().add(const Duration(days: 30)),
                        );
                        if (picked != null && picked != selectedDateTime) {
                          await bookingProvider.fetchServices();

                          setState(() {
                            selectedDateTime = picked;
                            updateAvailableTimeSlots(
                                selectedDateTime); // Fetch available time slots
                            updateButtonEnabledStatus();
                            validateSelectedTime();
                          });
                        }
                      },
                      child: const Text('Pick Date'),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () async {
                        TimeOfDay? picked = await showTimePicker(
                          useRootNavigator: false,
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (picked != null) {
                          DateTime selectedTime = DateTime(
                            selectedDateTime.year,
                            selectedDateTime.month,
                            selectedDateTime.day,
                            picked.hour,
                            picked.minute,
                          );
                          String formattedTime = picked.format(context);
                          selectedDateTime = selectedTime;
                          selectedTimeSlot = formattedTime;
                          print(formattedTime);
                          updateButtonEnabledStatus();
                          validateSelectedTime();
                        }
                      },
                      child: const Text('Pick Time'),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Selected Date and Time: ${selectedDateTime.toLocal()}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    if (selectedTimeSlot != null) ...[
                      const SizedBox(height: 16),
                      Text(
                        'Selected Time Slot: $selectedTimeSlot',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                    const SizedBox(height: 16),
                    // Display validation message
                    // if (selectedTimeSlot != null && !isTimeValid) ...[
                    //   const SizedBox(height: 8),
                    //   const Text(
                    //     'Selected time is not available. Please choose a different time.',
                    //     style: TextStyle(color: Colors.red),
                    //   ),
                    // ],
                    // const SizedBox(height: 16),
                    // const Text(
                    //   'Available Time Slots:',
                    //   style:
                    //       TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    // ),
                    const SizedBox(height: 16),

                    // Display available time slots
                    // Column(
                    //   children: availableTimeSlots
                    //       .map((timeSlot) => Text(
                    //             timeSlot,
                    //             style: const TextStyle(fontSize: 16),
                    //           ))
                    //       .toList(),
                    // ),

                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: isButtonEnabled ? () => handleBooking() : null,
                      child: const Text('Confirm Booking'),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void updateButtonEnabledStatus() {
    setState(() {
      isButtonEnabled = (selectedService == "Walk-in" && isOpen == "1") ||
          (selectedService == "Home Services" &&
              selectedLocation.isNotEmpty &&
              isOpen == "1");
    });
  }

  void handleBooking() {
    // Get the values for booking
    String serviceName = widget.serviceName;
    LatLng serviceLocation = widget.serviceLocation;
    String serviceBranch = widget.serviceBranch;
    String selectedService = this.selectedService;
    String selectedLocation = this.selectedLocation;
    DateTime selectedDateTime = this.selectedDateTime;

    // Perform the booking logic using the obtained values
    // Example: Print the values, you can replace this with your actual booking logic
    print('Service Name: $serviceName');
    print('Service Branch: $serviceBranch');
    print('Service Location: $serviceLocation');
    print('Selected Service: $selectedService');
    print('Selected Location: $selectedLocation');
    print('Selected Date and Time: $selectedDateTime');

    // Add your logic to proceed with the booking here
    postBooking(serviceBranch, serviceName, selectedDateTime.toString(),
        selectedService, selectedLocation);
  }

  // Replace this with actual backend integration
  Future<List<String>> fetchAvailableTimeSlots(DateTime selectedDate) async {
    // Simulated API call or database query
    await Future.delayed(Duration(seconds: 0));
    // Return a list of available time slots (replace this with your actual logic)
    return ["9:00 AM", "10:00 AM", "11:00 AM", "2:00 PM", "3:00 PM"];
  }

  // Function to validate selected time against available time slots
  void validateSelectedTime() {
    if (selectedTimeSlot != null &&
        availableTimeSlots.contains(selectedTimeSlot)) {
      setState(() {
        isTimeValid = true;
      });
    } else {
      setState(() {
        isTimeValid = false;
      });
    }
  }

  Future<void> postBooking(String branch, String services, String appointment,
      String serviceType, String address) async {
    DateTime dateTime = DateTime.parse(appointment);
    // String formattedDateTime = DateFormat('').format(dateTime);
    final email = await getUserEmail();
    print(email);
    String formattedDateTime =
        DateFormat('yyyy-dd-MM kk:mm:ss').format(dateTime);
    print(formattedDateTime);
    const apiUrl =
        'https://davs-apps-150658629956.herokuapp.com/api/post_bookings';
    final response = await http.post(Uri.parse(apiUrl), headers: {
      "Accept": "application/json",
    }, body: {
      "branch": branch,
      "services": services,
      "appointment": formattedDateTime,
      "type": serviceType,
      "email": email,
      "address": address,
    });
    if (response.statusCode == 200) {
      print('Succcess');
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => BottomNavigationApp(),
          ),
          (route) => false);
      final message = jsonDecode(response.body)['message'];
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //   content: Text(message),
      // ));
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Successfully',
                style: TextStyle(color: Colors.green)),
            content: const Text(
                'Your book is being processed. Please wait for the completion of the process.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      print(formattedDateTime);
      final error = jsonDecode(response.body)['errors'];
      print(error);
      if (error != null) {
        final errorMessage = error[error.keys.elementAt(0)][0];
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(errorMessage),
        ));
        print('Failed to load services');
      }
    }
  }
}
