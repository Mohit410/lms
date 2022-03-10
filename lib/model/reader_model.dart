class Reader {
  String? uid;
  String? name;
  String? returnDate;

  Reader({this.name, this.uid, this.returnDate});

  factory Reader.fromMap(map) {
    return Reader(
      uid: map['uid'],
      name: map['name'],
      returnDate: map['return_date'],
    );
  }

  Map<String, dynamic> toMap() => {
        'uid': uid,
        'name': name,
        'return_date': returnDate,
      };
}
