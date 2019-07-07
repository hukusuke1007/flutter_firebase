import 'package:cloud_firestore/cloud_firestore.dart';

class BallcapApp {
  static final instance = BallcapApp();
  static configure(DocumentReference reference) {
    instance.rootReference = reference;
  }

  DocumentReference rootReference;
}