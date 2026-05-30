import 'package:hive/hive.dart';
import 'package:montage/domain/entities/transaction.dart';

part 'transaction_model.g.dart';

@HiveType(typeId: 0)
class TransactionModel extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  double amount;

  @HiveField(2)
  bool isIncome = true;

  @HiveField(3)
  String date;

  @HiveField(4)
  String category;

  @HiveField(5, defaultValue: 'USD')
  String currency;

  @HiveField(6, defaultValue: null)
  String? imagePath;

  @HiveField(7, defaultValue: false)
  bool isArchived;

  @HiveField(8)
  int? lastModified;

  @HiveField(9, defaultValue: false)
  bool isDeleted;

  TransactionModel({
    required this.title,
    required this.amount,
    required this.isIncome,
    required this.date,
    required this.category,
    this.currency = 'USD',
    this.imagePath,
    this.isArchived = false,
    this.lastModified,
    this.isDeleted = false,
  });

  Transaction toEntity() {
    return Transaction(
      id: key as int?,
      title: title,
      amount: amount,
      isIncome: isIncome,
      date: date,
      category: category,
      currency: currency,
      imagePath: imagePath,
      isArchived: isArchived,
      isDeleted: isDeleted,
      lastModified: lastModified,
    );
  }

  static TransactionModel fromEntity(Transaction entity) {
    return TransactionModel(
      title: entity.title,
      amount: entity.amount,
      isIncome: entity.isIncome,
      date: entity.date,
      category: entity.category,
      currency: entity.currency,
      imagePath: entity.imagePath,
      isArchived: entity.isArchived,
      isDeleted: entity.isDeleted,
      lastModified: entity.lastModified,
    );
  }
}
