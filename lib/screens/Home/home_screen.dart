import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lms/model/book_model.dart';
import 'package:lms/repository/data_repository.dart';
import 'package:lms/screens/Home/components/book_card.dart';
import 'package:lms/utils/constants.dart';
import 'package:lms/model/user_model.dart';
import 'package:lms/services/authentication_service.dart';
import 'package:provider/src/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = false;

  List<Book> _booksList = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getBooksData();
  }

  @override
  Widget build(BuildContext context) {
    return (_isLoading)
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : SafeArea(
            child: ListView.builder(
            itemCount: _booksList.length,
            itemBuilder: (context, index) {
              return BookCard(_booksList[index]);
            },
          ));
  }

  Future getBooksData() async {
    await FirebaseFirestore.instance
        .collection('books')
        .orderBy('title')
        .get()
        .then((doc) {
      setState(() {
        _booksList = doc.docs.map((e) => Book.fromMap(e.data())).toList();
      });
    });
  }
}
