// ignore_for_file: avoid_print

import 'dart:io';
import 'dart:typed_data';

import 'package:f_managment_stream_accounts/models/account.dart';
//import 'package:f_managment_stream_accounts/models/platform.dart';
import 'package:mongo_dart/mongo_dart.dart';

void main() async {
  try {
    Db db = Db('mongodb://localhost:27017/msi_dart');
    await db.open();
    //Obtenemos la conexion a gridFS
    final gridfs = GridFS(db);

    File file = File('temp_image.txt');

    await file.writeAsString('This es un contenido');
    final result = await gridfs.chunks.updateOne(
        where.eq('file_id', ObjectId.fromHexString('669b11d9597aa634fc000000')),
        modify.set('data', file.openRead()));

    await db.close();

    print(result.isSuccess);
    print("Conexion cerrada");
  } catch (e) {
    print("message $e");
  }
}
