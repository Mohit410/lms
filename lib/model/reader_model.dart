class Reader {
  String? uid;
  String? name;

  Reader({String? name, String? uid});

  factory Reader.fromMap(map) {
    return Reader(
      uid: map['uid'] as String,
      name: map['name'] as String,
    );
  }

  Map<String, dynamic> toMap() => {
        'uid': uid!,
        'name': name!,
      };
}
