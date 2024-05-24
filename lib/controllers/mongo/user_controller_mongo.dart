import 'dart:developer';

import 'package:f_managment_stream_accounts/db/mongo/mongo_db.dart';
import 'package:f_managment_stream_accounts/models/user.dart';
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

  Future<int> addClient(User user) async {
    final userCollection = await getUserCollection();
    var result = await userCollection!.insertOne(user.toMap());

    return result.nInserted;
  }

  static Future<User?> logIn(User user) async {
    final userCollection = await getUserCollection();
    var userLoged = await userCollection
        ?.findOne({"user": user.user, "password": user.password});

    return User.fromMap(userLoged!);
  }
}
