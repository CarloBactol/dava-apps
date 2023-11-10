class Service {
  final String name;
  final String address;
  final double lat;
  final double long;
  final String content;
  final String status;
  final String createdAt;
  final String updatedAt;

  Service({
    required this.name,
    required this.address,
    required this.lat,
    required this.long,
    required this.status,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      name: json['name'] ?? '',
      lat: double.parse(json["lat"].toString()),
      long: double.parse(json["long"].toString()),
      address: json['address'],
      content: json['content'] ?? '',
      status: json['status'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}
