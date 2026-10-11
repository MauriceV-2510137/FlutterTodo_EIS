import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_todo/view/lists_overview_page.dart';
import 'package:flutter_todo/viewmodels/todos_view_model.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => TodosViewModel(),
      child: const MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Todo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      ),
      home: const ListsOverviewPage(),
    );
  }
}