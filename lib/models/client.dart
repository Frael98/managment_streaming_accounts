/* Cliente que hace la suscripcion a las cuentas */
import 'package:f_managment_stream_accounts/interfaces/entity.dart';

class Client extends Entity {
  int? idClient;
  String? nameClient;
  String? numberPhone;
  String? direction;
  String? email;

  Client(
      {this.idClient,
      required this.nameClient,
      this.numberPhone,
      this.direction,
      this.email});

  Client.audit({this.idClient, state, createdAt, updatedAt, deletedAt});

  // Método para convertir la instancia de la clase a un mapa
  Map<String, dynamic> toMap() {
    // alias: toJson
    return {
      'id_client': idClient,
      'name_client': nameClient,
      'number_phone': numberPhone,
      'direction': direction,
      'email': email,
      'state': 'A',
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': updatedAt,
      'deleted_at': deletedAt
    };
  }

  factory Client.fromMap(Map<String, dynamic> map) {
    return Client(
        idClient: map['ID_CLIENT'],
        nameClient: map['NAME_CLIENT'],
        numberPhone: map['NUMBER_PHONE'],
        direction: map['DIRECTION'],
        email: map['EMAIL']);
  }

  factory Client.fromMapAudit(Map<String, dynamic> map) {
    return Client.audit(
        idClient: map['IDUSER'],
        state: map['STATE'],
        createdAt: map['CREATED_AT'],
        updatedAt: map['UPDATED_AT'],
        deletedAt: map['DELETED_AT']);
  }
}
