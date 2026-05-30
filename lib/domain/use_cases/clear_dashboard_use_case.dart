import 'package:montage/core/interfaces/i_transaction_repository.dart';
import 'package:montage/domain/entities/transaction.dart';

class ClearDashboardUseCase {
  final ITransactionRepository _repository;

  ClearDashboardUseCase(this._repository);

  Future<void> call() async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final updates = <int, Transaction>{};
    for (final tx in _repository.getAll()) {
      if (!tx.isArchived && tx.id != null) {
        updates[tx.id!] = tx.copyWith(isArchived: true, lastModified: now);
      }
    }
    if (updates.isNotEmpty) await _repository.updateBulk(updates);
  }
}
