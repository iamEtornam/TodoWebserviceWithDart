import 'dart:io';
import 'package:get_it/get_it.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:todo_webservice/db_connection.dart';
import 'package:todo_webservice/todo/todo.service.dart';

import '../lib/todo/todo.controller.dart' show TodoController;

final getIt = GetIt.instance;

void setup() {
  getIt.registerSingleton<DBConnection>(DBConnection());
  getIt.registerSingleton<TodoService>(TodoService());
  getIt.registerSingleton<TodoController>(TodoController());
}

// For Google Cloud Run, set _hostname to '0.0.0.0'.
const _hostname = 'localhost';

void main() async {
  setup();
  // For Google Cloud Run, we respect the PORT environment variable
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  
  final _todoController = GetIt.instance<TodoController>();
  // Create server

  var server = await io.serve(_todoController.handler, _hostname, port);

  print('Serving at http://${server.address.host}:${server.port}');
}


