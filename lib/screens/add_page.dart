import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddTodoPage extends StatefulWidget {
  AddTodoPage({Key? key}) : super(key: key);

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Todo'),
      ),
      body: ListView(
        children: [
          TextField(
            controller: titleController,
            decoration: InputDecoration(hintText: 'Title'),
          ),
          TextField(
            controller: descriptionController,
            decoration: InputDecoration(hintText: 'Description'),
            keyboardType: TextInputType.multiline,
            minLines: 5,
            maxLines: 8,
          ),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(onPressed: submitData, child: Text('Submit'))
        ],
      ),
    );
  }

  Future<void> submitData() async {
    // Get the data from the form
    final title = titleController.text;
    final descripton = descriptionController.text;
    final body = {
      "title": title,
      "description": descripton,
      "is_completed": false
    };
    // Submit data to the server
    final url = 'https://api.nstack.in/v1/todos';
    final uri = Uri.parse(url);
    final response = await http.post(uri,
        body: jsonEncode(body), headers: {'Content-Type': 'application/json'});
    // show success or fail message based on status
    if (response.statusCode == 201) {
      showSuccessMesage('Created Success');
      titleController.text = '';
      descriptionController.text = '';
    } else {
      showErrorMesage('Create fail');
      print(response.body);
    }
  }

  void showSuccessMesage(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showErrorMesage(String message) {
    final snackBar = SnackBar(
        content: Text(
          message,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
