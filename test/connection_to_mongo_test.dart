// ignore_for_file: avoid_print

import 'package:f_managment_stream_accounts/models/account.dart';
//import 'package:f_managment_stream_accounts/models/platform.dart';
import 'package:mongo_dart/mongo_dart.dart';

void main() async {
  try {
    Db db = Db('mongodb://localhost:27017/msi_dart');
    await db.open();

    /*  print("conexion exitosa");
    print("Consultando datos");

    var libroCollection = db.collection('libro');

    libroCollection.find().forEach((e) => print(e.toString()));
    var libros = await libroCollection.find().toList();

    print(libros.first.toString());
    var libro = libros.first;
    print(libro['_id']);

    var otrolibro =
        await libroCollection.find(where.eq("_id", libro['_id'])).toList();

    print("Busqueda de libro por object_id");
    print(otrolibro.first.toString());

    print('/******************* lookup */');
    final lookup = Lookup(
        from: 'usuario',
        localField: 'id_usuario',
        foreignField: '_id',
        as: 'usuario');

    final unwind = Unwind(const Field('usuario'));

    final pipeline =
        AggregationPipelineBuilder().addStage(lookup).addStage(unwind).build();

    var result = await libroCollection.aggregateToStream(pipeline).toList();

    for (var e in result) {
      print(e.toString());
    } */
    /* var plataformCollection = db.collection('platform');

    print('/******************* PRUEBAS INSERT MONGO ****************/');

    Platform p = Platform(namePlatform: 'test', description: 'resting');

    var result = await plataformCollection.insertOne(p.toMap());

    print(result.document!);

    var fromMap = Platform.fromMap(result.document!);

    print(fromMap.toString());

    print('/******************* PRUEBAS UPDATE MONGO ****************/');

    var plataforma = await plataformCollection.findOne({'_id': fromMap.uid});

    print(plataforma.toString());

    var objPlatform = Platform.fromMap(plataforma!);

    print(objPlatform.toString()); */

    //var collectionAccount = db.collection('account');
    var collection = db.collection('subscription');
    /* 

    final lookupTypeAccount = Lookup(
        from: "type_account",
        localField: "type_account",
        foreignField: "_id",
        as: "type_account");

    final lookupPlatform = Lookup(
        from: "platform",
        localField: "platform",
        foreignField: "_id",
        as: "platform");

    final unwind = Unwind(const Field('type_account'));
    final unwind2 = Unwind(const Field('platform'));

    final pipeline = AggregationPipelineBuilder()
        .addStage(lookupTypeAccount)
        .addStage(unwind)
        .addStage(lookupPlatform)
        .addStage(unwind2)
        .build();

    var result = await collectionAccount.aggregateToStream(pipeline).toList(); */

    //final match = Match({'_id': ObjectId.fromHexString('665e7d97b0f84e9183cbf54d')});

    /* final match = Match({
      'state': {
        '\$nin': ['caida', 'ocupada']
      }
    }); */

    /* final lookupTypeAccount = Lookup(
        from: "type_account",
        localField: "type_account",
        foreignField: "_id",
        as: "type_account");

    final lookupPlatform = Lookup(
        from: "platform",
        localField: "platform",
        foreignField: "_id",
        as: "platform");

    final unwind = Unwind(const Field('type_account'));
    final unwind2 = Unwind(const Field('platform'));

    final pipeline = AggregationPipelineBuilder()
        .addStage(match)
        .addStage(lookupTypeAccount)
        .addStage(unwind)
        .addStage(lookupPlatform)
        .addStage(unwind2)
        .build(); */

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
        .addStage(Unwind(const Field('account')))
        .addStage(lookupPlatform)
        //.addStage(Unwind(const Field('platform')))
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
        .build();

    //var result = await collection?.aggregateToStream(pipeline).toList();
    var result = await collection.aggregateToStream(pipeline).toList();

    print(result);
    for (var element in result) {
      //print(Account.fromMapObject(element).toString());
      print(element.toString());
    }
    await db.close();

    print("Conexion cerrada");
  } catch (e) {
    print("message $e");
  }
}
