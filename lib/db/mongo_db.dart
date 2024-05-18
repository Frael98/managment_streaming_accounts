import 'dart:developer';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mongo_dart/mongo_dart.dart';

Future loadDotEnv() async {
  await dotenv.load(fileName: ".env");
}

Future<Db> connectMongo() async {
  await loadDotEnv();

  log(dotenv.env['MONGO_URL']! + dotenv.env['MONGO_DB']!);
  var db = Db(dotenv.env['MONGO_URL']! + dotenv.env['MONGO_DB']!);
  return db;
}

Future<void> consultarUsuario() async {
  try {
    var db = await connectMongo();
    await db.open();
    /* 
    log('message');
    var userCollection = db.collection('user');
    userCollection.find().forEach((element) {
      log(element.toString());
    }); */
  } catch (e) {
    log("Error $e");
    log("Stack trace: ${e.toString()}");
  }
}
