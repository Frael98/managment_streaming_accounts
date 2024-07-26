// ignore_for_file: avoid_print

/* Indica el tipo de cuenta creada */
import 'package:f_managment_stream_accounts/interfaces/entity.dart';
import 'package:mongo_dart/mongo_dart.dart';

class TypeAccount extends Entity {
  String? nameTypeAccount;

  TypeAccount(
      {uid,
      id,
      required this.nameTypeAccount,
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
  TypeAccount.id({ObjectId? uid, int? id}) : super(uid: uid, id: id);

  // Método para convertir la instancia de la clase a un mapa
  @override
  Map<String, dynamic> toMap() {
    return {
      'name_type_account': nameTypeAccount,
      'state': state,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deletedAt': deletedAt
    };
  }

  factory TypeAccount.fromMap(Map<String, dynamic> map) {
    try {
      return TypeAccount(
        uid: map['_id'],
        id: map['ID_TYPE_ACCOUNT'] ?? map['id_type_account'] ?? 0,
        nameTypeAccount: map['NAME_TYPE_ACCOUNT'] ?? map['name_type_account'],
        state: map['STATE'] ?? map['state'],
      );
    } catch (e) {
      print('Ocurrió un error durante la conversión del mapa: $e');
      throw const FormatException(
          'Error al convertir el mapa a objeto TypeAccount');
    }
  }

  @override
  String toString() {
    return "TypeAccount(uid(MongoId): $uid, id(SQLite): $id, nameTypeAccount: $nameTypeAccount)";
  }

  @override
  Map<String, dynamic> toMapForSQLite() {
    ///
    return {
      'name_type_account': nameTypeAccount,
    };
  }
}
