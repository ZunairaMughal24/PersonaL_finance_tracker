import 'package:montage/core/interfaces/i_transaction_repository.dart';

class ArchiveTransactionUseCase {
  final ITransactionRepository _repository;

  ArchiveTransactionUseCase(this._repository);

  Future<void> call(int id) async {
    final transactions = _repository.getAll();
    final tx = transactions.firstWhere((t) => t.id == id);
    await _repository.update(
      id,
      tx.copyWith(
        isArchived: true,
        lastModified: DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }
}
