import 'package:flutter/material.dart';
import 'package:lms/main.dart';
import 'package:lms/screens/Home/books_search_screen.dart';
import 'package:lms/screens/Home/category_screen.dart';
import '../../utils/constants.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: (admin)
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.pushNamed(context, addBookRoute);
              },
              label: const Text('Add a book'),
              icon: const Icon(Icons.add_rounded),
              backgroundColor: Colors.blue,
            )
          : null,
      body: (admin) ? const BooksSearchScreen() : const CategoryScreen(),
    );
  }
}
