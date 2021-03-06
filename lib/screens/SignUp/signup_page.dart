import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lms/utils/constants.dart';
import 'package:lms/model/user_model.dart';
import 'package:lms/services/authentication_service.dart';
import 'package:lms/utils/helper.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';

import '../../main.dart';
import '../../utils/user_preferences.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  var _isLoading = false;
  final _auth = FirebaseAuth.instance;

  final _formKey = GlobalKey<FormState>();

  final firstNameController = TextEditingController();

  final lastNameController = TextEditingController();

  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  final confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //first name field
    final firstNameField = TextFormField(
      autofocus: false,
      controller: firstNameController,
      keyboardType: TextInputType.name,
      onSaved: (value) {
        firstNameController.text = value!;
      },
      validator: (value) {
        RegExp regex = RegExp(r"^.{3,}$");
        if (value!.isEmpty) {
          return "First name cannot be empty";
        }

        if (!regex.hasMatch(value)) {
          return "Enter valid name(Min. 3 characters)";
        }
        return null;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.account_circle),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: 'First Name',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )),
    );

//last name field
    final lastNameField = TextFormField(
      autofocus: false,
      controller: lastNameController,
      keyboardType: TextInputType.name,
      onSaved: (value) {
        lastNameController.text = value!;
      },
      validator: (value) {
        if (value!.isEmpty) {
          return "Last name cannot be empty";
        }
        return null;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.account_circle),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: 'Last Name',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )),
    );

//email field
    final emailField = TextFormField(
      autofocus: false,
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      onSaved: (value) {
        emailController.text = value!;
      },
      validator: (value) {
        if (value!.isEmpty) {
          return "Please enter your email";
        }
        if (!RegExp("^[a-zA-Z0-9.!#%&'*+/=?^_`{|}~-]+@lms.in")
            .hasMatch(value)) {
          return "Please enter a valid email";
        }
        return null;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.mail),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: 'Email',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )),
    );

    //password field
    final passwordField = TextFormField(
      controller: passwordController,
      autofocus: false,
      keyboardType: TextInputType.visiblePassword,
      obscureText: true,
      onSaved: (value) {
        passwordController.text = value!;
      },
      validator: (value) {
        if (value!.isEmpty) {
          return "Password required";
        }
        RegExp regex = RegExp(r"^.{6,}$");
        if (!regex.hasMatch(value)) {
          return "Enter valid password(Min. 6 characters)";
        }
        return null;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.vpn_key),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: 'Password',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )),
    );

    //confirm password field
    final confirmPasswordField = TextFormField(
      controller: confirmPasswordController,
      autofocus: false,
      obscureText: true,
      validator: (value) {
        if (value!.length < 6 && passwordController.text != value) {
          return "Password don't match";
        }
        return null;
      },
      onSaved: (value) {
        confirmPasswordController.text = value!;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.vpn_key),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: 'Confirm Password',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )),
    );

    return (_isLoading)
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.arrow_back)),
            ),
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(36.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        sizedBoxMargin(10),
                        const Text(
                          "SIGN UP",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                          ),
                        ),
                        sizedBoxMargin(45),
                        firstNameField,
                        sizedBoxMargin(20),
                        lastNameField,
                        sizedBoxMargin(20),
                        emailField,
                        sizedBoxMargin(20),
                        passwordField,
                        sizedBoxMargin(20),
                        confirmPasswordField,
                        sizedBoxMargin(35),
                        customButton(() {
                          signUp(emailController.text, passwordController.text);
                        }, "SIGN UP", context, redButtonColor),
                        sizedBoxMargin(15),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }

  signUp(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      User? user;
      await context
          .read<AuthenticationService>()
          .signUp(
            email: email,
            password: password,
          )
          .then((value) async {
        await postUserDetailsToFirestore(context);
        user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          await UserPreferences.saveUserPreferences(user!);
          admin = isAdmin();
          Navigator.pushNamedAndRemoveUntil(
              context, homeRoute, (route) => false);
        }
        showSnackbar(value, context);
      });
      setState(() {
        _isLoading = false;
      });
    }
  }

  postUserDetailsToFirestore(BuildContext context) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    UserModel userModel = UserModel(
        email: user!.email,
        uid: user.uid,
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        userRole: "user");

    await firebaseFirestore
        .collection("users")
        .doc(user.uid)
        .set(userModel.toMap());

    Navigator.pushNamedAndRemoveUntil(
        context, bottomNavPanelRoute, (route) => false);
  }
}
