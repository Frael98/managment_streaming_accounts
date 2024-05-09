/* Cliente que hace la suscripcion a las cuentas */

import 'dart:ffi';

import 'package:f_managment_stream_accounts/interfaces/entity.dart';

class Client extends Entity {
  
  Int64? idClient;
  String nameClient;
  String? numberPhone;
  String? direction;
  String? email;

  Client(
      {required this.nameClient, this.numberPhone, this.direction, this.email});
}
