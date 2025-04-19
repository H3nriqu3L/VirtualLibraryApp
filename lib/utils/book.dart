import 'package:http/http.dart';
import 'dart:convert';

class Book {
  String title;
  List<String> authors;
  String description;
  String img;

  Book({
    required this.title,
    required this.authors,
    required this.description,
    required this.img,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    final volumeInfo = json['volumeInfo'];

    return Book(
      title: volumeInfo['title'] ?? 'No title',
      authors: List<String>.from(volumeInfo['authors'] ?? ['Unknown author']),
      description: volumeInfo['description'] ?? 'No description available',
      img: volumeInfo['imageLinks']?['thumbnail'] ?? 'default_img.jpg',
    );
  }
}

Future<List<Book>> fetchBooks(String query) async {
  final url = Uri.parse('https://www.googleapis.com/books/v1/volumes?q=$query');
  final response = await get(url);

  if (response.statusCode == 200) {
    final Map data = jsonDecode(response.body);
    final items = data['items'] as List<dynamic>;
    return items.map((item) => Book.fromJson(item)).toList();
  } else {
    throw Exception('Erro ao carregar livros');
  }
}
