import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_firebase/model/memo.dart';
import 'package:flutter_firebase/model/storage_file.dart';

class MemoEditPage extends StatefulWidget {

  MemoEditPage(this.memo);

  final Memo memo;

  @override
  _MemoEditPageState createState() => _MemoEditPageState();
}

class _MemoEditPageState extends State<MemoEditPage> {

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.memo.text),
      ),
      body: _dataBody(),
    );
  }

  Widget _dataBody() {
    return Container(
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            transform: Matrix4.translationValues(0, -20, 0),
            child: (widget.memo.image == null && _isLoading == false)
              ? Text("no image") : _isLoading == true
              ? CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.lightBlue),)
                : CircleAvatar(
                    radius: 100,
                    backgroundColor: Colors.transparent,
                    child: ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: widget.memo.image.url,
                        height: 200,
                        width: 200,
                        fit: BoxFit.fill,
                      ),
                    ),
                ),
          ),
          Container(
            padding: EdgeInsets.all(8),
            child: RaisedButton(
                child: Text('Choose gallery.', style: TextStyle(
                  color: Colors.white,
                ),),
                color: _isLoading != true ? Colors.pinkAccent : Colors.white70,
                onPressed: () => _isLoading != true ? _loadImage() : null
            ),
          ),
          Container(
            padding: EdgeInsets.all(8),
            child: RaisedButton(
                child: Text('Remove gallery.', style: TextStyle(
                  color: Colors.white,
                ),),
                color: _isLoading != true ? Colors.blueGrey : Colors.white70,
                onPressed: () => _isLoading != true ? _onRemoveImage(widget.memo) : null
            ),
          )
        ],
      ),
    );
  }
  
  Future _loadImage() async {
    /// load image
    final image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image == null) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    /// upload storage
    final filename = 'filename';
    final mimeType = 'image/png';
    final path = 'version/1/${Memo.path}/${widget.memo.id}/image/$filename';
    final storageRef = FirebaseStorage.instance.ref().child(path);
    final uploadTask = storageRef.putFile(image, StorageMetadata(contentType: mimeType));
    uploadTask.events.listen((event) {
      /// upload progress
      print('now...${event.snapshot.bytesTransferred}');
    });

    /// update firestore
    final downloadUrl = await uploadTask.onComplete;
    final imageUrl = await downloadUrl.ref.getDownloadURL();
    print('imageUrl $imageUrl');
    widget.memo.image = StorageFile(filename, imageUrl, mimeType);
    await _onUpdate(widget.memo);

    setState(() {
      _isLoading = false;
    });
  }

  Future _onUpdate(Memo item) async {
    try {
      final id = item.id;
      final document = Firestore.instance.document('version/1/${Memo.path}/$id');
      final date = Timestamp.now();
      item.updateAt = date;
      await document.updateData(item.toJson());
    } catch (error) {
      throw error;
    }
  }

  Future _onRemoveImage(Memo item) async {
    try {
      if (item.image == null) return;

      setState(() {
        _isLoading = true;
      });

      final imageName = item.image.name;

      final id = item.id;
      final document = Firestore.instance.document('version/1/${Memo.path}/$id');
      await document.updateData(item.removeImageToJson());

      /// storage delete
      final path = 'version/1/${item.id}/image/$imageName';
      final storageRef = FirebaseStorage.instance.ref().child(path);
      await storageRef.delete();
      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      throw error;
    }

  }
}