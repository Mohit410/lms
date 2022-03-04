import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lms/model/book_model.dart';

class DataRepository {
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  final CollectionReference booksCollection =
      FirebaseFirestore.instance.collection('books');

  final CollectionReference categoriesCollection =
      FirebaseFirestore.instance.collection("categories");

  Stream<QuerySnapshot> getUsersStream() => usersCollection.snapshots();

  Stream<QuerySnapshot> getBooksStreamByCategory(String categoryUid) =>
      booksCollection
          .where(
            'category.uid',
            isEqualTo: categoryUid,
          )
          .snapshots();

  Stream<QuerySnapshot> getBooksStreamByQuery(String query) => booksCollection
      .where(
        'title',
        isGreaterThanOrEqualTo: query,
      )
      .snapshots();

  Stream<QuerySnapshot> getBooksStream() => booksCollection.snapshots();

  Stream<QuerySnapshot> getCategoryStream() => categoriesCollection.snapshots();

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

  Future<void> updateBook(Book book) async {
    return await booksCollection.doc(book.uid).update(book.toMap());
  }

  Future getBooksByQuery(String query) async {
    return await booksCollection
        .where('title', isGreaterThanOrEqualTo: query)
        .get();
  }

  Future<String> getUserOSToken(String uid) async {
    var playerId = "";
    await usersCollection.doc(uid).get().then((value) {
      final map = value.data() as Map<String, dynamic>;
      playerId = map["tokens"];
    });

    return playerId;
  }
}
