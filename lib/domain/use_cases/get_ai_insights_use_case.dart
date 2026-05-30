import 'package:montage/core/interfaces/i_ai_service.dart';
import 'package:montage/domain/entities/transaction.dart';

class GetAiInsightsUseCase {
  final IAIService _aiService;

  GetAiInsightsUseCase(this._aiService);

  Future<String?> call(List<Transaction> transactions) {
    return _aiService.getSuggestionsAndAppreciation(transactions);
  }
}
