/* 
  La cuenta que se crea en la plataforma   
 */
import 'package:f_managment_stream_accounts/interfaces/entity.dart';
import 'package:f_managment_stream_accounts/models/platform.dart';
import 'package:f_managment_stream_accounts/models/type_account.dart';

class Account extends Entity {
  String email;
  String password;
  DateTime registerDate;
  DateTime expireDate;
  Platform platform;
  TypeAccount typeAccount;
  int perfilQuantity;

  Account({
    uid,
    id,
    required this.email,
    required this.password,
    required this.registerDate,
    required this.expireDate,
    required this.platform,
    required this.typeAccount,
    required this.perfilQuantity,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'password': password,
      'register_date': registerDate,
      'expire_date': expireDate,
      'platform': platform,
      'type_account': typeAccount,
      'perfil_quantity': perfilQuantity,
      'state': state
    };
  }

  factory Account.fromMap(Map<String, dynamic> map) {
    return Account(
      uid: map['_id'],
      id: map['ID_ACCOUNT'] ?? map['id_account'],
      email: map['EMAIL'] ?? map['email'],
      password: map['PASSWORD'] ?? map['password'],
      registerDate: map['REGISTER_DATE'] ?? map['register_date'],
      expireDate: map['EXPIRE_DATE'] ?? map['expire_date'],
      platform: map['PLATFORM'] ?? map['platform'],
      typeAccount: map['TYPE_ACCOUNT'] ?? map['type_account'],
      perfilQuantity: map['PERFIL_QUANTITY'] ?? map['perfil_quantity'],
    );
  }

  factory Account.fromMapForSQLite(Map<String, dynamic> map) {
    return Account(
      uid: map['_id'],
      id: map['ID_ACCOUNT'] ?? map['id_account'],
      email: map['EMAIL'] ?? map['email'],
      password: map['PASSWORD'] ?? map['password'],
      registerDate:
          DateTime.parse(map['REGISTER_DATE'] ?? map['register_date']),
      expireDate: DateTime.parse(map['EXPIRE_DATE'] ?? map['expire_date']),
      platform: map['PLATFORM'] ?? map['platform'],
      typeAccount: map['TYPE_ACCOUNT'] ?? map['type_account'],
      perfilQuantity: map['PERFIL_QUANTITY'] ?? map['perfil_quantity'],
    );
  }

  @override
  String toString() {
    return "Account(uid(MongoId): $uid, id(SQLite): $id, email: $email, password: $password, expiredDate: $expireDate, registerDate: $registerDate, platform: ${platform.toString()}, typeAccount: ${typeAccount.toString()}, perfilQuantity: $perfilQuantity)";
  }

  @override
  Map<String, dynamic> toMapForSQLite() {
    return {
      'email': email,
      'password': password,
      'registerDate': registerDate.toIso8601String(),
      'expire_date': expireDate.toIso8601String(),
      'platform': platform,
      'type_account': typeAccount,
      'perfil_quantity': perfilQuantity,
      'state': state
    };
  }
}
