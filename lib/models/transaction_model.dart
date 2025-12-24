import 'package:hive/hive.dart';

part 'transaction_model.g.dart';

@HiveType(typeId: 0)
class TransactionModel extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  double amount;

  @HiveField(2)
  bool isIncome = true; // Income / Expense

  @HiveField(3)
  String date;

  @HiveField(4)
  String category;

  TransactionModel({
    required this.title,
    required this.amount,
    required this.isIncome,
    required this.date,
    required this.category,
  });

  // Optional: for map conversion
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'amount': amount,
     "isIncome': isIncome,"
      'date': date,
      'category': category,
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      title: map['title'],
      amount: map['amount'],
      isIncome: map['isIncome'],
      date: map['date'],
      category: map['category'] ?? '',
    );
  }
}
