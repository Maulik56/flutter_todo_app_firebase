import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_firerbase/services/create_todo_service.dart';

import '../services/view_todo.dart';

class CreateTodo extends StatefulWidget {
  CreateTodo({Key? key}) : super(key: key);

  @override
  _CreateTodoState createState() => _CreateTodoState();
}

class _CreateTodoState extends State<CreateTodo> {
  TextEditingController _textEditingControllerTitle = TextEditingController();

  TextEditingController _textEditingControllerDec = TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("New Todo"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ViewTodo()));
              },
              icon: Icon(Icons.list)),
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "New Todo",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 20,
                ),
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
                SizedBox(
                  height: 20,
                ),
                // Switch(value: false, onChanged: (v) {}),
                // SizedBox(
                //   height: 20,
                // ),
                MaterialButton(
                  onPressed: () async {
                    if (_textEditingControllerDec.text != "" &&
                        _textEditingControllerTitle.text != "") {
                      setState(() {
                        isLoading = true;
                      });

                      bool result = await CreateTodoService.addTodo(
                          _textEditingControllerTitle.text,
                          _textEditingControllerDec.text);

                      setState(() {
                        isLoading = false;
                      });

                      print("__________${result}");

                      if (result) {
                        _textEditingControllerTitle.clear();
                        _textEditingControllerDec.clear();
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Todo Created....!")));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content:
                                Text("Todo not Create please try again!")));
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("please enter valid info")));
                    }
                  },
                  color: Colors.blue,
                  textColor: Colors.white,
                  child: Text("Create"),
                )
              ],
            ),
          ),
          isLoading
              ? Container(
                  height: _size.height,
                  width: _size.width,
                  color: Colors.blue.withOpacity(0.5),
                  child: Center(
                    child: CupertinoActivityIndicator(
                      radius: 20,
                    ),
                  ),
                )
              : SizedBox(),
        ],
      ),
    );
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
