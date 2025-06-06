import 'package:flix_id/domain/entities/result/result.dart';
import 'package:flix_id/domain/entities/transaction/transaction.dart';

abstract interface class TransactionRepository {
  Future<Result<Transaction>> createTransaction(
      {required Transaction transaction});
  Future<Result<List<Transaction>>> getUserTransaction({required String uid});
}
