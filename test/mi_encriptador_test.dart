// ignore_for_file: avoid_print

import 'package:encrypt/encrypt.dart';
import 'package:f_managment_stream_accounts/utils/my_encrypt.dart';

void main() {
  String pass = '789';
  
  print(MyEncrypt.encriptarPassword(pass).base16);
  // Simula la obtencion del AES en base16 desde mongo
  var passBase16 = Key.fromBase16(MyEncrypt.encriptarPassword(pass).base16);
  // Desencriptamos
  print(MyEncrypt.desencriptarPassword(passBase16));
}
