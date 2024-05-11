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
      {this.idClient,
      required this.nameClient,
      this.numberPhone,
      this.direction,
      this.email});

  // Método para convertir la instancia de la clase a un mapa
  Map<String, dynamic> toMap() {
    // alias: toJson
    return {
      'idClient': idClient,
      'nameClient': nameClient,
      'numberPhone': numberPhone,
      'direction': direction,
      'email': email
    };
  }

  factory Client.fromMap(Map<String, dynamic> map) {
    return Client(
        idClient: map['idClient'],
        nameClient: map['nameClient'],
        numberPhone: map['numberPhone'],
        direction: map['direction'],
        email: map['email']);
  }
}
