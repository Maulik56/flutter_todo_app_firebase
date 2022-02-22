import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ViewTodo extends StatelessWidget {
  ViewTodo({Key? key}) : super(key: key);

  TextEditingController _textEditingControllerTitle = TextEditingController();
  TextEditingController _textEditingControllerDec = TextEditingController();

  CollectionReference todoCollection =
      FirebaseFirestore.instance.collection('Todos');
  final Stream<QuerySnapshot> _todoStream =
      FirebaseFirestore.instance.collection('Todos').snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My All Todo"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Something went wrong'));
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: Text("Loading"));
          } else {
            return ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text("${snapshot.data!.docs[index]['title']}"),
                  subtitle: Text(
                      "${snapshot.data!.docs[index]['description']}"), //isCompleted
                  trailing: SizedBox(
                    width: 60 + 57 + 38,
                    child: Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              _displayTextInputDialog(
                                  id: "${snapshot.data!.docs[index].id}",
                                  context: context,
                                  title:
                                      "${snapshot.data!.docs[index]['title']}",
                                  dec:
                                      "${snapshot.data!.docs[index]['description']}");
                            },
                            icon: Icon(Icons.edit)),
                        IconButton(
                            onPressed: () async {
                              todoCollection
                                  .doc("${snapshot.data!.docs[index].id}")
                                  .delete();
                            },
                            icon: Icon(Icons.delete)),
                        Switch(
                          value: snapshot.data!.docs[index]['isCompleted'],
                          onChanged: (v) {
                            print("id ${snapshot.data!.docs[index].id}");
                            todoCollection
                                .doc(snapshot.data!.docs[index].id)
                                .update({'isCompleted': v})
                                .then(
                                  (value) => print("User Updated"),
                                )
                                .catchError(
                                  (error) =>
                                      print("Failed to update user: $error"),
                                );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
              itemCount: snapshot.data!.docs.length,
            );
          }
        },
        stream: _todoStream,
      ),
    );
  }

  Future<void> _displayTextInputDialog(
      {required BuildContext context,
      required String title,
      required String dec,
      required String id}) async {
    _textEditingControllerTitle.text = title;
    _textEditingControllerDec.text = dec;

    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('TextField in Dialog'),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextBox(
                  hint: "Enter the title",
                  textEditingController: _textEditingControllerTitle,
                ),
                SizedBox(
                  height: 20,
                ),
                TextBox(
                  textEditingController: _textEditingControllerDec,
                  hint: "Enter the description",
                ),
              ],
            ),
            actions: <Widget>[
              FlatButton(
                color: Colors.red,
                textColor: Colors.white,
                child: Text('CANCEL'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                color: Colors.green,
                textColor: Colors.white,
                child: Text('OK'),
                onPressed: () {
                  todoCollection.doc(id).update({
                    "title": _textEditingControllerTitle.text,
                    "description": _textEditingControllerDec.text,
                  }).then((value) {
                    Navigator.pop(context);
                  }).catchError(
                      (error) => print("Failed to update user: $error"));
                },
              ),
            ],
          );
        });
  }
}

class TextBox extends StatelessWidget {
  const TextBox(
      {Key? key, required this.hint, required this.textEditingController})
      : super(key: key);

  final String hint;
  final TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textEditingController,
      decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          filled: true,
          hintStyle: TextStyle(color: Colors.grey[800]),
          hintText: hint,
          fillColor: Colors.white70),
    );
  }
}
