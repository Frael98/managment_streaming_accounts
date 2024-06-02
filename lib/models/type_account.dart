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
  TypeAccount.id({ObjectId? uid, int? id});

  // Método para convertir la instancia de la clase a un mapa
  @override
  Map<String, dynamic> toMap() {
    return {'name_type_account': nameTypeAccount, 'state': state};
  }

  factory TypeAccount.fromMap(Map<String, dynamic> map) {
    return TypeAccount(
      uid: map['_id'],
      id: map['ID_TYPE_ACCOUNT'] ?? map['id_type_account'],
      nameTypeAccount: map['NAME_TYPE_ACCOUNT'] ?? map['name_type_account'],
      state: map['STATE'] ?? map['state'],
    );
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
