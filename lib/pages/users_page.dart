import 'package:flutter/material.dart';
import 'package:flutter_firebase/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase/utils/date_util.dart';
import 'package:flutter_firebase/pages/user_profile_page.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UsersPage extends StatefulWidget {
  UsersPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {

  List<User> _dataSource = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(afterBuild);
  }

  void afterBuild(Duration duration) async {
    await _onLoad();
    await _onListener();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _dataBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: _onAdd,
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _dataBody() {
    return ListView.builder(
      itemCount: _dataSource.length,
      itemBuilder: (context, index) {
        if (_dataSource.isEmpty) {
          return Container();
        }
        final item = _dataSource[index];
        return Dismissible(
          key: Key(item.id),
          onDismissed: (direction) {
            _onRemove(item);
            Scaffold.of(context).showSnackBar(SnackBar(content: Text("${item.id} removed.")));
          },
          background: Container(color: Colors.red),
          child: _buildRow(index, item),
        );
      },
    );
  }
  
  Widget _buildRow(int index, User item) {
    final createdDate = DateUtil.dateToString(item.createdAt.toDate(), 'yyyy.MM.dd HH:mm:ss');
    return GestureDetector(
      onTap: () {
        print(item.id);
        Navigator.push<void>(context, MaterialPageRoute(
            builder: (BuildContext context) => UserProfilePage(item)));
      },
      child: Container(
        alignment: Alignment.center,
        child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 8,
            margin: const EdgeInsets.all(12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(left: 16),
                          child: Text(index.toString(), textAlign: TextAlign.left, style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                          ),),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(right: 16),
                          child: Text(createdDate, textAlign: TextAlign.right, style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                          ),),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 8, bottom: 14),
                  child: Text(item.name, textAlign: TextAlign.right, style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  ),),
                ),
              ],
            )
        ),
      ),
    );
  }

  Future _onAdd() async {
    try {
      final collection = Firestore.instance.collection('version/1/${User.path}');
      final id = collection.document().documentID;
      final date = Timestamp.now();
      final item = User(id: id, name: '$id san', createdAt: date, updateAt: date);
      await collection.document(id).setData(item.toJson(), merge: true);
    } catch (error) {
      throw error;
    }
  }

  Future _onLoad() async {
    try {
      final collection = await Firestore.instance.collection('version/1/${User.path}')
          .orderBy('createdAt', descending: true).getDocuments();
      final result = collection.documents.map((item) => User.from(item.documentID, item.data));
      setState(() {
        _dataSource = result.toList();
      });
    } catch (error) {
      throw error;
    }
  }

  Future _onRemove(User item) async {
    try {
      if (_dataSource.contains(item)) {
        setState(() {
          _dataSource.remove(item);
        });
      }
      final document = Firestore.instance.document('version/1/${User.path}/${item.id}');
      await document.delete();

      /// storage delete
      if (item.image != null) {
        final path = 'version/1/${item.id}/image/${item.image.name}';
        final storageRef = FirebaseStorage.instance.ref().child(path);
        await storageRef.delete();
      }
    } catch (error) {
      throw error;
    }
  }

  Future _onListener() async {
    final collection = Firestore.instance.collection('version/1/${User.path}');
    collection.snapshots().listen((querySnapshot) {
      querySnapshot.documentChanges.forEach((change) {
        final changeItem = User.from(change.document.documentID, change.document.data);
        final isExistItem = _dataSource.where((item) => item.id == changeItem.id).isNotEmpty;
        /// add
        if (change.type == DocumentChangeType.added) {
          if (!isExistItem) {
            setState(() {
              _dataSource.insert(0, changeItem);
            });
          }
        }
        if (isExistItem) {
          /// modified
          if (change.type == DocumentChangeType.modified) {
            setState(() {
              final temp = _dataSource.map((item) => item.id == changeItem.id ? changeItem : item).toList();
              _dataSource.replaceRange(0, _dataSource.length, temp);
            });
          }
          /// removed
          if (change.type == DocumentChangeType.removed) {
            setState(() {
              _dataSource.removeWhere((item) => item.id == changeItem.id);
            });
          }
        }
      });
    });
  }
}
