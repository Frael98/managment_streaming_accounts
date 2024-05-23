import 'dart:developer';

import 'package:mongo_dart/mongo_dart.dart';

void main() async {
  Db db = Db('mongodb://frael:root@localhost:27017/');

  try {
    await db.open();

    print("conexion exitosa");
    print("Consultando datos");

    var userCollection = db.collection('user');
    await userCollection.find().forEach((element) {
      print(element.toString());
    });

    await db.close();
    print("Conexion cerrada");
  } catch (e) {
    log("message $e");
  }
}
