import 'package:flutter/material.dart';
import 'package:lms/main.dart';
import 'package:lms/model/book_model.dart';

class NotificationCard extends StatefulWidget {
  Book book;
  NotificationCard(this.book, {Key? key}) : super(key: key);

  @override
  State<NotificationCard> createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> {
  var message = "";
  @override
  void initState() {
    super.initState();
    message = (admin)
        ? "${widget.book.requestedBy} has requested for ${widget.book.title}."
        : "Admin has approved your request for ${widget.book.title}.";
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Text(
              message,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
