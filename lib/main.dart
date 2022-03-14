import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:todo_app/firebase_options.dart';

// Future<void> main() async {
//   // Initialize Firebase
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   runApp(const MyApp());
// }

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Todo List',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const TodoList(
          title: "Todo List",
        ));
  }
}

class TodoList extends StatefulWidget {
  final String title;
  const TodoList({Key? key, required this.title}) : super(key: key);

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  // style for CheckboxListTile Container
  final _boxStyle = BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          offset: const Offset(1, 1),
          blurRadius: 1,
          spreadRadius: 1,
        )
      ]);

  bool? _isChecked1 = false;
  bool? _isChecked2 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.symmetric(vertical: 4),
                decoration: _boxStyle,
                child: CheckboxListTile(
                    dense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                    title: const Text('Do laundry',
                        style: TextStyle(fontSize: 16)),
                    controlAffinity: ListTileControlAffinity.leading,
                    value: _isChecked1,
                    onChanged: (bool? newValue) {
                      setState(() {
                        _isChecked1 = newValue;
                      });
                    }),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 4),
                decoration: _boxStyle,
                child: CheckboxListTile(
                    dense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                    title: const Text('Buy spinach',
                        style: TextStyle(fontSize: 16)),
                    controlAffinity: ListTileControlAffinity.leading,
                    value: _isChecked2,
                    onChanged: (bool? newValue) {
                      setState(() {
                        _isChecked2 = newValue;
                      });
                    }),
              ),
            ],
          ),
        ));
  }
}
