import 'package:calculadoraimcflutter/db/db_sqlite.dart';
import 'package:sqflite/sqflite.dart';

class HeightService {
  late Database db;

  Future<void> add(double height) async {
    db = await DB.instance.database;

    await db.rawInsert("INSERT INTO height (height) VALUES (?)", [height]);
  }

  Future<double> getOne() async {
    db = await DB.instance.database;
    final response =
        await db.rawQuery("SELECT height FROM height WHERE id = 1");

    double height = 1.0;

    for (var element in response) {
      height = double.parse(element['height'].toString());
    }

    return height;
  }
}
