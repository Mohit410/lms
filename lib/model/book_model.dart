import 'package:lms/model/category_model.dart';
import 'package:lms/model/reader_model.dart';
import 'package:lms/model/user_model.dart';

class Book {
  String? uid;
  String? title;
  List<String>? authors;
  List<String>? tags;
  Category? category;
  Reader? issuedTo;
  Reader? requestedBy;

  //UserModel issuedTo;
  String? status;

  Book({
    this.uid,
    this.title,
    this.authors,
    this.tags,
    this.category,
    this.status,
    this.issuedTo,
    this.requestedBy,
  });

  factory Book.fromMap(map) {
    return Book(
      issuedTo:
          (map['issued_to'] != null) ? Reader.fromMap(map['issued_to']) : null,
      requestedBy: (map['requested_by'] != null)
          ? Reader.fromMap(map['requested_by'])
          : null,
      tags: List.from(map['tags']),
      uid: map['uid'],
      title: map['title'],
      authors: List.from(map['authors']),
      category: Category.fromMap(map['category']),
      status: map['status'],
    );
  }

  Map<String, dynamic> toMap() => {
        'uid': uid,
        'title': title,
        'authors': authors,
        'tags': tags,
        'category': category?.toMap(),
        'status': status,
        'issuedTo': issuedTo?.toMap(),
        'requested_by': requestedBy?.toMap(),
      };
}
