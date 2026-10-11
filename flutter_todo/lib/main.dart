import 'package:flutter/material.dart';
import 'package:flutter_todo/view/todo_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Todo',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.black),
      ),
      home: const TodoPage(),
    );
  }
}