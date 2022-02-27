class Category {
  String? uid;
  String? title;

  Category({
    required this.uid,
    required this.title,
  });

  factory Category.fromMap(Map<String, String> map) =>
      Category(uid: map['uid'], title: map['title']);

  Map<String, String> toMap() => {
        'uid': uid!,
        'title': title!,
      };

  @override
  String toString() => title.toString();
}
