import 'dart:developer';

import 'package:f_managment_stream_accounts/db/mongo/mongo_db.dart';
import 'package:f_managment_stream_accounts/models/platform.dart';
import 'package:mongo_dart/mongo_dart.dart';

class PlatformControllerMongo {
  static Future<DbCollection?> _getCollection() async {
    try {
      final db = await MongoConnection().getConnection();
      await db!.open();

      return db.collection("platform");
    } catch (e) {
      log("Error obteniendo collection platform: $e");
      /* Future.delayed(const Duration(seconds: 5), () {
        _getCollection();
      }); */
    }
    return null;
  }

  ///Obtener listado de plataformas
  static Future<List<Platform>> getPlatforms() async {
    final platformCollection = await _getCollection();
    var result = await platformCollection!.find().toList();

    log(result.first.toString());
    return result.map((platform) => Platform.fromMap(platform)).toList();
  }

  /// Agregar Plataforma
  static Future<String> addPlatform(Platform platform) async {
    final platformCollection = await _getCollection();
    var result = await platformCollection!.insertOne(platform.toMap());

    if (result.isSuccess) {
      return "Plataforma agregada correctamente";
    }

    log(result.toString());
    return "Error no se pudo agregar plataforma ${result.errmsg}"; //Platform.fromMap(result.document!);
  }

  static Future<String> updatePlatform(Platform platform) async {
    final platformCollection = await _getCollection();
    var result = await platformCollection!.updateOne(
      where.eq("_id", platform.uid),
      modify
          .set('name_platform', platform.namePlatform)
          .set('description', platform.description)
          .set('updated_at', platform.updatedAt),
    );

    if (result.isSuccess) {
      return "Plataforma actualizada correctamente";
    }

    log(result.toString());
    return "Error no se pudo actualizar plataforma ${result.errmsg}";
  }

  static Future<String> deletePlatform(ObjectId uid) async {
    final platformCollection = await _getCollection();
    var result = await platformCollection!.deleteOne({'_id': uid});

    if (result.isSuccess) {
      return "Plataforma eliminada correctamente";
    }

    log(result.toString());
    return "Error no se pudo eliminar plataforma ${result.errmsg}";
  }

  static Future<Platform> getPlatform(ObjectId uid) async {
    final platformCollection = await _getCollection();
    var result = await platformCollection!.findOne({'_id': uid});

    return Platform.fromMap(result!);
  }
}
