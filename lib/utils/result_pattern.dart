class Result<T> {
  T? _data;
  bool success;
  String? error;

  Result(this._data, this.success, this.error);
  Result.success(this._data) : success = true;
  Result.failure(this.error) : success = false;

  bool get isSuccess => success;
  bool get isFailure => !success;
  T? get data => _data;
  String? get errorMessage => error;
}


// Función para crear un resultado de éxito
Result<T> success<T>(T value) => Result<T>.success(value);

// Función para crear un resultado de fallo
Result<T> failure<T>(String message) => Result<T>.failure(message);