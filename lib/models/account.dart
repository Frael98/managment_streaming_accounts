/* 
  La cuenta que se crea en la plataforma   
 */
import 'package:f_managment_stream_accounts/interfaces/entity.dart';
import 'package:f_managment_stream_accounts/models/platform.dart';
import 'package:f_managment_stream_accounts/models/type_account.dart';

class Account extends Entity {
  int? idAccount;
  String email;
  String password;
  DateTime registerDate;
  DateTime expireDate;
  Platform platform;
  TypeAccount typeAccount;
  int perfilQuantity;

  Account({
    this.idAccount,
    required this.email,
    required this.password,
    required this.registerDate,
    required this.expireDate,
    required this.platform,
    required this.typeAccount,
    required this.perfilQuantity,
  });

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'password': password,
      'registerDate': registerDate,
      'expire_date': expireDate,
      'platform': platform,
      'type_account': typeAccount,
      'perfil_quantity': perfilQuantity
    };
  }

  factory Account.fromMap(Map<String, dynamic> map) {
    return Account(
        idAccount: map['ID_ACCOUNT'],
        email: map['EMAIL'],
        password: map['PASSWORD'],
        registerDate: map['REGISTER_DATE'],
        expireDate: map['EXPIRE_DATE'],
        platform: map['PLATFORM'],
        typeAccount: map['TYPE_ACCOUNT'],
        perfilQuantity: map['PERFIL_QUANTITY']);
  }
}
