class Reader {
  String? uid;
  String? name;

  Reader({this.name, this.uid});

  factory Reader.fromMap(map) {
    return Reader(
      uid: map['uid'],
      name: map['name'],
    );
  }

  Map<String, dynamic> toMap() => {
        'uid': uid,
        'name': name,
      };
}
