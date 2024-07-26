import 'dart:async';
import 'dart:developer';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

/// Conectamos a la base MSA, se crea si no existe
Future<Database> connectToDb() async {
  // Open the database and store the reference.
  final database = openDatabase(join(await getDatabasesPath(), 'MSA.db'), version: 1);

  return database;
}

/// Creacion de tablas
void initOrCreateTables() async {
  //Obtenemos la conexion
  final db = await connectToDb();

  try {
    db.execute('CREATE TABLE USER('
        ' IDUSER INTEGER PRIMARY KEY, NAME TEXT, LASTNAME TEXT, USER TEXT,'
        ' EMAIL TEXT, AGE INT, PASSWORD TEXT, STATE TEXT, CREATED_AT DATETIME, UPDATED_AT DATETIME, DELETED_AT DATETIME); ');

    log('La tabla USER se ha creado correctamente.');
  } catch (e) {
    log('Hubo un error al crear la tabla: $e');
  }

  try {
    db.execute('CREATE TABLE CLIENT('
        ' ID_CLIENT INTEGER PRIMARY KEY, NAME_CLIENT TEXT, NUMBER_PHONE TEXT, DIRECTION TEXT,'
        ' EMAIL TEXT, STATE TEXT, CREATED_AT DATETIME, UPDATED_AT DATETIME, DELETED_AT DATETIME); ');

    log('La tabla CLIENT se ha creado correctamente.');
  } catch (e) {
    log('Hubo un error al crear la tabla: $e');
  }

  try {
    db.execute('CREATE TABLE ACCOUNT('
        ' ID_ACCOUNT INTEGER PRIMARY KEY, EMAIL TEXT, PASSWORD TEXT, REGISTER_DATE DATETIME,'
        ' EXPIRE_DATE DATETIME, PLATFORM TEXT, TYPE_ACCOUNT TEXT, PERFIL_QUANTITY INT'
        ' , STATE TEXT, CREATED_AT DATETIME, UPDATED_AT DATETIME, DELETED_AT DATETIME);');

    log('La tabla ACCOUNT se ha creado correctamente.');
  } catch (e) {
    log('Hubo un error al crear la tabla: $e');
  }


  try {
    db.execute('CREATE TABLE TYPE_ACCOUNT('
        ' ID_TYPE_ACCOUNT INTEGER PRIMARY KEY, NAME_TYPE_ACCOUNT TEXT);');

    log('La tabla TYPE_ACCOUNT se ha creado correctamente.');
  } catch (e) {
    log('Hubo un error al crear la tabla: $e');
  }
}
