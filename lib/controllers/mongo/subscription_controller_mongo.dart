import 'dart:developer';

import 'package:f_managment_stream_accounts/db/mongo/mongo_db.dart';
import 'package:f_managment_stream_accounts/models/subscription.dart';
import 'package:mongo_dart/mongo_dart.dart';

/// Subscripcion controlador
class SubscriptionControllerMongo {
  static Future<DbCollection?> _getCollection() async {
    Db? db;
    try {
      db = await MongoConnection().getConnection();
      await db!.open();

      return db.collection('subscription');
    } catch (e) {
      log("Error consiguiendo collection subscription: $e");
    }

    return null;
  }

  static Future<String> addAccount(Subscription subscription) async {
    final collection = await _getCollection();
    var result = await collection!.insertOne(subscription.toMap());

    if (result.isSuccess) {
      return "Subscripcion agregada correctamente";
    }
    return "Error no se pudo agregar ${result.errmsg}";
  }

  static Future<String> updateAccount(Subscription subscription) async {
    final collection = await _getCollection();
    var result = await collection!.updateOne(
      where.eq('_id', subscription.uid),
      modify
          .set('date_started', subscription.dateStarted)
          .set('date_finish', subscription.dateFinish)
          .set('value_to_pay', subscription.valueToPay),
    );

    if (result.isSuccess) {
      return "Subscripcion actualizada correctamente";
    }
    return "Error no se pudo actualizar ${result.errmsg}";
  }

  static Future<String> deleteAccount(ObjectId uid) async {
    final collection = await _getCollection();
    var result = await collection!.deleteOne({'_id': uid});

    if (result.isSuccess) {
      return "Subscripcion eliminada correctamente";
    }
    return "Error no se pudo eliminar subscription ${result.errmsg}";
  }

  static Future<Subscription> getAccount(ObjectId uid) async {
    final collection = await _getCollection();
    var result = await collection!.findOne({'_id': uid});

    return Subscription.fromMap(result!);
  }

  static Future<List<Subscription>> getAccounts(
      Subscription subscription) async {
    final collection = await _getCollection();
    var result = await collection!.find().toList();

    log(result.first.toString());

    return result
        .map((subscription) => Subscription.fromMap(subscription))
        .toList();
  }
}
