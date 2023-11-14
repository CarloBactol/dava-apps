import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:laravel_test_api/constant.dart';
import 'package:laravel_test_api/screens/bottom_navigation_app.dart';
import 'package:laravel_test_api/services/user_services.dart';

class BookingScreen extends StatefulWidget {
  final String serviceName;
  final String serviceBranch;
  final LatLng serviceLocation;
  final String isOpen;

  BookingScreen({
    Key? key,
    required this.serviceName,
    required this.serviceBranch,
    required this.serviceLocation,
    required this.isOpen,
  }) : super(key: key);

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  String selectedService = "Walk-in";
  String selectedLocation = "";
  DateTime selectedDate = DateTime.now();
  // ignore: prefer_const_constructors
  TimeOfDay selectedStartTime = TimeOfDay(hour: 00, minute: 00);
  // ignore: prefer_const_constructors
  TimeOfDay selectedEndTime = TimeOfDay(hour: 00, minute: 00);
  String selStart = "";
  String selEnd = "";
  bool isTimeValid = false;

  String? selectedTimeSlot;
  String? isOpen;
  bool isButtonEnabled = false;

  List<String> availableTimeSlots = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book a Veterinary Service'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Service Name: ${widget.serviceName}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
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
                    labelText: 'Enter Your Address',
                  ),
                  onChanged: (value) {
                    setState(() {
                      selectedLocation = value;
                      isOpen = widget.isOpen;
                      updateButtonEnabledStatus();
                    });
                  },
                ),
              ],
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 30)),
                  );
                  if (picked != null && picked != selectedDate) {
                    setState(() {
                      selectedDate = picked;
                      updateButtonEnabledStatus();
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
                    initialTime: selectedStartTime,
                  );
                  if (picked != null) {
                    setState(() {
                      selectedStartTime = picked;
                      String fStart = selectedStartTime.format(context);
                      selStart = fStart;
                      updateButtonEnabledStatus();
                      // validateSelectedTimeStart();
                    });
                  }
                },
                child: const Text('Pick Start Time'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  TimeOfDay? picked = await showTimePicker(
                    useRootNavigator: false,
                    context: context,
                    initialTime: selectedEndTime,
                  );
                  if (picked != null) {
                    setState(() {
                      selectedEndTime = picked;
                      String fEnd = selectedEndTime.format(context);
                      selEnd = fEnd;
                      updateButtonEnabledStatus();
                      // validateSelectedTimeEnd();
                    });
                  }
                },
                child: const Text('Pick End Time'),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  'Selected Date: ${DateFormat('yyyy-MM-dd').format(selectedDate)}',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 0),
                child: Text(
                  'Selected Start Time: ${selectedStartTime.format(context)}',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: Text(
                  'Selected End Time: ${selectedEndTime.format(context)}',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              ElevatedButton(
                onPressed: isButtonEnabled ? () => handleBooking() : null,
                child: const Text('Confirm Booking'),
              )
            ],
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

    // Perform the booking logic using the obtained values
    // Example: Print the values, you can replace this with your actual booking logic
    print('Service Name: $serviceName');
    print('Service Branch: $serviceBranch');
    print('Service Location: $serviceLocation');
    print('Selected Service: $selectedService');
    print('Selected Location: $selectedLocation');
    print('Selected Date: $selectedDate');
    print('Selected Date and Time: $selectedStartTime');
    print('Selected Date and Time: $selectedEndTime');
    print('Start: $selStart');
    print('End: $selEnd');

    // Add your logic to proceed with the booking here
    postBooking(
      serviceBranch,
      serviceName,
      selectedDate.toString(),
      selStart,
      selEnd,
      selectedService,
      selectedLocation,
    );
  }

  // ... (unchanged code)
  // void validateSelectedTimeStart() {
  //   // ... (unchanged code)
  //   if (selStart != "") {
  //     setState(() {
  //       isTimeValid = true;
  //     });
  //   } else {
  //     setState(() {
  //       isTimeValid = false;
  //     });
  //   }
  // }

  // void validateSelectedTimeEnd() {
  //   // ... (unchanged code)
  //   if (selEnd != "") {
  //     setState(() {
  //       isTimeValid = true;
  //     });
  //   } else {
  //     setState(() {
  //       isTimeValid = false;
  //     });
  //   }
  // }

  Future<void> postBooking(
    String branch,
    String services,
    String selectedDate,
    String selectedStartTime,
    String selectedEndTime,
    // TimeOfDay selectedStartTime,
    // TimeOfDay selectedEndTime,
    String serviceType,
    String address,
  ) async {
    DateTime dateTime = DateTime.parse(selectedDate);
    // int shour = selectedStartTime.hour;
    // int sminutes = selectedStartTime.minute;
    // int rad = selectedStartTime.hourOfPeriod;
    // // ignore: prefer_interpolation_to_compose_strings, unnecessary_brace_in_string_interps
    // String start = shour.toString() + ':' + sminutes.toString() + '${rad}';

    // DateTime parsedTime = DateFormat('h:mm a').parse(start);
    // String formattedTimeStart = DateFormat('HH:mm:ss').format(parsedTime);

    final email = await getUserEmail();
    String formattedSelectedDate = DateFormat('yyyy-MM-dd').format(dateTime);

    DateTime parsedTimeStart = DateFormat('h:mm a').parse(selectedStartTime);
    DateTime parsedTimeEnd = DateFormat('h:mm a').parse(selectedEndTime);
    String formattedTimeStart = DateFormat('HH:mm').format(parsedTimeStart);
    String formattedTimeEnd = DateFormat('HH:mm').format(parsedTimeEnd);
    // print(parsedStartTime);
    // String formattedTimeStart = DateFormat('HH:mm:ss').format(parsedStartTime);
    // String formattedTimeEnd = DateFormat('HH:mm:ss').format(parsedEndTime);
    // String formattedSelctedEnd = DateFormat('HH:mm:ss').format(_endTime);
    // String formattedSelectedStart = DateFormat('kk:mm:ss').format(_startTime);
    // String formattedSelctedEnd = DateFormat('kk:mm:ss').format(_endTime);

    const apiUrl = '$baseURL/post_bookings';
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        "Accept": "application/json",
      },
      body: {
        "branch": branch,
        "services": services,
        "date": formattedSelectedDate,
        "start": formattedTimeStart,
        "end": formattedTimeEnd,
        "type": serviceType,
        "email": email,
        "address": address,
      },
    );
    if (response.statusCode == 200) {
      print('Succcess');
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => BottomNavigationApp(),
        ),
        (route) => false,
      );
      // final message = jsonDecode(response.body)['message'];
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
              'Your book is being processed. Please wait for the completion of the process.',
            ),
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
      final error = jsonDecode(response.body)['errors'];
      print(error);
      print(formattedTimeEnd);

      if (error != null) {
        final errorMessage = error[error.keys.elementAt(0)][0];
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(errorMessage),
        ));
        print('Failed to load services');
      }
    }
  }
}
