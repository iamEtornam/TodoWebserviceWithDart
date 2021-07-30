import 'package:get_it/get_it.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:todo_webservice/db_connection.dart';

class TodoService {
  final DBConnection _dbConnection = GetIt.instance<DBConnection>();
  final collectionName = 'todos';

  Future<List<Map<String, dynamic>>> getAllTodos() async {
    final connection = await _dbConnection.connection();
    await connection.open();

    var collection = connection.collection(collectionName);
    var res = await collection.find(where.eq('completed', false)).toList();
    print(res);
    await connection.close();
    return res;
  }

  Future<Map<String, dynamic>> getTodoById(String id) async {
    final connection = await _dbConnection.connection();
    await connection.open();

    var collection = connection.collection(collectionName);
    var res = await collection
        .find(where.eq('_id', ObjectId.fromHexString(id)))
        .first;
    await connection.close();
    return res;
  }

  Future<WriteResult> createTodo(Map<String, dynamic> payload) async {
    final connection = await _dbConnection.connection();
    await connection.open();

    var collection = connection.collection(collectionName);
    var res = await collection.insertOne(payload);
    await connection.close();
    return res;
  }

  Future<WriteResult> updateTodo(Map<String, dynamic> payload, String id) async {
    final connection = await _dbConnection.connection();
    await connection.open();

    var collection = connection.collection(collectionName);
    print(payload);
    var res = await collection.updateOne(
        where.eq('_id', ObjectId.fromHexString(id)),
        ModifierBuilder()
            .set('task', payload['task'])
            .set('completed', payload['completed']),writeConcern: WriteConcern
      (w: 'majority', wtimeout: 5000));
    await connection.close();
    return res;
  }

  Future<WriteResult> deleteTodo(String id) 
  async {
    final connection = await _dbConnection.connection();
    await connection.open();

    var collection = connection.collection(collectionName);
    var res = await collection.deleteOne({'_id': ObjectId.fromHexString(id)});
    await connection.close();
    return res;
  }
}
