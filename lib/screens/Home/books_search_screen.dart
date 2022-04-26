import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
  final searchController = TextEditingController();

  String searchQuery = "";

  late FocusNode searchFocusNode;

  @override
  void initState() {
    super.initState();
    searchFocusNode = FocusNode();
  }

  @override
  void dispose() {
    searchFocusNode.dispose();
    super.dispose();
  }

  getSearchedList(QuerySnapshot<Object?> data) {
    final queryString = searchQuery.toLowerCase();
    return data.docs
        .map((e) {
          if ((e.get('title') as String).toLowerCase().contains(queryString)) {
            return e;
          } else if ((e.get('authors') as List).any((element) =>
              (element as String).toLowerCase().contains(queryString))) {
            return e;
          } else if ((e.get('tags') as List).any((element) =>
              (element as String).toLowerCase().contains(queryString))) {
            return e;
          } else if (e.get('issued_to') != null) {
            if (((e.get('issued_to') as Map)['name'] as String)
                .toLowerCase()
                .contains(queryString)) {
              return e;
            }
          } else if (e.get('requested_by') != null) {
            if (((e.get('requested_by') as Map)['name'] as String)
                .toLowerCase()
                .contains(queryString)) {
              return e;
            }
          }
        })
        .where((element) => element != null)
        .toList();
  }

  getBooksStreamWidget() => StreamBuilder(
        stream: DataRepository().getBooksStream(),
        builder: ((context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.data?.size == 0) {
            return const Center(
              child: Text("No Books Available"),
            );
          }

          final list = getSearchedList(snapshot.requireData);

          return ListView.builder(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            padding: const EdgeInsets.all(8),
            itemCount: list.length,
            itemBuilder: ((context, index) {
              final book = Book.fromMap(list[index]!.data());
              return GestureDetector(
                onTap: () {
                  searchFocusNode.unfocus();
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

  getBooksStreamByCategoryWidget(String category) => StreamBuilder(
        stream: DataRepository().getBooksStreamByCategory(category),
        builder: ((context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }
          if (snapshot.data?.size == 0) {
            return const Center(
              child: Text("No Books Available"),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final list = getSearchedList(snapshot.requireData);

          return ListView.builder(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            padding: const EdgeInsets.all(8),
            itemCount: list.length,
            itemBuilder: ((context, index) {
              final book = Book.fromMap(list[index]!.data());
              return GestureDetector(
                onTap: () {
                  searchFocusNode.unfocus();
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
    final category = ModalRoute.of(context)?.settings.arguments as String?;
    return Scaffold(
      appBar: (category != null)
          ? AppBar(
              title: Text("$category Books"),
              backgroundColor: Colors.blue,
            )
          : null,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              textInputAction: TextInputAction.search,
              focusNode: searchFocusNode,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                  hintText: "Search Books",
                  hintStyle: const TextStyle(color: Colors.white),
                  prefixIcon: const Icon(Icons.search_rounded),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8))),
              controller: searchController,
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: (category == null)
                ? getBooksStreamWidget()
                : getBooksStreamByCategoryWidget(category),
          )
        ],
      ),
    );
  }
}
