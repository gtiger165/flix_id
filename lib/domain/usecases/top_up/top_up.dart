import 'package:flix_id/data/repositories/transaction_repository.dart';
import 'package:flix_id/domain/entities/result/result.dart';
import 'package:flix_id/domain/entities/transaction/transaction.dart';
import 'package:flix_id/domain/usecases/create_transaction/create_transaction.dart';
import 'package:flix_id/domain/usecases/create_transaction/create_transaction_param.dart';
import 'package:flix_id/domain/usecases/top_up/top_up_param.dart';
import 'package:flix_id/domain/usecases/usecase.dart';

class TopUp implements UseCase<Result<void>, TopUpParam> {
  final TransactionRepository _transactionRepository;

  TopUp({required TransactionRepository transactionRepository})
      : _transactionRepository = transactionRepository;

  @override
  Future<Result<void>> call(TopUpParam params) async {
    final createTransaction =
        CreateTransaction(transactionRepository: _transactionRepository);
    final transactionTime = DateTime.now().millisecondsSinceEpoch;

    final createTransactionResult = await createTransaction(
      CreateTransactionParam(
        transaction: Transaction(
          id: 'flxtp-$transactionTime- ${params.userId}',
          uid: params.userId,
          title: 'Top Up',
          adminFee: 0,
          total: -params.amount,
          transactionTime: transactionTime,
        ),
      ),
    );

    return switch (createTransactionResult) {
      Success(value: _) => Result.success(null),
      Failed(message: _) => Result.failed("Failed to top up")
    };
  }
}
