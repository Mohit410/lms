import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lms/main.dart';
import 'package:lms/model/book_model.dart';
import 'package:lms/model/reader_model.dart';
import 'package:lms/model/user_model.dart';
import 'package:lms/repository/data_repository.dart';
import 'package:lms/services/notification_services.dart';
import 'package:lms/utils/constants.dart';
import 'package:lms/utils/helper.dart';
import 'package:lms/utils/user_preferences.dart';

class BookDetailScreen extends StatefulWidget {
  const BookDetailScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  Book book = Book();

  var user = FirebaseAuth.instance.currentUser;
  late UserModel userModel;

  bool _showRequestBtn = false;
  bool _showApproveBtn = false;
  bool _showDeclineBtn = false;
  bool _showCancelRequestBtn = false;
  bool _showDepositeBtn = false;

  void checkButtons() {
    if (admin) {
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
        .update({'requested_by': requestedBy.toMap()}).then((_) async {
      List<String> adminsTokenList = [];
      await DataRepository()
          .usersCollection
          .where(
            'role',
            isEqualTo: adminR,
          )
          .get()
          .then(
        (qShot) {
          final list = qShot.docs;
          for (var e in list) {
            final data = e.data() as Map<String, dynamic>;
            if (data["tokens"] != null) {
              adminsTokenList.add(data["tokens"]);
            }
          }
        },
      );
      await NotificationServices.sendNotification(
        "You have a new book request",
        "${requestedBy.name} has requested for ${book.title}",
        adminsTokenList,
      );
    });

    checkButtons();
  }

  cancelRequest() async {
    await DataRepository()
        .booksCollection
        .doc(book.uid)
        .update({'requested_by': null});
  }

  approveRequest() async {
    var reqBy = Reader(uid: book.requestedBy!.uid, name: book.requestedBy!.uid);
    await DataRepository().booksCollection.doc(book.uid).update({
      'issued_to': book.requestedBy?.toMap(),
      'requested_by': null,
    }).then((_) async {
      String userToken = await DataRepository().getUserOSToken(reqBy.uid!);

      await NotificationServices.sendNotification(
        "Your book request got approved",
        "You have now ${book.title}",
        [userToken],
      );
    });
  }

  declineRequest() async {
    var uid = book.requestedBy!.uid;
    await DataRepository().booksCollection.doc(book.uid).update({
      'requested_by': null,
    }).then((_) async {
      final userToken = await DataRepository().getUserOSToken(uid!);

      await NotificationServices.sendNotification(
        "Your book request got declined by ${UserPreferences.getUserFName()}",
        "You can request again for ${book.title}",
        [userToken],
      );
    });
  }

  depositeBook() async {
    await DataRepository().booksCollection.doc(book.uid).update({
      'issued_to': null,
    });
  }

  onEditClicked() {
    Navigator.pushNamed(context, addBookRoute, arguments: book);
  }

  @override
  Widget build(BuildContext context) {
    final _bookUid = ModalRoute.of(context)!.settings.arguments as String;

    Widget sizedBoxMargin10() {
      return const SizedBox(height: 10);
    }

    Widget sizedBoxMargin20() {
      return const SizedBox(height: 20);
    }

    List<Widget> getBtnList() {
      List<Widget> btnList = [];
      checkButtons();
      if (_showRequestBtn) {
        btnList.add(customButton(
            requestBook, "REQUEST BOOK", context, blueButtonColor));
        btnList.add(sizedBoxMargin20());
      }
      if (_showCancelRequestBtn) {
        btnList.add(customButton(
            cancelRequest, "CANCEL REQUEST", context, redButtonColor));
        btnList.add(sizedBoxMargin20());
      }
      if (_showDepositeBtn) {
        btnList.add(
            customButton(depositeBook, "DEPOSITE", context, redButtonColor));
        btnList.add(sizedBoxMargin20());
      }
      if (_showApproveBtn) {
        btnList.add(customButton(
            approveRequest, "APPROVE REQUEST", context, blueButtonColor));
        btnList.add(sizedBoxMargin20());
      }
      if (_showDeclineBtn) {
        btnList.add(customButton(
            declineRequest, "DECLINE REQUEST", context, redButtonColor));
        btnList.add(sizedBoxMargin20());
      }

      return btnList;
    }

    List<Widget> getBookDetailsList(Book book) {
      String authors = "";
      for (var author in book.authors!) {
        authors += author + ", ";
      }
      authors = authors.endsWith(", ")
          ? authors.substring(0, authors.length - 2)
          : " ";
      List<Widget> list = <Widget>[
        headingText("Title"),
        sizedBoxMargin10(),
        fieldText(book.title ?? " "),
        sizedBoxMargin20(),
        headingText("Auhtors"),
        sizedBoxMargin10(),
        fieldText(authors),
        sizedBoxMargin20(),
        headingText("Category"),
        sizedBoxMargin10(),
        fieldText(book.category?.title ?? " "),
        sizedBoxMargin20(),
        headingText("Availability"),
        sizedBoxMargin10(),
        fieldText((book.issuedTo == null) ? "Available" : "Not Available"),
        sizedBoxMargin20(),
        headingText("Location"),
        sizedBoxMargin10(),
        fieldText(
            "Rack - ${book.bookLocation!.rackNo}, Row - ${book.bookLocation!.rowNo}, Position - ${book.bookLocation!.position}, Dir - ${book.bookLocation!.direction}"),
        sizedBoxMargin20(),
        (book.issuedTo != null)
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  headingText("Issued To"),
                  sizedBoxMargin10(),
                  fieldText(book.issuedTo?.name ?? ""),
                  sizedBoxMargin20(),
                  headingText("Will be returned on: "),
                  sizedBoxMargin10(),
                  fieldText(book.issuedTo?.returnDate ?? ""),
                  sizedBoxMargin20(),
                ],
              )
            : Container(),
        (book.requestedBy != null)
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  headingText("Requested By"),
                  sizedBoxMargin10(),
                  fieldText(book.requestedBy?.name ?? ""),
                  sizedBoxMargin20(),
                ],
              )
            : Container(),
        const SizedBox(height: 40),
      ];

      list.addAll(getBtnList());

      return list;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Book Details"),
        backgroundColor: Colors.blue,
      ),
      floatingActionButton: (admin)
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
