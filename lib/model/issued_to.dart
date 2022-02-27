class IssuedTo {
  String? uid;
  String? name;

  IssuedTo({String? name, String? uid});

  factory IssuedTo.fromMap(Map<String, String> map) {
    return IssuedTo(
      uid: map['uid'],
      name: map['name'],
    );
  }

  Map<String, String> toMap() => {
        'uid': uid!,
        'name': name!,
      };
}
