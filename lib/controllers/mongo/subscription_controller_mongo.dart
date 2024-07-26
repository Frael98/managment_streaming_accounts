import 'dart:developer';

import 'package:f_managment_stream_accounts/db/mongo/mongo_db.dart';
import 'package:f_managment_stream_accounts/models/account.dart';
import 'package:f_managment_stream_accounts/models/subscription.dart';
import 'package:f_managment_stream_accounts/utils/helpful_functions.dart';
//import 'package:f_managment_stream_accounts/utils/result_pattern.dart';
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

  ///Crear la subscripcion
  static Future<String> addSubscription(Subscription subscription) async {
    final collection = await _getCollection();
    var result = await collection!.insertOne(subscription.toMap());

    if (result.isSuccess) {
      return "Subscripcion agregada correctamente";
    }
    return "Error no se pudo agregar ${result.errmsg}";
  }

  /// Actualizar Subscripcion
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

  ///Eliminar subscripcion fisica
  static Future<String> deleteSubscription(ObjectId uid) async {
    final collection = await _getCollection();
    var result = await collection!.deleteOne({'_id': uid});

    if (result.isSuccess) {
      return "Subscripcion eliminada correctamente";
    }
    return "Error no se pudo eliminar subscription ${result.errmsg}";
  }

  ///Obtener una Subscripcion
  static Future<Subscription> getSubscription(ObjectId uid) async {
    final collection = await _getCollection();
    //var result = await collection!.findOne({'_id': uid});
    final match = Match({'_id': uid});
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

    final lookupPlatform = Lookup(
        from: "platform",
        localField: "account.platform",
        foreignField: "_id",
        as: "platform");

    final lookupTypeAccount = Lookup(
        from: "type_account",
        localField: "account.type_account",
        foreignField: "_id",
        as: "type_account");

    final pipeline = AggregationPipelineBuilder()
        .addStage(match)
        .addStage(lookupClients)
        .addStage(lookupAccount)
        .addStage(Unwind(const Field(
            'account'))) // unwind solo porque es solo un objeto necesario
        .addStage(lookupPlatform)
        .addStage(lookupTypeAccount)
        .addStage(ReplaceRoot({
          "\$mergeObjects": [
            "\$\$ROOT",
            {
              "account": {
                "\$arrayElemAt": [
                  {
                    "\$map": {
                      "input": ["\$account"],
                      "as": "acc",
                      "in": {
                        "\$mergeObjects": [
                          "\$\$acc",
                          {"platform": "\$platform"},
                          {"type_account": "\$type_account"}
                        ]
                      }
                    }
                  },
                  0
                ]
              }
            }
          ]
        }))
        .addStage(Unwind(const Field(
            'account.platform'))) // unwind solo porque es solo un objeto necesario
        .addStage(Unwind(const Field('account.type_account')))
        .build();

    var result = await collection!.aggregateToStream(pipeline).first;
    return Subscription.fromMapObject(result);
  }

  ///Obtener la lista de Subscripciones
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

    final lookupPlatform = Lookup(
        from: "platform",
        localField: "account.platform",
        foreignField: "_id",
        as: "platform");

    final lookupTypeAccount = Lookup(
        from: "type_account",
        localField: "account.type_account",
        foreignField: "_id",
        as: "type_account");

    final pipeline = AggregationPipelineBuilder()
        .addStage(lookupClients)
        .addStage(lookupAccount)
        .addStage(Unwind(const Field(
            'account'))) // unwind solo porque es solo un objeto necesario
        .addStage(lookupPlatform)
        .addStage(lookupTypeAccount)
        .addStage(ReplaceRoot({
          "\$mergeObjects": [
            "\$\$ROOT",
            {
              "account": {
                "\$arrayElemAt": [
                  {
                    "\$map": {
                      "input": ["\$account"],
                      "as": "acc",
                      "in": {
                        "\$mergeObjects": [
                          "\$\$acc",
                          {"platform": "\$platform"},
                          {"type_account": "\$type_account"}
                        ]
                      }
                    }
                  },
                  0
                ]
              }
            }
          ]
        }))
        .addStage(Unwind(const Field(
            'account.platform'))) // unwind solo porque es solo un objeto necesario
        .addStage(Unwind(const Field(
            'account.type_account'))) // unwind solo porque es solo un objeto necesario
        .build();

    var result = await collection?.aggregateToStream(pipeline).toList();
    return result!
        .map((subscription) => Subscription.fromMapObject(subscription))
        .toList();
  }

  /// Obtener ultima subscripcion
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

  /// Consultar Id cuentas list en con Subscripciones
  static Future<List<Account>> getAccountWithSubscription() async {
    final collection = await _getCollection();
    final result = await collection!.find().toList();

    return result.map((s) => Account.uid(uid: s['account'])).toList();
  }
}
