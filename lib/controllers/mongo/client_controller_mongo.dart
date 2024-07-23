import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:f_managment_stream_accounts/db/mongo/mongo_db.dart';
import 'package:f_managment_stream_accounts/models/client.dart';
import 'package:mongo_dart/mongo_dart.dart';

/// Cliente Controlador
class ClientControllerMongo {
  ClientControllerMongo();

  static Future<DbCollection?> _getClientCollection() async {
    Db? db;
    try {
      db = await MongoConnection().getConnection();
      await db!.open();

      return db.collection('clients');
    } catch (e) {
      log("Error consiguiendo collection client: $e");
    }

    return null;
  }

  /// Agregar un cliente
  static Future<String> addClient(Client client) async {
    var clientCollection = await _getClientCollection();
    var result = await clientCollection!.insertOne(client.toMap());

    if (result.isSuccess) {
      return "Cliente agregado correctamente";
    }
    return "Error no se pudo agregar el cliente ${client.nameClient}";
  }

  /// Obtener todos los clientes
  static Future<List<Client>> getClients() async {
    var clientCollection = await _getClientCollection();
    var result = await clientCollection!.find().toList();
    //log(result.first.toString());
    return result.map((client) => Client.fromMap(client)).toList();
  }

  ///Buscar un cliente por el id
  static Future<Client> getClient(ObjectId uid) async {
    var clientCollection = await _getClientCollection();
    var client = await clientCollection!.findOne({"_id": uid});

    log(client.toString());
    return Client.fromMap(client!);
  }

  ///Actualizar un cliente por id
  static Future<String> updateClient(Client client) async {
    final clientCollection = await _getClientCollection();
    var result = await clientCollection!.updateOne(
      where.eq('_id', client.uid),
      modify
          .set('name_client', client.nameClient)
          .set('number_phone', client.numberPhone)
          .set('direction', client.direction)
          .set('email', client.email)
          .set('updated_at', client.updatedAt)
          .set('imagen_id', client.imagen),
    );

    if (result.isSuccess) {
      return "Cliente actualizado correctamente";
    }
    return "Error no se pudo actualizar el cliente ${result.errmsg}";
  }

  static Future<String> deleteClient(ObjectId uid) async {
    final collection = await _getClientCollection();
    var result = await collection!.deleteOne({'_id': uid});

    if (result.isSuccess) {
      return "Cliente eliminada correctamente";
    }
    return "Error no se pudo eliminar cliente ${result.errmsg}";
  }

  ///Guardar imagen de cliente
  static Future<ObjectId> saveImageClient(File file) async {
    Db? db = await MongoConnection().getConnection();
    await db!.open();

    final gridfs = GridFS(db);
    // Creamos el archivo
    final fileId =
        gridfs.createFile(file.openRead(), file.path.split('/').last);
    // Guardamos el archivo
    await fileId.save();

    await db.close();

    return fileId.id;
  }

  ///Guardar imagen de cliente
  static Future<String> updateImageClient(File file, ObjectId fileId) async {
    Db? db = await MongoConnection().getConnection();
    await db!.open();

    final gridfs = GridFS(db);

    final result =  await gridfs.chunks.updateOne(where.eq('files_id', fileId), modify.set('data', await file.readAsBytes()));
    //final result = await gridfs.findOne(where.eq('file_id', fileId));

    await db.close();

    return result.isSuccess.toString();
  }

  ///Obtenen imagen de cliente
  static Future<dynamic> getClientImage(ObjectId imageId) async {
    Db? db = await MongoConnection().getConnection();
    await db!.open();

    final gridfs = GridFS(db);
    var file = await gridfs.chunks.findOne(where.eq('files_id', imageId));
    //Obtenenmos los datos  BsonBinary
    BsonBinary data = file!['data'];

    await db.close();
    //Enviamos los datos BsonBinary en tipo byteList
    return Uint8List.fromList(data.byteList);
  }
}
