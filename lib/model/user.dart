import 'package:cloud_firestore/cloud_firestore.dart';

class User {

  User({this.id, this.name, this.createdAt, this.updateAt});

  static String path = "user";

  String id;
  String name;
  Timestamp createdAt;
  Timestamp updateAt;

  static User from(String id, Map<String, dynamic> map) {
    final item = User();
    item.id = map.containsKey('id') ? map['id'] as String : null;
    item.name = map.containsKey('name') ? map['name'] as String : null;
    item.updateAt = map.containsKey('updatedAt') ? map['updatedAt'] as Timestamp : null;
    item.createdAt = map.containsKey('createdAt') ? map['createdAt'] as Timestamp : null;
    return item;
  }

  Map<String, dynamic> toJson() => <String, dynamic> {
    'id': this.id,
    'name': this.name,
    'createdAt': this.createdAt,
    'updateAt': this.updateAt,
  };

}