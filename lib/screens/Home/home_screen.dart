import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lms/repository/data_repository.dart';
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

  // @override
  // void initState() {
  //   setState(() {
  //     _isLoading = true;
  //   });
  //   super.initState();
  //   FirebaseFirestore.instance
  //       .collection("users")
  //       .doc(user!.uid)
  //       .get()
  //       .then((value) {
  //     userModel = UserModel.fromMap(value.data());
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return (_isLoading)
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Center(
            child: ElevatedButton(
              onPressed: () => printBooksData(),
              child: const Text("Print data"),
            ),
          );
  }

  void printBooksData() {
    DataRepository().booksCollection.get().then((value) {
      for (var element in value.docs) {
        print("${element.data()}");
      }
    });
  }
}
