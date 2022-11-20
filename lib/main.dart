import 'package:flutter/material.dart';
import 'package:migraine_app/screens/add.dart';
import 'package:migraine_app/screens/home.dart';

void main() {
  runApp(MaterialApp(
    // home: Home(),
    initialRoute: "/",
    routes: {
      "/" : (context) => Home(),
      "/add" : (context) => AddMigraine(),
    },
  ));
}
