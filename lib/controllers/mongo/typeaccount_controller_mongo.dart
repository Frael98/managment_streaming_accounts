import 'dart:developer';

import 'package:f_managment_stream_accounts/db/mongo/mongo_db.dart';
import 'package:f_managment_stream_accounts/models/type_account.dart';
import 'package:mongo_dart/mongo_dart.dart';

/// Tipo de Cuenta Controlador
class TypeAccountControllerMongo {
  static Future<DbCollection?> _getCollection() async {
    try {
      final db = await MongoConnection().getConnection();
      await db!.open();

      return db.collection("type_account");
    } catch (e) {
      log("Error obteniendo collection type_account: $e");
    }
    return null;
  }

  static Future<String> addTypeAccount(TypeAccount typeAccount) async {
    final collection = await _getCollection();
    var result = await collection!.insertOne(typeAccount.toMap());

    if (result.isSuccess) {
      return "TipoCuenta agregada correctamente";
    }
    return "Error no se pudo agregar ${result.errmsg}";
  }

  static Future<String> updateTypeAccount(TypeAccount typeAccount) async {
    final collection = await _getCollection();
    var result = await collection!.updateOne(
      where.eq('_id', typeAccount.uid),
      modify
          .set('name_type_account', typeAccount.nameTypeAccount)
          .set('updated_at', typeAccount.updatedAt),
    );

    if (result.isSuccess) {
      return "TipoCuenta actualizada correctamente";
    }
    return "Error no se pudo actualizar ${result.errmsg}";
  }

  static Future<String> deleteTypeAccount(ObjectId uid) async {
    final collection = await _getCollection();
    var result = await collection!.deleteOne({'_uid': uid});

    if (result.isSuccess) {
      return "TipoCuenta eliminada correctamente";
    }
    return "Error no se pudo eliminar typeAccount ${result.errmsg}";
  }

  static Future<TypeAccount> getTypeAccount(ObjectId uid) async {
    final collection = await _getCollection();
    var result = await collection!.findOne({'_id': uid});

    return TypeAccount.fromMap(result!);
  }

  static Future<List<TypeAccount>> getTypeAccounts(
      TypeAccount typeAccount) async {
    final collection = await _getCollection();
    var result = await collection!.find().toList();

    log(result.first.toString());

    return result
        .map((typeAccount) => TypeAccount.fromMap(typeAccount))
        .toList();
  }
}
