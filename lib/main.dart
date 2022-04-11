import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as dev;

import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/auth_service.dart';
import 'package:todo_app/firebase_options.dart';
import 'package:todo_app/sign_in_page.dart';

Future<void> main() async {
  // Initialize Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          Provider<AuthService>(
            create: (_) => AuthService(FirebaseAuth.instance),
          ),
          StreamProvider(
            create: (context) => context.read<AuthService>().authStateChanges,
            initialData: null,
          )
        ],
        child: MaterialApp(
          title: 'Todo List',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: const AuthWrapper(),
        ));
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();
    if (firebaseUser != null) {
      return const TodoList(title: 'Todo List');
    } else {
      return SignInPage();
    }
  }
}

class Todo {
  String id;
  String todo;
  bool isChecked;
  // using named parameter & syntactic sugar for constructor
  Todo({required this.id, required this.todo, this.isChecked = false});
}

class TodoList extends StatefulWidget {
  final String title;
  const TodoList({Key? key, required this.title}) : super(key: key);

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  // style for tile container
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

  // reference the document from firestore
  CollectionReference todosCollection =
      FirebaseFirestore.instance.collection('todos');
  // get data stream from firestore
  final Stream<QuerySnapshot> _todosStream =
      FirebaseFirestore.instance.collection('todos').snapshots();

  // update document data to firestore
  Future<void> updateTodo(String id, bool value) {
    return todosCollection
        // get document id
        .doc(id)
        // update document field
        .update({'isChecked': value}).catchError(
            (error) => print('failed to update'));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _todosStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text('Loading..');
          }
          return Scaffold(
            appBar: AppBar(
              title: Text(widget.title),
              actions: [
                // Logout button
                IconButton(
                    tooltip: 'Logout',
                    onPressed: () {
                      context.read<AuthService>().signOut();
                    },
                    icon: const Icon(Icons.logout)),
              ],
            ),
            body: ListView(
                // get list of DocumentSnapshot
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
              // convert document fields to Todo object
              Todo todoItem = Todo(
                  id: document.id,
                  todo: document.get('todo'),
                  isChecked: document.get('isChecked'));
              // return the todo item
              return CheckboxListTile(
                  dense: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                  controlAffinity: ListTileControlAffinity.leading,
                  title: Text(
                    todoItem.todo,
                    style: const TextStyle(fontSize: 16),
                  ),
                  value: todoItem.isChecked,
                  onChanged: (bool? val) {
                    setState(() {
                      // update database
                      updateTodo(todoItem.id, val!);
                      // update widget value
                      todoItem.isChecked = val;
                    });
                  });
              // convert iterable type from map() to list
            }).toList()),
          );
        });

    // return Scaffold(
    //     appBar: AppBar(
    //       title: Text(widget.title),
    //     ),
    //     body: ListView(
    //         padding: const EdgeInsets.all(8),
    //         children: _todos
    //             .map((item) => Container(
    //                   margin: const EdgeInsets.symmetric(vertical: 4),
    //                   decoration: _boxStyle,
    //                   child: CheckboxListTile(
    //                       dense: true,
    //                       contentPadding:
    //                           const EdgeInsets.symmetric(horizontal: 4),
    //                       controlAffinity: ListTileControlAffinity.leading,
    //                       // make sure item['todo'] is not null by using !
    //                       title: Text(item['todo']!,
    //                           style: const TextStyle(fontSize: 16)),
    //                       value: item['isChecked'] == 'true' ? true : false,
    //                       onChanged: (bool? val) {
    //                         setState(() {
    //                           item['isChecked'] = val.toString();
    //                         });
    //                       }),
    //                 ))
    //             .toList()));
  }
}
