// ignore_for_file: avoid_print

/* 
  Indica el tipo de plataforma
  Ejemplo:
  Netflix
  Disney
  Amazon Prime
  HBO
 */
import 'package:f_managment_stream_accounts/interfaces/entity.dart';
import 'package:mongo_dart/mongo_dart.dart';

class Platform extends Entity {
  String? namePlatform;
  String? description;

  Platform(
      {ObjectId? uid,
      int? id,
      required this.namePlatform,
      this.description,
      state,
      createdAt,
      updatedAt,
      deletedAt})
      : super(
            uid: uid,
            id: id,
            state: state,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt);
  Platform.id({id});
  Platform.uid({uid}):super(uid: uid);

  @override
  Map<String, dynamic> toMap() {
    return {
      'name_platform': namePlatform,
      'description': description,
      'state': state,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt
    };
  }

  @override
  factory Platform.fromMap(Map<String, dynamic> map) {
    try {
      return Platform(
        uid: map['_id'],
        id: map['id_platform'] ?? map['ID_PLATFORM'] ?? 0,
        namePlatform: map['name_platform'] ?? map['NAME_PLATFORM'],
        description: map['description'] ?? map['DESCRIPTION'],
      );
    } catch (e) {
      print('Ocurrió un error durante la conversión del mapa: $e');
      throw const FormatException(
          'Error al convertir el mapa a objeto Platform');
    }
  }

  @override
  String toString() {
    return "Platform(uid(MongoId): $uid, id(SQLite): $id, namePlatform: $namePlatform, description: $description)";
  }

  @override
  Map<String, dynamic> toMapForSQLite() {
    // TODO: implement toMapForSQLite
    throw UnimplementedError();
  }
}
