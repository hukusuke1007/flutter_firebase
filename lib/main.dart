import 'package:flutter/material.dart';
import 'package:flutter_firebase/pages/memo_page.dart';
import 'package:flutter_firebase/model/ballcap/ballcap_app.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  BallcapApp.configure(Firestore.instance.document('version/1'));
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
      home: MemoPage(title: 'Flutter Demo Home Page'),
    );
  }
}