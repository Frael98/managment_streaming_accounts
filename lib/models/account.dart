/* 
  La cuenta que se crea en la plataforma   
 */

import 'dart:ffi';

import 'package:f_managment_stream_accounts/interfaces/entity.dart';
import 'package:f_managment_stream_accounts/models/platform.dart';
import 'package:f_managment_stream_accounts/models/type_account.dart';

class Account extends Entity {
  Int64? idAccount;
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
      'expireDate': expireDate,
      'platform': platform,
      'typeAccount': typeAccount,
      'perfilQuantity': perfilQuantity
    };
  }

  factory Account.fromMap(Map<String, dynamic> map) {
    return Account(
        idAccount: map['idAccount'],
        email: map['email'],
        password: map['password'],
        registerDate: map['registerDate'],
        expireDate: map['expireDate'],
        platform: map['platform'],
        typeAccount: map['typeAccount'],
        perfilQuantity: map['perfilQuantity']);
  }
}
