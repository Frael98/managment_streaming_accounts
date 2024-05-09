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
    required this.email,
    required this.password,
    required this.registerDate,
    required this.expireDate,
    required this.platform,
    required this.typeAccount,
    required this.perfilQuantity,
  });


}