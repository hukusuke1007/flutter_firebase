import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase/model/storage_file.dart';

class Memo {

  Memo({this.id, this.text, this.image, this.createdAt, this.updateAt});

  static String path = "memo";

  String id;
  String text;
  StorageFile image;
  Timestamp createdAt;
  Timestamp updateAt;

  static Memo from(String id, Map<String, dynamic> map) {
    final item = Memo();

    /// id, text
    item.id = map.containsKey('id') ? map['id'] as String : null;
    item.text = map.containsKey('text') ? map['text'] as String : null;

    /// image
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
    if (text != null) map['text'] = text;
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