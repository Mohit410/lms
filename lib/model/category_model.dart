class Category {
  String? uid;
  String? title;

  Category({
    required this.uid,
    required this.title,
  });

  factory Category.fromMap(map) =>
      Category(uid: map['uid'], title: map['title']);

  Map<String, dynamic> toMap() => {
        'uid': uid!,
        'title': title!,
      };

  @override
  String toString() => title.toString();
}
