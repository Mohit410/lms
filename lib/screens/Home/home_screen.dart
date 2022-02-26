import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lms/constants.dart';
import 'package:lms/model/user_model.dart';
import 'package:lms/services/authentication_service.dart';
import 'package:provider/src/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel userModel = UserModel();

  saveUserDetails() async {}

  var _isLoading = false;

  void navigateTo(String route) {
    Navigator.pushNamed(context, route);
  }

  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      userModel = UserModel.fromMap(value.data());
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return (_isLoading)
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'Welcome Back',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Text(
                    "${userModel.firstName} ${userModel.lastName}",
                    style: const TextStyle(
                        fontSize: 10, fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    "${userModel.email}",
                    style: const TextStyle(
                        fontSize: 10, fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      logout(context);
                    },
                    child: const Text("Log out"),
                  )
                ],
              ),
            ),
          );
  }

  void logout(BuildContext context) {
    setState(() {
      _isLoading = true;
    });
    context.read<AuthenticationService>().signOut();
    setState(() {
      _isLoading = false;
    });
    Navigator.pushReplacementNamed(context, welcomeRoute);
  }
}
