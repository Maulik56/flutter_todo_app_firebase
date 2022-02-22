import 'package:cloud_firestore/cloud_firestore.dart';

class CreateTodoService {
  static Future<bool> addTodo(String title, String dec) async {
    Map<String, dynamic> todoData = {
      "title": title,
      "description": dec,
      "isCompleted": false,
    };

    CollectionReference todoCollection =
        FirebaseFirestore.instance.collection('Todo');

    try {
      var result = await todoCollection.add(todoData);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
