import 'dart:developer';

import 'package:f_managment_stream_accounts/db/mongo/mongo_db.dart';
import 'package:f_managment_stream_accounts/models/client.dart';
import 'package:mongo_dart/mongo_dart.dart';

class ClientControllerMongo {
  ClientControllerMongo();

  Future<DbCollection?> getClientCollection() async {
    Db? db;
    try {
      db = await MongoConnection().getConnection();
      await db!.open();

      return db.collection('client');
    } catch (e) {
      log("Error consiguiendo collection client: $e");
    }

    return null;
  }

  Future<int> addClient(Client client) async {
    var clientCollection = await getClientCollection();
    var result = await clientCollection!.insertOne(client.toMap());

    return result.nInserted;
  }
}
