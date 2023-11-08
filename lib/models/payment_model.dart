class Payment {
  final String email;
  final String phoneNo;
  final String amount;
  final String referenceNo;
  final String status;

  Payment({
    required this.email,
    required this.phoneNo,
    required this.amount,
    required this.referenceNo,
    required this.status,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      email: json['email'] ?? '',
      phoneNo: json['phone_no'] ?? '',
      amount: json['amount'] ?? '',
      referenceNo: json['reference_no'] ?? '',
      status: json['status'] ?? '',
    );
  }
}
