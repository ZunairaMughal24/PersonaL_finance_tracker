import 'package:montage/core/interfaces/i_transaction_repository.dart';

class SoftDeleteTransactionUseCase {
  final ITransactionRepository _repository;

  SoftDeleteTransactionUseCase(this._repository);

  Future<void> call(int id) async {
    final transactions = _repository.getAll();
    final tx = transactions.firstWhere((t) => t.id == id);
    await _repository.update(
      id,
      tx.copyWith(
        isDeleted: true,
        isArchived: false,
        lastModified: DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }
}
