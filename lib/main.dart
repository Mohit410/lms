import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lms/screens/Home/books_search_screen.dart';
import 'package:lms/screens/Navigation/bottom_nav_bar.dart';
import 'package:lms/utils/constants.dart';
import 'package:lms/screens/BookDetail/book_detail_screen.dart';
import 'package:lms/screens/Home/home_screen.dart';
import 'package:lms/screens/Login/login_screen.dart';
import 'package:lms/screens/SignUp/signup_page.dart';
import 'package:lms/screens/Welcome/welcome_screen.dart';
import 'package:lms/services/authentication_service.dart';
import 'package:lms/utils/user_preferences.dart';
import 'package:provider/provider.dart';
import 'screens/AddBook/add_book_screen.dart';
import 'screens/Notification/notification_screen.dart';
import 'screens/Profile/profile_screen.dart';

var admin = false;

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await UserPreferences.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(
          create: (_) => AuthenticationService(FirebaseAuth.instance),
        ),
        StreamProvider(
            create: (context) =>
                context.read<AuthenticationService>().authStateChanges,
            initialData: null),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'My Library',
        theme: ThemeData.dark(),
        home: const AuthWrapper(),
        routes: {
          loginRoute: (_) => const LoginScreen(),
          signUpRoute: (_) => const SignUpScreen(),
          welcomeRoute: (_) => const WelcomeScreen(),
          bottomNavPanelRoute: (_) => const BottomNavPanel(),
          homeRoute: (_) => const HomeScreen(),
          profileRoute: (_) => const ProfileScreen(),
          notificationRoute: (_) => const NotificationScreen(),
          addBookRoute: (_) => const AddBookScreen(),
          bookDetailRoute: (_) => const BookDetailScreen(),
          booksListRoute: (_) => const BooksSearchScreen(),
        },
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();

    if (firebaseUser != null) {
      admin = isAdmin();
      return const BottomNavPanel();
    }
    return const WelcomeScreen();
  }
}
