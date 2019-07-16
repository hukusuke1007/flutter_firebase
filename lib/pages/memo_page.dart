import 'package:flutter/material.dart';
import 'package:flutter_firebase/model/memo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MemoPage extends StatefulWidget {
  MemoPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MemoPageState createState() => _MemoPageState();
}


class _MemoPageState extends State<MemoPage> {
  int _counter = 0;

  TextEditingController _textEditingController = TextEditingController(text: '');

  void _incrementCounter() async {
    /// save
    final memo = Memo();
    print(memo);
    
//    memo.text = 'memomemo';
//    await memo.save();
//
//    /// get
//    final items = await Firestore.instance.collection('test/1/memo').getDocuments();
//    items.documents.forEach((item) async {
//      final memo = await Memo.get(snapshot: item);
//      print('${memo.id} ${memo.createdAt?.toDate()}');
//    });
  }

  void _load() async {
    final id = 'ioqE0ZkyPYChqW3axV97';
    final memo = await Memo.get(id: id);
    print(memo?.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _dataBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.create),
      ),
    );
  }

  Widget _dataBody() {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            child: Text('Memo', textAlign: TextAlign.left,),
          ),
          Container(
            child: TextField(
              controller: _textEditingController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: 'memo',
              ),
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400
              ),
            ),
          )
        ],
      ),
    );
  }
}
