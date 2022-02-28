import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:lms/model/book_model.dart';

class DataRepository {
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  final CollectionReference booksCollection =
      FirebaseFirestore.instance.collection('books');

  final CollectionReference categoriesCollection =
      FirebaseFirestore.instance.collection("categories");

  Stream<QuerySnapshot> getStream() => usersCollection.snapshots();

  Stream<QuerySnapshot> getBooksStream() => booksCollection.snapshots();

  Future<DocumentSnapshot> getBookByUid(String uid) =>
      booksCollection.doc(uid).get();

  Future<void> addBook(Book book) async {
    await booksCollection.add(book.toMap()).then(
      (bookRef) async {
        await bookRef.update(
          {"uid": bookRef.id},
        );
      },
    );
  }

  Future getBooksByQuery(String query) async {
    return await booksCollection
        .where('title', isGreaterThanOrEqualTo: query)
        .get();
  }
}
