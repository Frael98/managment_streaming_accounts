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
      {ObjectId? uid, int? id, required this.namePlatform, this.description})
      : super(uid: uid, id: id);
  Platform.id({id});

  @override
  Map<String, dynamic> toMap() {
    return {
      'name_platform': namePlatform,
      'description': description,
    };
  }

  @override
  factory Platform.fromMap(Map<String, dynamic> map) {
    return Platform(
      uid: map['_id'],
      id: map['id_platform'] ?? map['ID_PLATFORM'],
      namePlatform: map['name_platform'] ?? map['NAME_PLATFORM'],
      description: map['description'] ?? map['DESCRIPTION'],
    );
  }

  @override
  String toString() {
    return "uid(MongoId): $uid, id(SQLite): $id, namePlatform: $namePlatform, description: $description";
  }
  
  @override
  Map<String, dynamic> toMapForSQLite() {
    // TODO: implement toMapForSQLite
    throw UnimplementedError();
  }
}
