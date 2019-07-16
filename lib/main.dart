import 'package:flutter/material.dart';
import 'package:flutter_firebase/pages/users_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Firebase Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: UsersPage(title: 'Flutter Firebase Demo'),
    );
  }
}