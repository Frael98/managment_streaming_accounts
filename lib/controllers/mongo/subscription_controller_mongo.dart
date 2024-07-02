import 'dart:developer';

import 'package:f_managment_stream_accounts/db/mongo/mongo_db.dart';
import 'package:f_managment_stream_accounts/models/subscription.dart';
import 'package:f_managment_stream_accounts/utils/helpful_functions.dart';
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

  static Future<String> addSubscription(Subscription subscription) async {
    final collection = await _getCollection();
    var result = await collection!.insertOne(subscription.toMap());

    if (result.isSuccess) {
      return "Subscripcion agregada correctamente";
    }
    return "Error no se pudo agregar ${result.errmsg}";
  }

  static Future<String> updateSubscription(Subscription subscription) async {
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

  static Future<String> deleteSubscription(ObjectId uid) async {
    final collection = await _getCollection();
    var result = await collection!.deleteOne({'_id': uid});

    if (result.isSuccess) {
      return "Subscripcion eliminada correctamente";
    }
    return "Error no se pudo eliminar subscription ${result.errmsg}";
  }

  static Future<Subscription> getSubscription(ObjectId uid) async {
    final collection = await _getCollection();
    var result = await collection!.findOne({'_id': uid});

    return Subscription.fromMapObject(result!);
  }

  static Future<List<Subscription>> getSubscriptionsList() async {
    final collection = await _getCollection();

    final lookupClients = Lookup(
        from: "clients",
        localField: "clients",
        foreignField: "_id",
        as: "clients");

    final lookupAccount = Lookup(
        from: "account",
        localField: "account",
        foreignField: "_id",
        as: "account");

    final pipeline = AggregationPipelineBuilder()
        .addStage(lookupClients)
        //.addStage(unwind)
        .addStage(lookupAccount)
        //.addStage(unwind2)
        .build();

    var result = await collection?.aggregateToStream(pipeline).toList();
    return result!
        .map((subscription) => Subscription.fromMapObject(subscription))
        .toList();
  }

  static Future<String> requestLastSubscription() async {
    final collection = await _getCollection();
    final result = await collection!.find().last;

    if (!isNotNull(result)) {
      return '000000001';
    }

    String codSubscription = result['cod_subscription'];
    var numberSubs = codSubscription.split('-')[1];

    var numeracion = (int.parse(numberSubs) + 1);
    numberSubs = numeracion.toString().padLeft(8, '0');
    return numberSubs;
  }
}
