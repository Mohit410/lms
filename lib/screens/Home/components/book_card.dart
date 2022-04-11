import 'package:flutter/material.dart';
import 'package:lms/model/book_model.dart';

class BookCard extends StatelessWidget {
  final Book _book;

  const BookCard(
    this._book, {
    Key? key,
  }) : super(key: key);

  String getAuthorsString(List<String> authors) {
    var authorsString = "";
    for (var author in authors) {
      authorsString += author + ", ";
    }
    return authorsString.endsWith(", ")
        ? authorsString.substring(0, authorsString.length - 2)
        : " ";
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Title: ${_book.title}",
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(
              height: 8,
            ),
            Text("Category: ${_book.category}",
                style: const TextStyle(
                    fontWeight: FontWeight.normal, fontSize: 14)),
            const SizedBox(
              height: 8,
            ),
            Wrap(
              children: [
                const Text("Authors: "),
                Text(getAuthorsString(_book.authors!),
                    style: const TextStyle(
                        fontWeight: FontWeight.normal, fontSize: 14)),
              ],
            )
          ],
        ),
      ),
    );
  }
}
