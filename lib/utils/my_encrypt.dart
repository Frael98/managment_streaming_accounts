import 'package:encrypt/encrypt.dart';

class MyEncrypt {
  static final _key = Key.fromUtf8("this_is_my_key_m");
  static final _iv = IV.allZerosOfLength(16);
  static final _encriptador = Encrypter(AES(_key, padding: 'PKCS7'));

  static Encrypted encriptarPassword(String password) {
    var encriptado = _encriptador.encrypt(password, iv: _iv);

    return encriptado;
  }

  static String desencriptarPassword(Encrypted passwordEncrypted) {
    var desencriptado =
        _encriptador.decrypt(passwordEncrypted, iv: _iv);
    return desencriptado;
  }
}
