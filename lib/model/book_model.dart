import 'package:lms/model/reader_model.dart';

import 'book_location.dart';

class Book {
  String? uid;
  String? title;
  List<String>? authors;
  List<String>? tags;
  String? category;
  Reader? issuedTo;
  Reader? requestedBy;
  BookLocation? bookLocation;

  Book({
    this.uid,
    this.title,
    this.authors,
    this.tags,
    this.category,
    this.issuedTo,
    this.requestedBy,
    this.bookLocation,
  });

  factory Book.fromMap(map) {
    return Book(
      issuedTo:
          (map['issued_to'] != null) ? Reader.fromMap(map['issued_to']) : null,
      requestedBy: (map['requested_by'] != null)
          ? Reader.fromMap(map['requested_by'])
          : null,
      bookLocation: (map['location'] != null)
          ? BookLocation.fromMap(map['location'])
          : null,
      tags: List.from(map['tags']),
      uid: map['uid'],
      title: map['title'],
      authors: List.from(map['authors']),
      category: map['category'],
    );
  }

  Map<String, dynamic> toMap() => {
        'uid': uid,
        'title': title,
        'authors': authors,
        'tags': tags,
        'category': category,
        'issued_to': issuedTo?.toMap(),
        'requested_by': requestedBy?.toMap(),
        'location': bookLocation?.toMap()
      };
}
