import 'package:montage/core/interfaces/i_transaction_repository.dart';
import 'package:montage/domain/entities/transaction.dart';

class RestoreTransactionsUseCase {
  final ITransactionRepository _repository;

  RestoreTransactionsUseCase(this._repository);

  Future<void> call(List<int> ids) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final updates = <int, Transaction>{};
    for (final tx in _repository.getAll()) {
      if (tx.id != null && ids.contains(tx.id) && (tx.isArchived || tx.isDeleted)) {
        updates[tx.id!] = tx.copyWith(isArchived: false, isDeleted: false, lastModified: now);
      }
    }
    if (updates.isNotEmpty) await _repository.updateBulk(updates);
  }
}
