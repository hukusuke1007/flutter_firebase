

class StorageFile {

  StorageFile(this.name, this.url, this.mimeType);

  String name;
  String url;
  String mimeType;

  static StorageFile from(Map<dynamic, dynamic> map) {
    return StorageFile(
        map.containsKey('name') ? map['name'] as String : null,
        map.containsKey('url') ? map['url'] as String : null,
        map.containsKey('mimeType') ? map['mimeType'] as String : null
    );
  }

  Map<String, dynamic> toJson() {
    final map = Map<String, dynamic>();
    if (name != null) map['name'] = name;
    if (url != null) map['url'] = url;
    if (mimeType != null) map['mimeType'] = mimeType;
    return map;
  }
}