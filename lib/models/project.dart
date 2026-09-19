import 'transaction.dart';

class Project {
  final String id;
  String name;
  List<Transaction> transactions;

  Project({
    required this.id,
    required this.name,
    List<Transaction>? transactions,
  }) : transactions = transactions ?? [];

  double get total {
    return transactions.fold(
      0,
      (sum, transaction) => sum + transaction.amount,
    );
  }
}
