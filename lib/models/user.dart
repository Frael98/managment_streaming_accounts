/* Usuario del sistema */
import 'package:f_managment_stream_accounts/interfaces/entity.dart';

class User extends Entity {
  
  int? idUser;
  final String name;
  final String lastname;
  final String user;
  final String email;
  final int edad;
  final String password;

  User({
    required this.name,
    required this.lastname,
    required this.user,
    required this.email,
    required this.edad,
    required this.password
  });

  // Método para convertir la instancia de la clase a un mapa
  Map<String, dynamic> toMap() {
    return {
      'user': user,
      'names': name,
      'lastname' : lastname,
      'edad': edad,
      'email': email,
      'password': password
    };
  }
}
