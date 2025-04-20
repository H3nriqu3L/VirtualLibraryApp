class Note {
  int? id;
  int bookId;
  String note;
  int page;
  String date;
  double progress;


  Note({
    this.id,
    required this.bookId,
    required this.note,
    required this.page,
    required this.date,
    this.progress=0.0
  });

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      bookId: map['book_id'],
      note: map['note'],
      page: map['page'],
      date: map['date'],
      progress: map['progress'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'book_id': bookId,
      'note': note,
      'page': page,
      'date': date,
      'progress': progress,
    };
  }
}
