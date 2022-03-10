import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lms/model/user_model.dart';
import 'package:lms/utils/constants.dart';
import 'package:lms/utils/helper.dart';

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
              customButton(
                  widget.onEditClicked, "EDIT", context, blueButtonColor,
                  icon: const Icon(
                    Icons.edit_rounded,
                  )),
              sizedBoxMargin(20),
              customButton(
                widget.onSignOutClicked,
                "SIGN OUT",
                context,
                redButtonColor,
                icon: const Icon(Icons.logout_rounded),
              ),
              sizedBoxMargin(40),
            ],
          );
  }
}
