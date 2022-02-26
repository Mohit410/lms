import 'package:cloud_firestore/cloud_firestore.dart';

class DataRepository {
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  final CollectionReference booksCollection =
      FirebaseFirestore.instance.collection('books');

  Stream<QuerySnapshot> getStream() => usersCollection.snapshots();

  Stream<QuerySnapshot> getBooksStream() => booksCollection.snapshots();

  Future<DocumentSnapshot> getDocumentByUid(String uid) =>
      booksCollection.doc(uid).get();
}
