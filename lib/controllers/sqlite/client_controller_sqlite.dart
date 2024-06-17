import 'dart:developer';

import 'package:f_managment_stream_accounts/db/sqlite/sqlflite_db.dart';
import 'package:f_managment_stream_accounts/models/client.dart';
import 'package:sqflite/sqflite.dart';

class ClientControllerSQLite {
  ///Registrar
  static Future<String> addClient(Client client) async {
    final dbConnection = await connectToDb();

    var result = await dbConnection.insert('CLIENT', client.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);

    if (result != 0) {
      return "Cliente agregado correctamente";
    }
    return "Error no se pudo actualizar el cliente ${client.id}";
  }

  ///Actualizar
  static Future<String> updateClient(Client client) async {
    final dbConnection = await connectToDb();

    var result = await dbConnection.update('CLIENT', client.toMap(),
        where: 'ID_CLIENT = ?',
        whereArgs: [client.id],
        conflictAlgorithm: ConflictAlgorithm.replace);

    if (result != 0) {
      return "Cliente actualizado correctamente";
    }
    return "Error no se pudo actualizar el cliente ${client.id}";
  }

  ///Eliminar
  static Future<String> deleteClient(int? idClient) async {
    final dbConnection = await connectToDb();

    var result = await dbConnection
        .delete('CLIENT', where: 'ID_CLIENT = ?', whereArgs: [idClient]);

    if (result != 0) {
      return "Cliente eliminado correctamente";
    }
    return "Error no se pudo eliminar el cliente $idClient";
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
  static Future<Client> getClient(int? idClient) async {
    final dbConnection = await connectToDb();

    final data = await dbConnection
        .query('CLIENT', where: 'ID_CLIENT = ?', whereArgs: [idClient]);

    if (data.isEmpty) {
      log('No existen registros');
    }
    return Client.fromMap(data.first);
  }
}
