import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_todo/models/todo_list.dart';

class TodoStorage {
  static const _key = 'todo_lists';

  Future<List<TodoList>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final text = prefs.getString(_key);
    if (text == null) return []; // first start: nothing saved yet

    final data = jsonDecode(text) as List;
    return data.map((list) => TodoList.fromJson(list)).toList();
  }

  Future<void> save(List<TodoList> lists) async {
    final prefs = await SharedPreferences.getInstance();
    final text = jsonEncode(lists.map((list) => list.toJson()).toList());
    await prefs.setString(_key, text);
  }
}