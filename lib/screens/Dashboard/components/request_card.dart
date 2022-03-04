import 'package:flutter/material.dart';
import '../../../model/book_model.dart';

class RequestedCard extends StatelessWidget {
  Book book;
  RequestedCard(
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
                  "${book.requestedBy?.name} has requested for ${book.title}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Click To Take Actions",
                  style: TextStyle(fontWeight: FontWeight.w300),
                ),
              ],
            )));
  }
}
