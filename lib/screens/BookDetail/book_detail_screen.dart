import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lms/model/book_model.dart';
import 'package:lms/model/reader_model.dart';
import 'package:lms/model/user_model.dart';
import 'package:lms/repository/data_repository.dart';
import 'package:lms/screens/AddBook/add_book_screen.dart';
import 'package:lms/utils/user_preferences.dart';

class BookDetailScreen extends StatefulWidget {
  BookDetailScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  Book book = Book();

  var user = FirebaseAuth.instance.currentUser;
  late UserModel userModel;

  bool _isLoading = false;
  bool _showRequestBtn = false;
  bool _showApproveBtn = false;
  bool _showDeclineBtn = false;
  bool _showCancelRequestBtn = false;
  bool _showDepositeBtn = false;

  void checkButtons() {
    if (isAdmin()) {
      _showApproveBtn = book.requestedBy != null;
      _showDeclineBtn = book.requestedBy != null;
      _showRequestBtn = false;
      _showDepositeBtn = false;
      _showCancelRequestBtn = false;
    } else {
      _showApproveBtn = false;
      _showDeclineBtn = false;
      _showRequestBtn = (book.issuedTo == null && book.requestedBy == null);
      _showDepositeBtn =
          (book.issuedTo != null && book.issuedTo?.uid == user?.uid);
      _showCancelRequestBtn =
          (book.requestedBy != null && book.requestedBy?.uid == user?.uid);
    }
  }

  requestBook() async {
    final requestedBy = Reader(
      name:
          "${UserPreferences.getUserFName()} ${UserPreferences.getUserLName()}",
      uid: UserPreferences.getUserUid(),
    );

    await DataRepository()
        .booksCollection
        .doc(book.uid)
        .update({'requested_by': requestedBy.toMap()});

    checkButtons();
  }

  cancelRequest() async {
    await DataRepository()
        .booksCollection
        .doc(book.uid)
        .update({'requested_by': null});
  }

  approveRequest() async {
    await DataRepository().booksCollection.doc(book.uid).update({
      'issued_to': book.requestedBy?.toMap(),
      'requested_by': null,
    });
  }

  declineRequest() async {
    await DataRepository().booksCollection.doc(book.uid).update({
      'requested_by': null,
    });
  }

  depositeBook() async {
    await DataRepository().booksCollection.doc(book.uid).update({
      'issued_to': null,
    });
  }

  onEditClicked() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddBookScreen(book)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _bookUid = ModalRoute.of(context)!.settings.arguments as String;

    final requestButton = Material(
      elevation: 5,
      color: Colors.blue.shade800,
      borderRadius: BorderRadius.circular(30),
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          requestBook();
        },
        child: const Text(
          "REQUEST BOOK",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );

    final cancelRequestButton = Material(
      elevation: 5,
      color: Colors.redAccent.shade400,
      borderRadius: BorderRadius.circular(30),
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          cancelRequest();
        },
        child: const Text(
          "CANCEL REQUEST",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );

    final depositebutton = Material(
      elevation: 5,
      color: Colors.redAccent,
      borderRadius: BorderRadius.circular(30),
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          depositeBook();
        },
        child: const Text(
          "DEPOSITE",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );

    final approvebutton = Material(
      elevation: 5,
      color: Colors.blue,
      borderRadius: BorderRadius.circular(30),
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          approveRequest();
        },
        child: const Text(
          "APPROVE REQUEST",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );

    final declinebutton = Material(
      elevation: 5,
      color: Colors.redAccent,
      borderRadius: BorderRadius.circular(30),
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          declineRequest();
        },
        child: const Text(
          "DECLINE REQUEST",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );

    headingText(String value) => Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade400,
          ),
          textAlign: TextAlign.start,
        );

    fieldText(String value) => Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade200,
          ),
          textAlign: TextAlign.start,
        );

    Widget sizedBoxMargin(double value) {
      return SizedBox(height: value);
    }

    List<Widget> getBtnList() {
      List<Widget> btnList = [];
      checkButtons();
      if (_showRequestBtn) {
        btnList.add(requestButton);
        btnList.add(sizedBoxMargin(20));
      }
      if (_showCancelRequestBtn) {
        btnList.add(cancelRequestButton);
        btnList.add(sizedBoxMargin(20));
      }
      if (_showDepositeBtn) {
        btnList.add(depositebutton);
        btnList.add(sizedBoxMargin(20));
      }
      if (_showApproveBtn) {
        btnList.add(approvebutton);
        btnList.add(sizedBoxMargin(20));
      }
      if (_showDeclineBtn) {
        btnList.add(declinebutton);
        btnList.add(sizedBoxMargin(20));
      }

      return btnList;
    }

    List<Widget> getBookDetailsList(Book book) {
      List<Widget> list = <Widget>[
        headingText("Title"),
        sizedBoxMargin(10),
        fieldText(book.title ?? " "),
        sizedBoxMargin(20),
        headingText("Auhtors"),
        sizedBoxMargin(10),
        Row(
          children: book.authors!.map((e) {
            return fieldText(e);
          }).toList(),
        ),
        sizedBoxMargin(20),
        headingText("Category"),
        sizedBoxMargin(10),
        fieldText(book.category?.title ?? " "),
        sizedBoxMargin(20),
        headingText("Availability"),
        sizedBoxMargin(10),
        fieldText((book.issuedTo == null) ? "Available" : "Not Available"),
        sizedBoxMargin(20),
        (book.issuedTo != null)
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  headingText("Issued To"),
                  sizedBoxMargin(10),
                  fieldText(book.issuedTo?.name ?? ""),
                  sizedBoxMargin(20),
                ],
              )
            : Container(),
        (book.requestedBy != null)
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  headingText("Requested By"),
                  sizedBoxMargin(10),
                  fieldText(book.requestedBy?.name ?? ""),
                  sizedBoxMargin(20),
                ],
              )
            : Container(),
        sizedBoxMargin(40),
      ];

      list.addAll(getBtnList());

      return list;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Book Details"),
      ),
      floatingActionButton: (isAdmin())
          ? FloatingActionButton.extended(
              onPressed: () {
                onEditClicked();
              },
              label: const Text("Edit"),
              icon: const Icon(Icons.edit),
              backgroundColor: Colors.blue,
            )
          : null,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: StreamBuilder<DocumentSnapshot>(
              stream:
                  DataRepository().booksCollection.doc(_bookUid).snapshots(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasError) {
                  return const Text("Something went wrong");
                }

                if (snapshot.hasData && !snapshot.data!.exists) {
                  return const Text("Book does not exist");
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                var map = snapshot.data!.data() as Map<String, dynamic>;
                book = Book.fromMap(map);

                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: getBookDetailsList(book),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
