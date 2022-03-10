class BookLocation {
  String? rackNo;
  String? rowNo;
  String? position;
  String? direction;

  BookLocation({
    this.rackNo,
    this.rowNo,
    this.position,
    this.direction,
  });

  factory BookLocation.fromMap(map) {
    return BookLocation(
      rackNo: map['rack'],
      rowNo: map['row'],
      position: map['pos'],
      direction: map['dir'],
    );
  }

  toMap() => {
        'rack': rackNo,
        'row': rowNo,
        'pos': position,
        'dir': direction,
      };
}
