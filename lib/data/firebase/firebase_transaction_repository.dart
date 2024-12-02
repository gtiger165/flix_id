import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:flix_id/data/firebase/firebase_user_repository.dart';
import 'package:flix_id/data/repositories/transaction_repository.dart';
import 'package:flix_id/domain/entities/result/result.dart';
import 'package:flix_id/domain/entities/transaction/transaction.dart';

class FirebaseTransactionRepository implements TransactionRepository {
  final firestore.FirebaseFirestore _firebaseFirestore;

  FirebaseTransactionRepository(
      {firestore.FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore =
            firebaseFirestore ?? firestore.FirebaseFirestore.instance;

  @override
  Future<Result<Transaction>> createTransaction(
      {required Transaction transaction}) async {
    firestore.CollectionReference<Map<String, dynamic>> transactions =
        _firebaseFirestore.collection('transactions');

    try {
      final balanceResult =
          await FirebaseUserRepository().getUserBalance(uid: transaction.uid);

      if (balanceResult.isFailed) {
        return Result.failed('Failed to create transaction data');
      }

      final previousBalance = balanceResult.resultValue!;
      final isBalanceInsufficient = previousBalance - transaction.total < 0;

      if (isBalanceInsufficient) {
        return Result.failed('Insufficient balance');
      }

      await transactions.doc(transaction.id).set(transaction.toJson());

      final result = await transactions.doc(transaction.id).get();

      if (!result.exists) {
        return Result.failed('Failed to create transaction data');
      }

      await FirebaseUserRepository().updateUserBalance(
        uid: transaction.uid,
        balance: previousBalance - transaction.total,
      );

      return Result.success(Transaction.fromJson(result.data()!));
    } catch (e) {
      return Result.failed('Failed to create transaction data');
    }
  }

  @override
  Future<Result<List<Transaction>>> getUserTransaction(
      {required String uid}) async {
    firestore.CollectionReference<Map<String, dynamic>> transactions =
        _firebaseFirestore.collection('transactions');

    try {
      final result = await transactions.where('uid', isEqualTo: uid).get();

      if (result.docs.isEmpty) {
        return Result.success([]);
      }

      return Result.success(
          result.docs.map((e) => Transaction.fromJson(e.data())).toList());
    } catch (e) {
      return Result.failed('Failed to get user transactions');
    }
  }
}
