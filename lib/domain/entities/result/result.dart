sealed class Result<T> {
  const Result();

  factory Result.success(T value) = Success;
  factory Result.failed(String message) = Failed;

  bool get isSuccess => this is Success<T>;
  bool get isFailed => this is Failed<T>;

  T? get resultValue => isSuccess ? (this as Success<T>).value : null;
  String? get errorMessage => isFailed ? (this as Failed<T>).message : null;
}

class Success<T> extends Result<T> {
  final T value;

  Success(this.value);
}

class Failed<T> extends Result<T> {
  final String message;

  Failed(this.message);
}
