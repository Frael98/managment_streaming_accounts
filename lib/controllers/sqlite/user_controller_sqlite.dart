import 'dart:developer';

import 'package:f_managment_stream_accounts/db/sqlite/sqlflite_db.dart';
import 'package:f_managment_stream_accounts/models/user.dart';
import 'package:sqflite/sqflite.dart';

class UserControllerSQLite {
  ///Registrar
  static Future<int> addUser(User user) async {
    final dbConnection = await connectToDb();

    return await dbConnection.insert('USER', user.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  ///Actualizar
  static Future<int> updateUser(User user) async {
    final dbConnection = await connectToDb();

    return await dbConnection.update('USER', user.toMap(),
        where: 'idUser = ?',
        whereArgs: [user.idUser],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  ///Eliminar
  static Future<int> deleteUser(User user) async {
    final dbConnection = await connectToDb();

    return await dbConnection
        .delete('USER', where: 'idUser = ?', whereArgs: [user.idUser]);
  }

  ///Listar usuarios
  static Future<List<User>?> getUsers() async {
    final dbConnection = await connectToDb();

    final data = await dbConnection.query('USER');

    if (data.isEmpty) {
      log('No existen registros');
      return null;
    }

    //return List.generate(data.length, (index) => User.fromMap(data[index]));
    return data.map((user) => User.fromMap(user)).toList();
  }

  /// Iniciar Sesion
  static Future<User?> logIn(User user) async {
    final dbConnection = await connectToDb();

    final data = await dbConnection.query('USER',
        where: 'USER = ? AND PASSWORD = ?',
        whereArgs: [user.user, user.password]);

    if (data.isEmpty) {
      log('No existen registros');
      return null;
    }

    log(data.first.toString());
    //return List.generate(data.length, (index) => User.fromMap(data[index]));
    return User.fromMap(data.first);
  }
}
