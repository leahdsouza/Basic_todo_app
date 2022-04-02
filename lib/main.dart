import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/model/todo.dart';
import 'package:todo_app/todo_list.dart';
import 'package:todo_app/loading.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if(snapshot.hasError){
          return Scaffold(
            body: Center(
              child: Text(snapshot.error.toString()),
            ),
          );
        }
        if(snapshot.connectionState == ConnectionState.waiting){
          return Loading();
        }
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: TodoList(),
          theme: ThemeData(
            scaffoldBackgroundColor: Colors.grey[900],
            primarySwatch: Colors.pink,
          ),
        );
      }
    );
  }
}
