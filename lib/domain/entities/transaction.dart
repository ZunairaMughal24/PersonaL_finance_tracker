class Transaction {
  final int? id;
  final String title;
  final double amount;
  final bool isIncome;
  final String date;
  final String category;
  final String currency;
  final String? imagePath;
  final bool isArchived;
  final bool isDeleted;
  final int? lastModified;

  const Transaction({
    this.id,
    required this.title,
    required this.amount,
    required this.isIncome,
    required this.date,
    required this.category,
    this.currency = 'USD',
    this.imagePath,
    this.isArchived = false,
    this.isDeleted = false,
    this.lastModified,
  });

  Transaction copyWith({
    int? id,
    String? title,
    double? amount,
    bool? isIncome,
    String? date,
    String? category,
    String? currency,
    String? imagePath,
    bool clearImagePath = false,
    bool? isArchived,
    bool? isDeleted,
    int? lastModified,
  }) {
    return Transaction(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      isIncome: isIncome ?? this.isIncome,
      date: date ?? this.date,
      category: category ?? this.category,
      currency: currency ?? this.currency,
      imagePath: clearImagePath ? null : (imagePath ?? this.imagePath),
      isArchived: isArchived ?? this.isArchived,
      isDeleted: isDeleted ?? this.isDeleted,
      lastModified: lastModified ?? this.lastModified,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'amount': amount,
      'isIncome': isIncome,
      'date': date,
      'category': category,
      'currency': currency,
      'imagePath': imagePath,
      'isArchived': isArchived,
      'isDeleted': isDeleted,
      'lastModified': lastModified ?? DateTime.now().millisecondsSinceEpoch,
    };
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      title: map['title'] as String,
      amount: (map['amount'] as num).toDouble(),
      isIncome: map['isIncome'] as bool,
      date: map['date'] as String,
      category: map['category'] as String? ?? '',
      currency: map['currency'] as String? ?? 'USD',
      imagePath: map['imagePath'] as String?,
      isArchived: map['isArchived'] as bool? ?? false,
      isDeleted: map['isDeleted'] as bool? ?? false,
      lastModified: map['lastModified'] as int?,
    );
  }
}
