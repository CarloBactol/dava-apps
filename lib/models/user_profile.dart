class UserProfile {
  final String firstName;
  final String lastName;
  final String email;

  UserProfile({
    required this.firstName,
    required this.lastName,
    required this.email,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      firstName: json['profile']['first_name'] ?? '',
      lastName: json['profile']['last_name'] ?? '',
      email: json['profile']['email'] ?? '',
    );
  }
}
