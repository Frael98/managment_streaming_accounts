import 'dart:developer';

import 'package:f_managment_stream_accounts/db/database.dart';
import 'package:f_managment_stream_accounts/models/client.dart';
import 'package:sqflite/sqflite.dart';

class ClientController {
  ///Registrar
  static Future<int> addClient(Client client) async {
    final dbConnection = await connectToDb();

    return await dbConnection.insert('CLIENT', client.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  ///Actualizar
  static Future<int> updateClient(Client client) async {
    final dbConnection = await connectToDb();

    return await dbConnection.update('CLIENT', client.toMap(),
        where: 'idClient = ?',
        whereArgs: [client.idClient],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  ///Eliminar
  static Future<int> deleteClient(Client client) async {
    final dbConnection = await connectToDb();

    return await dbConnection
        .delete('CLIENT', where: 'idClient = ?', whereArgs: [client.idClient]);
  }

  ///Listar
  static Future<List<Client>?> getClients() async {
    final dbConnection = await connectToDb();

    final data = await dbConnection.query('CLIENT');

    if (data.isEmpty) {
      log('No existen registros');
      return null;
    }

    //return List.generate(data.length, (index) => Client.fromMap(data[index]));
    return data.map((client) => Client.fromMap(client)).toList();
  }
}
