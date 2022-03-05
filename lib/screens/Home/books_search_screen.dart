import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lms/model/category_model.dart';
import 'package:lms/repository/data_repository.dart';
import '../../model/book_model.dart';
import '../../utils/constants.dart';
import 'components/book_card.dart';

class BooksSearchScreen extends StatefulWidget {
  const BooksSearchScreen({Key? key}) : super(key: key);

  @override
  State<BooksSearchScreen> createState() => _BooksSearchScreenState();
}

class _BooksSearchScreenState extends State<BooksSearchScreen> {
  getBooksStreamWidget() => StreamBuilder(
        stream: DataRepository().getBooksStream(),
        builder: ((context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          final data = snapshot.requireData;

          return ListView.builder(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            padding: const EdgeInsets.all(8),
            itemCount: data.size,
            itemBuilder: ((context, index) {
              final book = Book.fromMap(data.docs[index].data());
              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    bookDetailRoute,
                    arguments: book.uid,
                  );
                },
                child: BookCard(book),
              );
            }),
          );
        }),
      );

  getBooksStreamByCategoryWidget(Category category) => StreamBuilder(
        stream: DataRepository().getBooksStreamByCategory(category.uid!),
        builder: ((context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }
          if (!snapshot.hasError && snapshot.data?.size == 0) {
            return const Center(
              child: Text("No Books Available"),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final data = snapshot.requireData;

          return ListView.builder(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            padding: const EdgeInsets.all(8),
            itemCount: data.size,
            itemBuilder: ((context, index) {
              final book = Book.fromMap(data.docs[index].data());
              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    bookDetailRoute,
                    arguments: book.uid,
                  );
                },
                child: BookCard(book),
              );
            }),
          );
        }),
      );

  @override
  Widget build(BuildContext context) {
    final category = ModalRoute.of(context)?.settings.arguments as Category?;
    return Scaffold(
      appBar: (category != null)
          ? AppBar(
              title: Text("${category.title} Books"),
              backgroundColor: Colors.blue,
            )
          : null,
      body: (category == null)
          ? getBooksStreamWidget()
          : getBooksStreamByCategoryWidget(category),
    );
  }
}
