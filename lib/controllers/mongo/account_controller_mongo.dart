import 'dart:developer';

import 'package:f_managment_stream_accounts/db/mongo/mongo_db.dart';
import 'package:f_managment_stream_accounts/models/account.dart';
import 'package:mongo_dart/mongo_dart.dart';

/// Cuenta Controlador
class AccountControllerMongo {
  static Future<DbCollection?> _getCollection() async {
    Db? db;
    try {
      db = await MongoConnection().getConnection();
      await db!.open();

      return db.collection('account');
    } catch (e) {
      log("Error consiguiendo collection account: $e");
    }

    return null;
  }

  static Future<String> addAccount(Account account) async {
    final collection = await _getCollection();
    var result = await collection!.insertOne(account.toMap());

    if (result.isSuccess) {
      return "Cuenta agregada correctamente";
    }
    return "Error no se pudo agregar ${result.errmsg}";
  }

  static Future<String> updateAccount(Account account) async {
    final collection = await _getCollection();
    var result = await collection!.updateOne(
      where.eq('_id', account.uid),
      modify
          .set('email', account.email)
          .set('password', account.password)
          .set('register_date', account.registerDate)
          .set('expire_date', account.expireDate)
          .set('updated_at', account.updatedAt)
          .set('perfil_quantity', account.perfilQuantity),
    );

    if (result.isSuccess) {
      return "Cuenta actualizada correctamente";
    }
    return "Error no se pudo actualizar ${result.errmsg}";
  }

  static Future<String> deleteAccount(ObjectId uid) async {
    final collection = await _getCollection();
    var result = await collection!.deleteOne({'_id': uid});

    if (result.isSuccess) {
      return "Cuenta eliminada correctamente";
    }
    return "Error no se pudo eliminar account ${result.errmsg}";
  }

  static Future<Account> getAccount(ObjectId uid) async {
    final collection = await _getCollection();
    var result = await collection!.findOne({'_id': uid});

    return Account.fromMap(result!);
  }

  static Future<List<Account>> getAccounts(Account account) async {
    final collection = await _getCollection();
    var result = await collection!.find().toList();

    log(result.first.toString());

    return result.map((account) => Account.fromMap(account)).toList();
  }
}
