import 'package:sqflite/sqflite.dart';

Future<bool> existDb(Database db, String tablaNombre) async {
  final List<Map<String, dynamic>> tablas = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table' AND name='$tablaNombre'");
  return tablas.isNotEmpty;
}
