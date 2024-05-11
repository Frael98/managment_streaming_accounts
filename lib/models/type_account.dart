
import 'package:f_managment_stream_accounts/interfaces/entity.dart';

class TypeAccount extends Entity {
  
  int? idTypeAccount;
  String nameTypeAccount;

  TypeAccount({this.idTypeAccount, required this.nameTypeAccount});

  // Método para convertir la instancia de la clase a un mapa
  Map<String, dynamic> toMap() {
    // alias: toJson
    return {
      'idTypeAccount': idTypeAccount,
      'nameTypeAccount': nameTypeAccount,
    };
  }

  factory TypeAccount.fromMap(Map<String, dynamic> map) {
    return TypeAccount(
        idTypeAccount: map['idTypeAccount'],
        nameTypeAccount: map['nameTypeAccount']);
  }
}