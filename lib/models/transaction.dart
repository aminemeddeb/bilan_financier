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
}
