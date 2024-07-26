/* Cliente que hace la suscripcion a las cuentas */
import 'package:f_managment_stream_accounts/interfaces/entity.dart';
import 'package:mongo_dart/mongo_dart.dart';

class Client extends Entity {
  ObjectId? imagen;
  String? nameClient;
  String? numberPhone;
  String? direction;
  String? email;

  Client(
      {int? id,
      ObjectId? uid,
      required this.nameClient,
      this.numberPhone,
      this.direction,
      this.email,
      this.imagen,
      state,
      createdAt,
      updatedAt,
      deletedAt})
      : super(
            uid: uid,
            id: id,
            state: state,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt);

  Client.audit({uid, id, state, createdAt, updatedAt, deletedAt})
      : super(
            uid: uid,
            id: id,
            state: state,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt);

  // Método para convertir la instancia de la clase a un mapa
  @override
  Map<String, dynamic> toMap() {
    return {
      'name_client': nameClient,
      'number_phone': numberPhone,
      'direction': direction,
      'email': email,
      'state': state,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt
    };
  }

  factory Client.fromMap(Map<String, dynamic> map) {
    return Client(
      uid: map['_id'],
      id: map['ID_CLIENT'] ?? map['id_client'],
      nameClient: map['NAME_CLIENT'] ?? map['name_client'],
      numberPhone: map['NUMBER_PHONE'] ?? map['number_phone'],
      imagen: map['imagen_id'] ?? map['IMAGEN_ID'],
      state: map['STATE'] ?? map['state'],
      direction: map['DIRECTION'] ?? map['direction'],
      email: map['EMAIL'] ?? map['email'],
    );
  }

  factory Client.fromMapAuditForSQLite(Map<String, dynamic> map) {
    return Client.audit(
      uid: map['_id'],
      id: map['IDUSER'],
      state: map['STATE'] ?? map['state'],
      createdAt: DateTime.parse(map['CREATED_AT'] ?? map['created_at']),
      updatedAt: DateTime.parse(map['UPDATED_AT'] ?? map['updated_at']),
      deletedAt: DateTime.parse(map['DELETED_AT'] ?? map['deleted_at']),
    );
  }

  factory Client.fromMapAudit(Map<String, dynamic> map) {
    return Client.audit(
      uid: map['_id'],
      id: map['IDUSER'],
      state: map['STATE'] ?? map['state'],
      createdAt: (map['CREATED_AT'] ?? map['created_at']),
      updatedAt: (map['UPDATED_AT'] ?? map['updated_at']),
      deletedAt: (map['DELETED_AT'] ?? map['deleted_at']),
    );
  }

  @override
  String toString() {
    return "User(uid(MongoId): $uid. id(SQLite): $id, name_client: $nameClient, number phone: $numberPhone, direction $direction, email: $email, state: $state, createdAt: $createdAt, updatedAt: $updatedAt)";
  }

  @override
  Map<String, dynamic> toMapForSQLite() {
    return {
      'name_client': nameClient,
      'number_phone': numberPhone,
      'direction': direction,
      'email': email,
      'state': state,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String()
    };
  }
}
