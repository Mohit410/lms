import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lms/main.dart';
import 'package:lms/utils/constants.dart';
import 'package:lms/services/authentication_service.dart';
import 'package:lms/utils/helper.dart';
import 'package:lms/utils/user_preferences.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //form key
  final _formKey = GlobalKey<FormState>();

  //progress bar state
  bool _isLoading = false;

  //editing controller
  final TextEditingController emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //email field
    final emailField = TextFormField(
      autofocus: false,
      keyboardType: TextInputType.emailAddress,
      controller: emailController,
      onSaved: (value) {
        emailController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.mail),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: 'Email',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )),
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
    );

    //password field
    final passwordField = TextFormField(
      autofocus: false,
      obscureText: true,
      controller: passwordController,
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
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.vpn_key),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: 'Password',
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
                          "LOGIN",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                          ),
                        ),
                        sizedBoxMargin(45),
                        emailField,
                        sizedBoxMargin(20),
                        passwordField,
                        sizedBoxMargin(35),
                        customButton(() {
                          logIn(emailController.text, passwordController.text);
                        }, "Login", context, redButtonColor),
                        sizedBoxMargin(15),
                      ],
                    )),
              ),
            )),
          );
  }

  logIn(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      User? user;
      await context
          .read<AuthenticationService>()
          .signIn(
            email: email.trim(),
            password: password.trim(),
          )
          .then((value) async {
        user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          await UserPreferences.saveUserPreferences(user!);
          admin = isAdmin();
          Navigator.pushNamedAndRemoveUntil(
              context, bottomNavPanelRoute, (route) => false);
        }
        showSnackbar(value, context);
      });
      setState(() {
        _isLoading = false;
      });
    }
  }
}
