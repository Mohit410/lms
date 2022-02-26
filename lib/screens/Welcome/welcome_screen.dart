import 'package:flutter/material.dart';
import 'package:lms/utils/constants.dart';
import 'package:lms/screens/Login/login_screen.dart';
import 'package:lms/screens/SignUp/signup_page.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: size.height * 0.05),
              Image.asset('assets/images/books_image.png'),
              SizedBox(height: size.height * 0.05),
              const Text(
                "Welcome To Library Management",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: size.height * 0.05),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, loginRoute);
                  },
                  child: const Text(" LOGIN ")),
              OutlinedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, signUpRoute);
                  },
                  child: const Text("SIGN UP"))
            ]),
      ),
    );
  }
}
