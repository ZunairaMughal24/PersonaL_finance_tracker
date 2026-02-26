import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:personal_finance_tracker/models/transaction_model.dart';

class AIService {
  final String apiKey;
  late final GenerativeModel _model;

  AIService(this.apiKey) {
    _model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);
  }

  Future<String?> getSuggestionsAndAppreciation(
    List<TransactionModel> transactions,
  ) async {
    try {
      final summary = transactions
          .take(15)
          .map(
            (t) =>
                "${t.category}: ${t.amount} ${t.currency} (${t.isIncome ? 'Income' : 'Expense'})",
          )
          .join(", ");

      final seed = DateTime.now().millisecond;

      final prompt =
          '''
        Act as a "No-Nonsense Financial Mentor".
        Current Context Seed: $seed
        Transactions Data: [$summary].
        
        YOUR ROLE:
        - Analyze the data and JUDGE the user's financial choices. 
        - Call out "Bad" uses of money (e.g., high subscriptions, luxury, frequent dining).
        - Appreciate "Good" moves (e.g., high income, low expense streaks).
        - Identify the category with the HIGHEST volume and tell the user how to control it.
        
        TONE & STYLE:
        - Be a Mentor: Wise, direct, slightly critical if needed, but ultimately empowering.
        - NO generic advice like "Consistency is key". Be specific to categories.
        - Be varied and avoid repeated patterns.
        - MAX 25 WORDS. No prefixes.
      ''';

      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      return response.text
          ?.trim()
          .replaceAll('Consultation:', '')
          .replaceAll('Appreciation:', '')
          .trim();
    } catch (e) {
      final fallbacks = [
        "Analyzing your spending leaks... stay alert for my verdict.",
        "Your mentor is watching. Every transaction is a choice—choose wealth.",
        "Precision is the path to freedom. Keep tracking while I calculate your next move.",
        "Scanning for financial traps in your categories...",
      ];
      return fallbacks[DateTime.now().second % fallbacks.length];
    }
  }
}
