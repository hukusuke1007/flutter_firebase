import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase/model/ballcap/ballcap_app.dart';

class Memo {
  Memo({this.id}) {
    print(BallcapApp.instance.rootReference.path);
  }

  String id;
  String uid;
  String text;
  Timestamp updateAt;
  Timestamp createdAt;

  Map<String, dynamic> data;


  static Memo from(String id, Map<String, dynamic> map) {
    final item = Memo();
    item.id = id;
    item.uid = map.containsKey('uid') ? map['uid'] as String : null;
    item.text = map.containsKey('text') ? map['text'] as String : null;
    item.updateAt = map.containsKey('updatedAt') ? map['updatedAt'] as Timestamp : null;
    item.createdAt = map.containsKey('createdAt') ? map['createdAt'] as Timestamp : null;
    item.data = map;
    return item;
  }

  static Memo fromSnapshot(DocumentSnapshot snapshot) {
    return Memo.from(snapshot.documentID, snapshot.data);
  }

  static Future<Memo> get({String id, DocumentSnapshot snapshot}) async {
    try {
      DocumentSnapshot ref;
      if (snapshot == null) {
        ref = await Firestore.instance.document('test/1/memo/$id').get();
      } else {
        ref = snapshot;
      }
      if (ref.exists) {
        return Memo.fromSnapshot(snapshot);
      }
    } catch (error) {
      throw error;
    }
    return null;
  }

  Future<void> save() async {
    try {
      final collection = Firestore.instance.collection('test/1/memo');
      if (id == null) {
        id = collection.document().documentID;
      }
      uid = id;
      final date = Timestamp.now();
      data = {
        'uid': uid,
        'text': text,
        'createdAt': date,
        'updatedAt': date,
      };
      await collection.document(id).setData(data, merge: true);
    } catch (error) {
      throw error;
    }
  }

}