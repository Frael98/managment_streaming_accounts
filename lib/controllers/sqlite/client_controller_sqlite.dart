import 'dart:developer';

import 'package:f_managment_stream_accounts/db/sqlite/sqlflite_db.dart';
import 'package:f_managment_stream_accounts/models/client.dart';
import 'package:sqflite/sqflite.dart';

class ClientControllerSQLite {
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
        where: 'ID_CLIENT = ?',
        whereArgs: [client.idClient],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  ///Eliminar
  static Future<int> deleteClient(int? idClient) async {
    final dbConnection = await connectToDb();

    return await dbConnection
        .delete('CLIENT', where: 'ID_CLIENT = ?', whereArgs: [idClient]);
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

  ///Obtener solo un cliente
  static Future<Client?> getClient(int? idClient) async {
    final dbConnection = await connectToDb();

    final data = await dbConnection.query('CLIENT', where: 'ID_CLIENT = ?', whereArgs: [idClient]);

    if (data.isEmpty) {
      log('No existen registros');
      return null;
    }
    return Client.fromMap(data.first);
  }
}
