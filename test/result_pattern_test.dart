// ignore_for_file: avoid_print
import 'package:f_managment_stream_accounts/utils/result_pattern.dart';

/* 
Result<double> dividir(int numerador, int denominador) {
  if (denominador == 0) {
    return failure<double>("no se puede dividir por cero.");
  } else {
    return success<double>(numerador / denominador);
  }
}
 */


Result<double> dividir(int numerador, int denominador) {
  if (denominador == 0) {
    return Result<double>.failure("no se puede dividir por cero.");
  } else {
    return Result<double>.success(numerador / denominador);
  }
}

void main() {
  //print(dividir(10, 2));
  //print(dividir(10, 0));

  var result = dividir(100, 0);

  if (result.isSuccess) {
    print(result.data);
  } else {
    print(result.errorMessage);
  }
}
