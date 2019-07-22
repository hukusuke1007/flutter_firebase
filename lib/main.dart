import 'package:flutter/material.dart';
import 'package:flutter_firebase/pages/memo_list_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future main() async {
  final app = MyApp();
  await app.signIn();
  runApp(app);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Firebase Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MemoListPage(title: 'Flutter Firebase Demo'),
    );
  }

  Future<FirebaseUser> signIn() async {
    final auth = FirebaseAuth.instance;
    FirebaseUser user;
    user = await auth.currentUser();
    if (user == null) {
      user = await auth.signInAnonymously();
      print("Sign in");
    } else {
      print("Already logged in");
    }
    print("User " + user.uid);
    return user;
  }
}

