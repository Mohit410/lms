import 'package:lms/model/category_model.dart';
import 'package:lms/model/issued_to.dart';
import 'package:lms/model/user_model.dart';

class Book {
  String uid;
  String title;
  List<String> authors;
  List<String> tags;
  Category category;
  IssuedTo? issuedTo;

  //UserModel issuedTo;
  String status;

  Book({
    required this.uid,
    required this.title,
    required this.authors,
    required this.tags,
    required this.category,
    required this.status,
    required this.issuedTo,
  });

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
        issuedTo: IssuedTo.fromMap(map['issued_to']),
        tags: List.from(map['tags']),
        uid: map['uid'],
        title: map['title'],
        authors: List.from(map['authors']),
        category: Category.fromMap(map['category']),
        status: map['status']);
  }

  Map<String, dynamic> toMap() => {
        'uid': uid,
        'title': title,
        'authors': authors,
        'tags': tags,
        'category': category.toMap(),
        'status': status,
        'issuedTo': issuedTo?.toMap()
        //'issued_to': issuedTo
      };
}
