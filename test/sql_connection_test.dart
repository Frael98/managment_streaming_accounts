// ignore_for_file: avoid_print
// SQFLite no soporta testings unitarios, solo sobre plataformas androids
import 'package:f_managment_stream_accounts/db/sqlite/sqlflite_db.dart';
import 'package:f_managment_stream_accounts/models/type_account.dart';
import 'package:flutter_test/flutter_test.dart';

void main() async {
  var db;
  setUpAll(() async {
    initOrCreateTables();
    db = await connectToDb();
  });

  var typeAccount = TypeAccount(nameTypeAccount: 'PREMIUN');

  await db.insert('TYPE_ACCOUNT', typeAccount.toMap());

  final data = await db.query('TYPE_ACCOUNT');

  for (var e in data) {
    print(e.toString());
  }
}
