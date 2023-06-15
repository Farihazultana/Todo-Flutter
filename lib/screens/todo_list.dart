import 'package:flutter/material.dart';
import 'package:todo_app/screens/add_page.dart';


class TodoList extends StatefulWidget {
  const TodoList({super.key});

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Todo List'),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: navigateToAddPage,
        label: const Text('Add Todo'),
      ),
    );
  }

  void navigateToAddPage() {
    final route =
        MaterialPageRoute(builder: ((context) => const AddTodoPage()));

    Navigator.push(context, route);
  }
}
