// To parse this JSON data, do
//
//     final todo = todoFromMap(jsonString);

import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';

List<Datum> todoFromMap(List<Map<String,dynamic>> str) {
  return List<Datum>.from(str.map((x) => Datum.fromMap(x)));
}

String todoToMap(List<Datum> data) => json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class Todo {
  Todo({
    required this.status,
    required this.message,
    required this.data,
  });

  bool status;
  String message;
  List<Datum> data;

  factory Todo.fromMap(Map<String, dynamic> json) => Todo(
    status: json['status'],
    message: json['message'],
    data: List<Datum>.from(json['data'].map((x) => Datum.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    'status': status,
    'message': message,
    'data': List<dynamic>.from(data.map((x) => x.toMap())),
  };
}

class Datum {
  Datum({
    required this.task,
    required this.id,
    required this.completed,
    required this.createdAt,
  });

  String task;
  ObjectId id;
  bool completed;
  DateTime createdAt;

  factory Datum.fromMap(Map<String, dynamic> json) => Datum(
    task: json['task'],
    id: json['_id'],
    completed: json['completed'],
    createdAt: DateTime.parse(json['created_at']),
  );

  Map<String, dynamic> toMap() => {
    'task': task,
    '_id': id.$oid,
    'completed': completed,
    'created_at': createdAt.toIso8601String(),
  };
}
