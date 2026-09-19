class Transaction {
  final String id;
  String description;
  double amount;
  DateTime date;

  Transaction({
    required this.id,
    required this.description,
    required this.amount,
    required this.date,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'amount': amount,
      'date': date.toIso8601String(),
    };
  }

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] as String,
      description: json['description'] as String,
      amount: (json['amount'] as num).toDouble(),
      date: DateTime.parse(json['date'] as String),
    );
  }
}
