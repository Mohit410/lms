import 'package:lms/model/user_model.dart';

class Book {
  int id;
  String title;
  String authorName;
  //List<String> tags;
  //String category;
  //UserModel issuedTo;
  String status;

  Book(
      //this.issuedTo,
      {
    required this.id,
    required this.title,
    required this.authorName,
    // required this.tags,
    // required this.category,
    required this.status,
  });

  factory Book.fromMap(map) {
    return Book(
        id: map['id'],
        title: map['title'],
        authorName: map['author'],
        // tags: map['tags'],
        // category: map['category'],
        status: map['status']);
    //issuedTo: map['issued_to']);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'author': authorName,
      // 'tags': tags,
      // 'category': category,
      'status': status
      //'issued_to': issuedTo
    };
  }

  toJson() => {
        'id': id,
        'title': title,
        'author': authorName,
        // 'tags': tags,
        // 'category': category,
        'status': status
        //'issued_to': issuedTo
      };
}
