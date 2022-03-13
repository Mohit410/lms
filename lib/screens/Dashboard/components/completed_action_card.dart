import 'package:flutter/material.dart';
import '../../../model/book_model.dart';

class CompletedActionCard extends StatelessWidget {
  Book book;
  CompletedActionCard(
    this.book, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        shadowColor: Colors.redAccent,
        elevation: 2,
        child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${book.title} has been approved to ${book.issuedTo!.name}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
              ],
            )));
  }
}
