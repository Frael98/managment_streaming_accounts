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
      this.email,
      createdAt,
      updatedAt,
      deletedAt}): super(createdAt: createdAt, updatedAt: updatedAt, deletedAt: deletedAt);

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
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt
    };
  }

  factory Client.fromMap(Map<String, dynamic> map) {
    return Client(
        idClient: map['ID_CLIENT'] ?? map['id_client'],
        nameClient: map['NAME_CLIENT'] ?? map['name_client'],
        numberPhone: map['NUMBER_PHONE'] ?? map['number_phone'],
        direction: map['DIRECTION'] ?? map['direction'],
        email: map['EMAIL'] ?? map['email'],
        createdAt: map['CREATED_AT'] ?? (map['created_at']),
        updatedAt: map['UPDATED_AT'] ?? map['updated_at'],
        deletedAt: map['DELETED_AT'] ?? map['deleted_at']);
  }

  factory Client.fromMapAudit(Map<String, dynamic> map) {
    return Client.audit(
        idClient: map['IDUSER'],
        state: map['STATE'],
        createdAt: map['CREATED_AT'],
        updatedAt: map['UPDATED_AT'],
        deletedAt: map['DELETED_AT']);
  }

  @override
  String toString() {
    return "idCliente: $idClient, name_client: $nameClient, number phone: $numberPhone, direction $direction, email: $email, state: $state, created_at: $createdAt";
  }
}
