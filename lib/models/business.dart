class Business {
  String name;
  List<String> workingDays;
  List<String> holidays;
  List<String> workingHours;

  Business({
    required this.name,
    required this.workingDays,
    required this.holidays,
    required this.workingHours,
  });
}

// Example business data
Business exampleBusiness = Business(
  name: 'Example Business',
  workingDays: ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'],
  holidays: ['2023-11-23', '2023-12-25'],
  workingHours: [
    '10:00 AM - 11:00 AM',
    '02:00 PM - 03:00 PM',
    '04:00 PM - 05:00 PM'
  ],
);
