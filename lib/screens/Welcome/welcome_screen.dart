import 'package:flutter/material.dart';
import 'package:lms/screens/Login/login_page.dart';
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
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const LoginScreen();
                    }));
                  },
                  child: const Text(" LOGIN ")),
              OutlinedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const SignUpScreen();
                    }));
                  },
                  child: const Text("SIGN UP"))
            ]),
      ),
    );
  }
}
