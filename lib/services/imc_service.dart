import 'package:sqflite/sqflite.dart';
import '../../db/db_sqlite.dart';

class ImcService {
  late Database db;

  Future<void> add(double weight, String result) async {
    db = await DB.instance.database;

    db.rawInsert("INSERT INTO imc (weight, result, height_id) VALUES (?,?,?)",
        [weight, result, 1]);
  }

  Future<List<Map<String, dynamic>>> getAll() async {
    db = await DB.instance.database;

    final response =
        await db.rawQuery('''SELECT i.id, i.weight, i.result, h.height
          FROM imc AS i 
          INNER JOIN height AS h 
          ON i.height_id = h.id
        ''');

    final list = <Map<String, dynamic>>[];

    for (var element in response) {
      list.add({
        'id': double.parse(element['id'].toString()),
        'weight': double.parse(element['weight'].toString()),
        'height': double.parse(element['height'].toString()),
        'result': element['result'].toString(),
      });
    }

    return list;
  }

  Future<void> delete(int id) async {
    db = await DB.instance.database;

    await db.rawDelete("DELETE FROM imc WHERE id = ?", [id]);
  }
}
