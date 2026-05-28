import 'package:montage/models/transaction_model.dart';

abstract class IAIService {
  Future<String?> getSuggestionsAndAppreciation(
    List<TransactionModel> transactions,
  );
}
