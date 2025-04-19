import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal(){
     sqfliteFfiInit();
    // Set the database factory
    databaseFactory = databaseFactoryFfi;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'my_database.db');
    return await openDatabase(path, version: 1, onCreate: _createDb);
  }

  Future<void> _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE books (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        author TEXT,
        status TEXT NOT NULL,
        start_date TEXT,
        end_date TEXT,
        notes TEXT,
        rating REAL,
        pages_read INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE book_notes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        book_id INTEGER NOT NULL,
        note TEXT NOT NULL,
        page INTEGER NOT NULL,
        date TEXT NOT NULL,
        FOREIGN KEY(book_id) REFERENCES books(id) ON DELETE CASCADE
      )
    ''');
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // ======== MÉTODOS PARA LIVROS ========

  Future<int> insertBook(Map<String, dynamic> book) async {
    final db = await database;
    return await db.insert('books', book);
  }

  Future<List<Map<String, dynamic>>> getBooks() async {
    final db = await database;
    return await db.query('books');
  }

  Future<Map<String, dynamic>?> getBook(int id) async {
    final db = await database;
    final result = await db.query('books', where: 'id = ?', whereArgs: [id]);
    return result.isNotEmpty ? result.first : null;
  }

  Future<int> updateBook(int id, Map<String, dynamic> book) async {
    final db = await database;
    return await db.update('books', book, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteBook(int id) async {
    final db = await database;
    return await db.delete('books', where: 'id = ?', whereArgs: [id]);
  }

  // ======== MÉTODOS PARA NOTAS ========

  Future<int> insertNote(Map<String, dynamic> note) async {
    final db = await database;
    return await db.insert('book_notes', note);
  }

  Future<List<Map<String, dynamic>>> getNotesForBook(int bookId) async {
    final db = await database;
    return await db.query(
      'book_notes',
      where: 'book_id = ?',
      whereArgs: [bookId],
      orderBy: 'page ASC'
    );
  }

  Future<int> deleteNote(int noteId) async {
    final db = await database;
    return await db.delete('book_notes', where: 'id = ?', whereArgs: [noteId]);
  }
}
