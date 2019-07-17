import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase/model/storage_file.dart';

class User {

  User({this.id, this.name, this.image, this.createdAt, this.updateAt});

  static String path = "user";

  String id;
  String name;
  StorageFile image;
  Timestamp createdAt;
  Timestamp updateAt;

  static User from(String id, Map<String, dynamic> map) {
    final item = User();

    /// user id, name
    item.id = map.containsKey('id') ? map['id'] as String : null;
    item.name = map.containsKey('name') ? map['name'] as String : null;

    /// user image
    if (map.containsKey('image')) {
      final image = map['image'] as Map<dynamic, dynamic>;
      if (image != null) {
        item.image = StorageFile.from(image);
      }
    }

    /// date
    item.updateAt = map.containsKey('updatedAt') ? map['updatedAt'] as Timestamp : null;
    item.createdAt = map.containsKey('createdAt') ? map['createdAt'] as Timestamp : null;
    return item;
  }

  Map<String, dynamic> toJson() {
    final map = Map<String, dynamic>();
    if (id != null) map['id'] = id;
    if (name != null) map['name'] = name;
    if (image != null) map['image'] = image.toJson();
    if (createdAt != null) map['createdAt'] = createdAt;
    if (updateAt != null) map['updateAt'] = updateAt;
    return map;
  }

  Map<String, dynamic> removeImageToJson() {
    /// internal
    updateAt = Timestamp.now();
    image = null;

    /// toJson
    return <String, dynamic> {
      'updateAt': updateAt,
      'image': FieldValue.delete()
    };
  }

}