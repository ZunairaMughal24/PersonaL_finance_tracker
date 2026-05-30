import 'package:montage/domain/entities/transaction.dart';

abstract class IAIService {
  Future<String?> getSuggestionsAndAppreciation(List<Transaction> transactions);
}
