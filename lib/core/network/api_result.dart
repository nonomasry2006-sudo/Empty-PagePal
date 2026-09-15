class ApiResult<T> {
  const ApiResult._({this.data, this.error});

  final T? data;
  final String? error;

  bool get isSuccess => error == null;

  factory ApiResult.success(T data) => ApiResult._(data: data);

  factory ApiResult.failure(String message) => ApiResult._(error: message);
}
