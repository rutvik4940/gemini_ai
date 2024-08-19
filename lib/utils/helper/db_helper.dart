import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../../screen/history/model/db_model.dart';

class DbHelper {
  static final DbHelper helper = DbHelper._();
  DbHelper._();

  Database? db;

  Future<Database> checkDb() async {
    if (db != null) {
      return db!;
    } else {
      db = await initDb();
      return db!;
    }
  }

  Future<Database> initDb() async {
    Directory dir = await getApplicationSupportDirectory();
    String path = join(dir.path, "gemini.db");

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        String query =
            "CREATE TABLE gemini(id INTEGER PRIMARY KEY AUTOINCREMENT, text TEXT)";
        db.execute(query);
      },
    );
  }

  Future<void> insert(DbModel dbModel) async {
    db = await checkDb();
    await db!.insert("gemini", {"text": dbModel.text});
  }

  Future<List<DbModel>> read() async {
    db = await checkDb();
    String query = "SELECT * FROM gemini";
    List<Map<String, dynamic>> list = await db!.rawQuery(query);
    List<DbModel> dataList = list.map((e) => DbModel.mapToModel(e)).toList();
    return dataList;
  }

  Future<void> delete(int id) async {
    db = await checkDb();
    await db!.delete("gemini", where: "id = ?", whereArgs: [id]);
  }
}
