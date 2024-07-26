/* Usuario del sistema */
import 'package:f_managment_stream_accounts/interfaces/entity.dart';
import 'package:mongo_dart/mongo_dart.dart';

class User extends Entity {
  String? name;
  String? lastname;
  String? user;
  String? email;
  int? age;
  String? password;

  User({
    ObjectId? uid,
    int? id,
    required this.name,
    required this.lastname,
    required this.user,
    required this.email,
    this.age,
    required this.password,
    state,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) : super(
            uid: uid,
            id: id,
            state: state,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt);

  User.validation(this.user, this.password);
  User.audit({id, state, createdAt, updatedAt, deletedAt});

  // Método para convertir la instancia de la clase a un mapa
  @override
  Map<String, dynamic> toMap() {
    return {
      'user': user,
      'name': name,
      'lastname': lastname,
      'age': age,
      'email': email,
      'password': password,
      'state': state,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
        uid: map['_id'],
        id: map['IDUSER'] ?? map['id_user'],
        name: map['NAME'] ?? map['name'],
        lastname: map['LASTNAME'] ?? map['lastname'],
        user: map['USER'] ?? map['user'],
        email: map['EMAIL'] ?? map['email'],
        age: map['AGE'] ?? map['age'],
        password: map['PASSWORD'] ?? map['password']);
  }

  factory User.fromMapAudit(Map<String, dynamic> map) {
    return User.audit(
        id: map['IDUSER'],
        state: map['STATE'],
        createdAt: map['CREATED_AT'],
        updatedAt: map['UPDATED_AT'],
        deletedAt: map['DELETED_AT']);
  }

   factory User.fromMapAuditForSQLite(Map<String, dynamic> map) {
    return User.audit(
        id: map['IDUSER'],
        state: map['STATE'],
        createdAt: DateTime.parse(map['CREATED_AT']),
        updatedAt: DateTime.parse(map['UPDATED_AT']),
        deletedAt: DateTime.parse(map['DELETED_AT']));
  }

  // each User when using the print statement.
  @override
  String toString() {
    return 'User {id: $id name: $name, user: $user, lastname: $lastname, email: $email, password: $password, created_at: $createdAt}';
  }

  @override
  Map<String, dynamic> toMapForSQLite() {
    return {
      'user': user,
      'name': name,
      'lastname': lastname,
      'age': age,
      'email': email,
      'password': password,
      'state': state,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }
}
