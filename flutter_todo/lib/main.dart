import 'package:flutter/material.dart';
import 'package:flutter_todo/view/lists_overview_page.dart';
import 'package:provider/provider.dart';
import 'package:flutter_todo/storage/todo_storage.dart';
import 'package:flutter_todo/viewmodels/todos_view_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final viewModel = TodosViewModel(TodoStorage());
  await viewModel.load();

  runApp(
    ChangeNotifierProvider(
      create: (_) => viewModel,
      child: const MyApp(),
    ),
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