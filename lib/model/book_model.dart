import 'package:lms/model/user_model.dart';

class Book {
  int id;
  String title;
  String authorName;
  List<String> tags;
  String category;
  UserModel? issuedTo;

  Book(
      {required this.id,
      required this.title,
      required this.authorName,
      required this.tags,
      required this.category,
      this.issuedTo});

  factory Book.fromMap(map) {
    return Book(
        id: map['id'],
        title: map['title'],
        authorName: map['author'],
        tags: map['tags'],
        category: map['category'],
        issuedTo: map['issued_to']);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'author': authorName,
      'tags': tags,
      'category': category,
      'issued_to': issuedTo
    };
  }
}
