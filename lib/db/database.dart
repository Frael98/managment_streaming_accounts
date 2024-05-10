import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

void initDataBase() {
  createUsetTable();
}

/// Conectamos a la base MSA, se crea si no existe
Future<Database> connectToDb() async {
  // Open the database and store the reference.
  final database = openDatabase(join(await getDatabasesPath(), 'MSA.db'));

  return database;
}

/// Creacion de tablas
void createUsetTable()  async {
  //Obtenemos la conexion
  final db = await connectToDb();

  db.execute('CREATE TABLE USER('
    ' IDUSER INTEGER PRIMARY KEY, NAME TEXT, LASTNAME TEXT, USER TEXT,'
    ' EMAIL TEXT, PASSWORD TEXT); ');
}
