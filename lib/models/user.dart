/* Usuario del sistema */
import 'package:f_managment_stream_accounts/interfaces/entity.dart';

class User extends Entity {
  int? idUser;
  String? name;
  String? lastname;
  String? user;
  String? email;
  int? age;
  String? password;

  User({
    this.idUser,
    required this.name,
    required this.lastname,
    required this.user,
    required this.email,
    this.age,
    required this.password,
    String? state,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) : super(
            state: state,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt);

  User.validation(this.user, this.password);
  User.audit({this.idUser, state, createdAt, updatedAt, deletedAt});

  // Método para convertir la instancia de la clase a un mapa
  Map<String, dynamic> toMap() {
    // alias: toJson
    return {
      'user': user,
      'name': name,
      'lastname': lastname,
      'age': age,
      'email': email,
      'password': password,
      'state': state,
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
        idUser: map['IDUSER'] ?? map['id_user'],
        name: map['NAME'] ?? map['name'],
        lastname: map['LASTNAME'] ?? map['lastname'],
        user: map['USER'] ?? map['user'],
        email: map['EMAIL'] ?? map['email'],
        age: map['AGE'] ?? map['age'],
        password: map['PASSWORD'] ?? map['password']);
  }

  factory User.fromMapAudit(Map<String, dynamic> map) {
    return User.audit(
        idUser: map['IDUSER'],
        state: map['STATE'],
        createdAt: map['CREATED_AT'],
        updatedAt: map['UPDATED_AT'],
        deletedAt: map['DELETED_AT']);
  }

  // Implement toString to make it easier to see information about
  // each User when using the print statement.
  @override
  String toString() {
    return 'User {id: $idUser name: $name, user: $user, lastname: $lastname, email: $email, password: $password, created_at: $createdAt}';
  }
}
