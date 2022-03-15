import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';

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
  // style for Container
  final _boxStyle = BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          offset: const Offset(1, 1),
          blurRadius: 1,
          spreadRadius: 0.5,
        )
      ]);

  final List<Map<String, String>> _todos = [
    {'todo': 'Do laundry', 'isChecked': 'false'},
    {'todo': 'Call mom', 'isChecked': 'false'},
    {'todo': 'Book tickets', 'isChecked': 'false'},
    {'todo': 'Buy bread', 'isChecked': 'false'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: ListView(
            padding: const EdgeInsets.all(8),
            children: _todos
                .map((item) => Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      decoration: _boxStyle,
                      child: CheckboxListTile(
                          dense: true,
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 4),
                          controlAffinity: ListTileControlAffinity.leading,
                          // make sure item['todo'] is not null by using !
                          title: Text(item['todo']!,
                              style: const TextStyle(fontSize: 16)),
                          value: item['isChecked'] == 'true' ? true : false,
                          onChanged: (bool? val) {
                            setState(() {
                              item['isChecked'] = val.toString();
                            });
                          }),
                    ))
                .toList()));
  }
}
