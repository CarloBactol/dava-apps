class GcashAccount {
  final String accountName;
  final String accountNumber;
  final String cost;

  GcashAccount({
    required this.accountName,
    required this.accountNumber,
    required this.cost,
  });

  factory GcashAccount.fromJson(Map<String, dynamic> json) {
    return GcashAccount(
      accountName: json['account']['account_name'] ?? '',
      accountNumber: json['account']['account_number'] ?? '',
      cost: json['account']['cost'] ?? '',
    );
  }
}
