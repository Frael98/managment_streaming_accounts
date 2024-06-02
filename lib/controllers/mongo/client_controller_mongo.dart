import 'dart:developer';

import 'package:f_managment_stream_accounts/db/mongo/mongo_db.dart';
import 'package:f_managment_stream_accounts/models/client.dart';
import 'package:mongo_dart/mongo_dart.dart';

/// Cliente Controlador
class ClientControllerMongo {
  ClientControllerMongo();

  static Future<DbCollection?> getClientCollection() async {
    Db? db;
    try {
      db = await MongoConnection().getConnection();
      await db!.open();

      return db.collection('clients');
    } catch (e) {
      log("Error consiguiendo collection client: $e");
    }

    return null;
  }

  /// Agregar un cliente
  static Future<String> addClient(Client client) async {
    var clientCollection = await getClientCollection();
    var result = await clientCollection!.insertOne(client.toMap());

    if (result.isSuccess) {
      return "Cliente agregado correctamente";
    }
    return "Error no se pudo agregar el cliente ${client.nameClient}";
  }

  /// Obtener todos los clientes
  static Future<List<Client>> getClients() async {
    var clientCollection = await getClientCollection();
    var result = await clientCollection!.find().toList();
    //log(result.first.toString());
    return result.map((client) => Client.fromMap(client)).toList();
  }

  ///Buscar un cliente por el id
  static Future<Client> getClient(ObjectId uid) async {
    var clientCollection = await getClientCollection();
    var client = await clientCollection!.findOne({"_id": uid});

    log(client.toString());
    return Client.fromMap(client!);
  }

  ///Actualizar un cliente por id
  static Future<String> updateClient(Client client) async {
    final clientCollection = await getClientCollection();
    var result = await clientCollection!.updateOne(
      where.eq('_id', client.uid),
      modify
          .set('name_client', client.nameClient)
          .set('number_phone', client.numberPhone)
          .set('direction', client.direction)
          .set('email', client.email)
          .set('updated_at', client.updatedAt),
    );

    if (result.isSuccess) {
      return "Cliente actualizado correctamente";
    }
    return "Error no se pudo actualizar el cliente ${result.errmsg}";
  }
}
