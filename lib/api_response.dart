sealed class ApiResponse<T> {
  const ApiResponse();
}

final class Success<T> extends ApiResponse<T> {
  const Success(this.data);
  final T data;
}

final class Failure extends ApiResponse<Never> {
  const Failure(this.message);
  final String message;
}
