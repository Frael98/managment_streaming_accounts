/* Usuario del sistema */
import 'package:f_managment_stream_accounts/interfaces/entity.dart';

class User extends Entity {
  
  int? idUser;
  final String name;
  final String lastname;
  final String user;
  final String email;
  final int? age;
  final String password;

  User({
    required this.name,
    required this.lastname,
    required this.user,
    required this.email,
    this.age,
    required this.password
  });

  // Método para convertir la instancia de la clase a un mapa
  Map<String, dynamic> toMap() {
    return {
      'user': user,
      'name': name,
      'lastname' : lastname,
      'age': age,
      'email': email,
      'password': password
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Dog{id: $idUser name: $name, age: $age}';
  }
}
