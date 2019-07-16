import 'package:flutter/material.dart';
import 'package:flutter_firebase/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase/utils/date_util.dart';

class UsersPage extends StatefulWidget {
  UsersPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _UsersPageState createState() => _UsersPageState();
}


class _UsersPageState extends State<UsersPage> {


  @override
  void initState() {
    super.initState();
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
    return FutureBuilder<List<User>>(
      future: _onLoad(),
      builder: (context, snapshot) {
        print('project_users ${snapshot.hasData} ${snapshot.data}');
        if (snapshot.hasData == false) {
          print('project_snapshot data is: ${snapshot.data}');
          return Container();
        }
        return ListView.builder(
          itemCount: snapshot.data.length,
          itemBuilder: (context, index) {
            final item = snapshot.data[index];
            return Dismissible(
              key: Key(item.id),
              onDismissed: (direction) {
                _onRemove(item.id);
                Scaffold.of(context).showSnackBar(SnackBar(content: Text("${item.id} removed.")));
              },
              background: Container(color: Colors.red),
              child: _buildRow(index, item),
            );
          },
        );
      },
    );
  }
  
  Widget _buildRow(int index, User item) {
    final createdDate = DateUtil.dateToString(item.createdAt.toDate(), 'yyyy.MM.dd HH:mm:ss');
    return GestureDetector(
      onTap: () {
        print(item.id);
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

  Future<List<User>> _onLoad() async {
    try {
      final collection = await Firestore.instance.collection('version/1/${User.path}').orderBy('createdAt', descending: true).getDocuments();
      final result = collection.documents.map((item) => User.from(item.documentID, item.data));
      return result.toList();
    } catch (error) {
      throw error;
    }
  }

  Future _onRemove(String id) async {
    try {
      final document = Firestore.instance.document('version/1/${User.path}/$id');
      await document.delete();
    } catch (error) {
      throw error;
    }
  }

  Future<List<User>> _onListener() async {
    final collection = Firestore.instance.collection('version/1/${User.path}');
    collection.snapshots().listen((querySnapshot) {
      querySnapshot.documentChanges.forEach((change) {
        print("change ${change.type} ${change.document.data}");
      });
    });

  }

}
