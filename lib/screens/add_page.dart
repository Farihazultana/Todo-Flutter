import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddTodoPage extends StatefulWidget {
  final Map? editTodo;
  const AddTodoPage({super.key, this.editTodo});

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  TextEditingController titleConroller = TextEditingController();
  TextEditingController descriptionConroller = TextEditingController();

  bool isEdit = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final todo = widget.editTodo;
    if (widget.editTodo != null) {
      isEdit = true;
      final title = todo?['title'];
      final description = todo?['description'];
      titleConroller.text = title;
      descriptionConroller.text = description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Todo' : 'Add Todo'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: titleConroller,
            decoration: const InputDecoration(hintText: 'Title'),
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            controller: descriptionConroller,
            decoration: const InputDecoration(hintText: 'Description'),
            keyboardType: TextInputType.multiline,
            minLines: 5,
            maxLines: 8,
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: isEdit ? updateData : submitData,
              child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(isEdit ? 'Update' : 'Submit')))
        ],
      ),
    );
  }

  Future<void> updateData() async {
    final todo = widget.editTodo;
    if (todo == null) {
      print('You can not call updated without todo data');
      return;
    }
    final id = todo['_id'];
    //Get the data from form
    final title = titleConroller.text;
    final description = descriptionConroller.text;
    final body = {
      "title": title,
      "description": description,
      "is_completed": false
    };

    // submit data to the server
    final url = 'https://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);
    final response = await http.put(uri,
        body: jsonEncode(body), headers: {'Content-Type': 'application/json'});

    // show success or fail mesage based on status
    if (response.statusCode == 200) {
      showSuccessMessage('Updating Successful!');
    } else {
      showErrorMessage('Updating failed!');
    }
    
  }

  Future<void> submitData() async {
    // get the data from Form
    final title = titleConroller.text;
    final description = descriptionConroller.text;
    final body = {
      "title": title,
      "description": description,
      "is_completed": false
    };
    // submit data to the server
    const url = 'https://api.nstack.in/v1/todos';
    final uri = Uri.parse(url);
    final response = await http.post(uri,
        body: jsonEncode(body), headers: {'Content-Type': 'application/json'});

    // show success or fail mesage based on status
    if (response.statusCode == 201) {
      titleConroller.text = '';
      descriptionConroller.text = '';
      showSuccessMessage('Creation Successful!');
    } else {
      showErrorMessage('Creation failed!');
    }
  }

  void showSuccessMessage(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showErrorMessage(String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
