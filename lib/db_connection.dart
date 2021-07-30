import 'package:mongo_dart/mongo_dart.dart';

class DBConnection {

  Future<Db> connection() async{
    final db = await Db.create('mongodb://localhost:27017/todo_db');
    return db;
  }

  Future cleanupDatabase() async {
    final db = await Db.create('mongodb://localhost:27017/todo_db');
    await db.close();
  }
}