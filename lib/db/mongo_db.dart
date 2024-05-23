import 'dart:developer';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mongo_dart/mongo_dart.dart';

Future loadDotEnv() async {
  await dotenv.load(fileName: ".env");
}

class MongoConnection {
  
  String? _host;
  String? _port;
  String? _dbName;
  Db? _db;

  Future<Db?> getConnection() async {
    if (_db == null) {
      try {
        _db = await Db.create(await _getConnectionString());
      } catch (e) {
        log("Error getConnection: $e");
      }
    }
    return _db;
  }

  Future<String> _getConnectionString() async {
    await loadDotEnv();
    _host = dotenv.env['MONGO_HOST']!;
    _port = dotenv.env['MONGO_PORT']!;
    _dbName = dotenv.env['MONGO_DB']!;
    return "$_host:$_port/$_dbName";
  }

  void closeConnection() {
    _db?.close();
  }

  static void main() async {
    final db = await MongoConnection().getConnection();

    try {
      await db!.open();
      var userCollection = db.collection('user');
      await userCollection.find().forEach((element) {
        log(element.toString());
      });
    } catch (e) {
      log("Error main: $e");
    }
  }
}
