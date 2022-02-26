import 'package:lms/model/book_model.dart';

class Author {
  String uid;
  String name;
  List<Book> books;

  Author({required this.uid, required this.name, required this.books});
}
