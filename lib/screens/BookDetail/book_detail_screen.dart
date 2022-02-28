import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lms/model/book_model.dart';
import 'package:lms/repository/data_repository.dart';
import 'package:lms/utils/user_preferences.dart';

class BookDetailScreen extends StatefulWidget {
  String bookUid;
  BookDetailScreen(
    this.bookUid, {
    Key? key,
  }) : super(key: key);

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  Book book = Book();

  bool _isLoading = false;
  bool _showRequestBtn = false;
  bool _showApproveBtn = false;
  bool _showDeclineBtn = false;
  bool _showCancelRequestBtn = false;
  bool _showDepositeBtn = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var user = FirebaseAuth.instance.currentUser;

    final requestButton = Material(
      elevation: 5,
      color: Colors.blue.shade800,
      borderRadius: BorderRadius.circular(30),
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          //todo
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
      color: Colors.blue.shade800,
      borderRadius: BorderRadius.circular(30),
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          //todo
        },
        child: const Text(
          "REQUEST BOOK",
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
          setState(() {
            _isLoading = false;
          });
          //todo
          setState(() {
            _isLoading = true;
          });
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
      color: Colors.redAccent,
      borderRadius: BorderRadius.circular(30),
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          setState(() {
            _isLoading = false;
          });
          //todo
          setState(() {
            _isLoading = true;
          });
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
          setState(() {
            _isLoading = false;
          });
          //todo
          setState(() {
            _isLoading = true;
          });
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
            fontWeight: FontWeight.w300,
            color: Colors.grey.shade600,
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
      if (_showRequestBtn) {
        btnList.add(requestButton);
        sizedBoxMargin(20);
      }
      if (_showCancelRequestBtn) {
        btnList.add(cancelRequestButton);
        sizedBoxMargin(20);
      }
      if (_showDepositeBtn) {
        btnList.add(declinebutton);
        sizedBoxMargin(20);
      }
      if (_showApproveBtn) {
        btnList.add(approvebutton);
        sizedBoxMargin(20);
      }
      if (_showDeclineBtn) {
        btnList.add(declinebutton);
        sizedBoxMargin(20);
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
        Column(
          children: book.authors!.map((e) {
            return fieldText(e);
          }).toList(),
        ),
        sizedBoxMargin(20),
        headingText("Category"),
        sizedBoxMargin(10),
        fieldText(book.category?.title ?? " "),
        sizedBoxMargin(40),
      ];

      list.addAll(getBtnList());

      return list;
    }

    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: (isAdmin())
          ? FloatingActionButton.extended(
              onPressed: () {},
              label: const Text("Edit"),
              icon: const Icon(Icons.edit),
              backgroundColor: Colors.blue,
            )
          : null,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: FutureBuilder<DocumentSnapshot>(
              future: DataRepository().getBookByUid(widget.bookUid),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasError) {
                  return const Text("Something went wrong");
                }

                if (snapshot.hasData && !snapshot.data!.exists) {
                  return const Text("Book does not exist");
                }

                if (snapshot.connectionState == ConnectionState.done) {
                  var map = snapshot.data!.data() as Map<String, dynamic>;
                  setState(() {
                    book = Book.fromMap(map);
                  });
                  setState(() {
                    if (isAdmin()) {
                      _showApproveBtn = book.requestedBy != null;
                      _showDeclineBtn = book.requestedBy != null;
                      _showRequestBtn = false;
                      _showDepositeBtn = false;
                      _showCancelRequestBtn = false;
                    } else {
                      _showApproveBtn = false;
                      _showDeclineBtn = false;
                      _showRequestBtn =
                          (book.issuedTo == null && book.requestedBy == null);
                      _showDepositeBtn = (book.issuedTo != null &&
                          book.issuedTo?.uid == user?.uid);
                      _showCancelRequestBtn = (book.requestedBy != null &&
                          book.requestedBy?.uid == user?.uid);
                    }
                  });
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: getBookDetailsList(book),
                  );
                }

                return const CircularProgressIndicator();
              },
            ),
          ),
        ),
      ),
    );
  }
}
