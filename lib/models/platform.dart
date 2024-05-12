/* 
  Indica el tipo de plataforma
  Ejemplo:
  Netflix
  Disney
  Amazon Prime
  HBO
 */
import 'package:f_managment_stream_accounts/interfaces/entity.dart';

class Platform extends Entity {
  
  int? idPlatform;
  String nameService;

  Platform({this.idPlatform, required this.nameService});

  Map<String, dynamic> toMap() {
    // alias: toJson
    return {
      'idPlatform': idPlatform,
      'nameService': nameService,
    };
  }

  factory Platform.fromMap(Map<String, dynamic> map) {
    return Platform(
        idPlatform: map['idPlatform'],
        nameService: map['nameService'],
        );
  }
}