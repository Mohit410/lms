import 'package:cloud_firestore/cloud_firestore.dart';

class DataRepository {
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  Stream<QuerySnapshot> getStream() {
    return userCollection.snapshots();
  }
}
