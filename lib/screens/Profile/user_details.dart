import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lms/model/user_model.dart';

class UserDetail extends StatefulWidget {
  final VoidCallback onEditClicked;
  final VoidCallback onSignOutClicked;
  final Function(UserModel) onGettingUserDetails;

  const UserDetail({
    Key? key,
    required this.onEditClicked,
    required this.onSignOutClicked,
    required this.onGettingUserDetails,
  }) : super(key: key);

  @override
  State<UserDetail> createState() => _UserDetailState();
}

class _UserDetailState extends State<UserDetail> {
  UserModel userModel = UserModel();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    User? user = FirebaseAuth.instance.currentUser;
    setState(() {
      _isLoading = true;
    });
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      setState(() {
        userModel = UserModel.fromMap(value.data());
        widget.onGettingUserDetails(userModel);
      });
    });
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final editButton = Material(
      elevation: 5,
      color: Colors.blue.shade800,
      borderRadius: BorderRadius.circular(30),
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          widget.onEditClicked();
        },
        child: const Text(
          "EDIT",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );

    final signOutButton = Material(
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
          widget.onSignOutClicked();
          setState(() {
            _isLoading = true;
          });
        },
        child: const Text(
          "SIGN OUT",
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

    return (_isLoading)
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Column(
            children: [
              headingText("First Name"),
              sizedBoxMargin(5),
              fieldText(userModel.firstName ?? " "),
              sizedBoxMargin(20),
              headingText("Last Name"),
              sizedBoxMargin(5),
              fieldText(userModel.lastName ?? " "),
              sizedBoxMargin(20),
              headingText("Email"),
              sizedBoxMargin(5),
              fieldText(userModel.email ?? " "),
              sizedBoxMargin(30),
              editButton,
              sizedBoxMargin(20),
              signOutButton,
              sizedBoxMargin(40),
            ],
          );
  }
}
