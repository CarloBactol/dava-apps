class Service {
  final String address;
  final double lat;
  final double long;
  final String content;
  final String status;
  final String createdAt;
  final String updatedAt;
  final String isOpen;
  final String openHours;
  final String daysOpen;

  Service({
    required this.address,
    required this.lat,
    required this.long,
    required this.status,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    required this.isOpen,
    required this.openHours,
    required this.daysOpen,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      lat: double.parse(json["lat"].toString()),
      long: double.parse(json["long"].toString()),
      address: json['address'],
      content: json['content'] ?? '',
      status: json['status'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      isOpen: json['isOpen'] ?? '',
      openHours: json['openHours'] ?? '',
      daysOpen: json['daysOpen'] ?? '',
    );
  }
}
