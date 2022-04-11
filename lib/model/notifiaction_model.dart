import 'package:lms/model/reader_model.dart';

import 'book_model.dart';

class Notification {
  String? uid;
  String? type;
  int? timeStamp;
  Book? book;
  Reader? reader;

  Notification({this.uid, this.type, this.timeStamp, this.book, this.reader});

  factory Notification.fromMap(map) => Notification(
        uid: map['uid'],
        type: map['type'],
        timeStamp: map['timestamp'],
        book: Book.fromMap(['book']),
        reader: Reader.fromMap(map['reader']),
      );

  toMap() => {
        'uid': uid,
        'type': type,
        'timestamp': timeStamp,
        'book': book!.toMap(),
        'reader': reader!.toMap(),
      };
}
