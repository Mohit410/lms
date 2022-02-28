import 'package:flutter/material.dart';
import 'package:lms/model/book_model.dart';

class BookCard extends StatefulWidget {
  final Book _book;

  const BookCard(
    this._book, {
    Key? key,
  }) : super(key: key);

  @override
  State<BookCard> createState() => _BookCardState();
}

class _BookCardState extends State<BookCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Title: ${widget._book.title}",
                style: TextStyle(fontWeight: FontWeight.bold)),
            Text("Category: ${widget._book.category?.title}"),
            Row(
              children: [
                const Text("Authors: "),
                Text("${widget._book.authors?.map((e) => e)}")
              ],
            )
          ],
        ),
      ),
    );
  }
}
