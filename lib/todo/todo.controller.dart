import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:todo_webservice/todo/todo.service.dart';

import 'todo.model.dart';

class TodoController {
  final TodoService _todoService = GetIt.instance<TodoService>();

  Map<String, String> headers = {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Request-Headers': '*',
    'content-type': 'application/json',
    'Cache-Control': 'public, max-age=604800',
  };

  Handler get handler {
    final router = Router();






    //get all todos
    router.get('/todos', (Request request) async {
      headers.addAll({'Access-Control-Allow-Methods': 'GET, OPTIONS'});
      final _todoRes = await _todoService.getAllTodos();
      var _todos = todoFromMap(_todoRes);

      return Response.ok(
          jsonEncode({
            'status': true,
            'message': 'List of all todos',
            'data': jsonDecode(todoToMap(_todos)),
          }),
          headers: headers);
    });






    //get todo by todo id
    router.get('/todo/<id>', (Request request, String param) async {
      headers.addAll({'Access-Control-Allow-Methods': 'GET, OPTIONS'});

      final _todoRes = await _todoService.getTodoById(param);
      print(_todoRes);
      var datum = Datum.fromMap(_todoRes);
      print(datum.toMap().toString());
      return Response.ok(
          jsonEncode({
            'status': true,
            'message': 'Todo with id $param',
            'data': datum.toMap(),
          }),
          headers: headers);
    });







    //create a todo
    router.post('/todo', (Request request) async {
      headers.addAll({'Access-Control-Allow-Methods': 'POST, OPTIONS'});

      final _todos = await _todoService
          .createTodo(jsonDecode(await request.readAsString()));

      if (_todos.isSuccess) {
        return Response.ok(
            jsonEncode({
              'status': true,
              'message': 'created',
              'data': _todos.document,
            }),
            headers: headers);
      }
      return Response(400,
          headers: headers,
          body: {'status': false, 'message': _todos.writeError!.errmsg});
    });







    //update a todo
    router.patch('/todo/<id>', (Request request, String param) async {
      headers.addAll({'Access-Control-Allow-Methods': 'PATCH, OPTIONS'});

      final _todoRes = await _todoService.getTodoById(param);

      var body = await request.readAsString();

      var payload = <String, dynamic>{
        'task': jsonDecode(body)['task'] ??
            _todoRes['task'],
        'completed': jsonDecode(body)['completed'] ??
            _todoRes['completed']
      };

      final _todos = await _todoService.updateTodo(payload, param);

      if (_todos.isSuccess) {
        return Response.ok(
            jsonEncode({
              'status': true,
              'message': 'updated'
            }),
            headers: headers);
      }
      return Response(400,
          headers: headers,
          body: {'status': false, 'message': _todos.writeError!.errmsg});
    });





    //delete a todo
    router.delete('/todo/<id>', (Request request, String param) async {
      headers.addAll({'Access-Control-Allow-Methods': 'DELETE, OPTIONS'});

      final _todos = await _todoService.deleteTodo(param);

      if (_todos.isSuccess) {
        return Response.ok(
            jsonEncode({
              'status': true,
              'message': 'deleted!'
            }),
            headers: headers);
      }
      return Response(400,
          headers: headers,
          body: {'status': false, 'message': _todos.writeError!.errmsg});
    });




    // You can catch all verbs and use a URL-parameter with a regular expression
    // that matches everything to catch app.
    router.all('/<ignored|.*>', (Request request) {
      return Response.notFound(jsonEncode({
        'status': false,
        'message': 'endpoint <${request.url}> not found'
      }));
    });

    return router;
  }
}
