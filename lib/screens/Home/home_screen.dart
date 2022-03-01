import 'package:flutter/material.dart';
import 'package:lms/screens/Home/books_search_screen.dart';
import 'package:lms/screens/Home/category_screen.dart';
import 'package:lms/utils/user_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return (isAdmin()) ? const BooksSearchScreen() : const CategoryScreen();
  }
}
