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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'transactions': transactions.map((t) => t.toJson()).toList(),
    };
  }

  factory Project.fromJson(Map<String, dynamic> json) {
    final rawTransactions = json['transactions'] as List<dynamic>? ?? const [];

    return Project(
      id: json['id'] as String,
      name: json['name'] as String,
      transactions: rawTransactions
          .map((item) => Transaction.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}
