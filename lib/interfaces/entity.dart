import 'package:mongo_dart/mongo_dart.dart';

/// Entidad - clase con atributos generales para los modelos
abstract class Entity {
  /// Id para MongoDB
  ObjectId? uid;

  /// Id para SQLite
  int? id;
  String? state;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? deletedAt;

  Entity(
      {this.uid,
      this.id,
      this.state,
      this.createdAt,
      this.updatedAt,
      this.deletedAt});
  Map<String, dynamic> toMap();

  /// Metodo creado para inserción de datos tipo date a string
  Map<String, dynamic> toMapForSQLite();
}
