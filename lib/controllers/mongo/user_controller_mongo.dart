import 'dart:developer';
import 'dart:io';

import 'package:encrypt/encrypt.dart';
import 'package:f_managment_stream_accounts/db/mongo/mongo_db.dart';
import 'package:f_managment_stream_accounts/models/user.dart';
import 'package:f_managment_stream_accounts/utils/my_encrypt.dart';
import 'package:f_managment_stream_accounts/utils/result_pattern.dart';
import 'package:mongo_dart/mongo_dart.dart';

class UserControllerMongo {
  UserControllerMongo();

  static Future<DbCollection?> getUserCollection() async {
    Db? db;
    try {
      db = await MongoConnection().getConnection();
      await db!.open();

      return db.collection('user');
    } catch (e) {
      log("Error consiguiendo collection user: $e");
    }

    return null;
  }

  /// Agregar usuario
  static Future<int> addUser(User user) async {
    //Encriptamos la contraseña dada
    user.password = MyEncrypt.encriptarPassword(user.password!).base16;
    final userCollection = await getUserCollection();
    var result = await userCollection!.insertOne(user.toMap());

    return result.nInserted;
  }

  /// Iniciar sesion
  static Future<Result<User?>> logIn(User user) async {
    //var _tmpPassword = MyEncrypt.desencriptarPassword(user.password!)
    try {
      final userCollection = await getUserCollection();
      var users = await userCollection?.find({
        "user": user.user
        //, "password": user.password
      }).toList();

      if (users!.isEmpty) {
        log("Usuario no existe");
        return Result.failure("Usuario no existe");
      }

      List<User> tmpUsers = users.map((u) => User.fromMap(u)).toList();

      for (var u in tmpUsers) {
        if (MyEncrypt.desencriptarPassword(Key.fromBase16(u.password!)) ==
            user.password) {
              //log('message');
          return Result.success(u);
        } else {
          log("Contraseña incorrecta");
          return Result.failure("Contraseña incorrecta");
        }
      }

      return Result.failure('No existe usuario');
    } catch (e) {
      log('Error en logIn: $e');
      return Result.failure('Error en login controller $e');
    }
  }

  static Future<ObjectId> saveImageUser(File file) async {
    Db? db = await MongoConnection().getConnection();
    await db!.open();

    final gridfs = GridFS(db);
    // Creamos el archivo
    final fileId =
        gridfs.createFile(file.openRead(), file.path.split('/').last);
    // Guardamos el archivo
    await fileId.save();

    await db.close();

    return fileId.id;
  }
}
