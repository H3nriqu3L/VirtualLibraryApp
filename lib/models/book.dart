import 'package:http/http.dart';
import 'dart:convert';
import 'dart:developer';

class Book {
  String title;
  List<String> authors;
  String description;
  String img;
  String? subtitle;
  String? publisher;
  String? publishedDate;
  int? pageCount;
  List<String>? categories;
  String? language;
  String status;
  int? id;

  Book({
    required this.title,
    required this.authors,
    required this.description,
    required this.img,
    this.subtitle,
    this.publisher,
    this.publishedDate,
    this.pageCount,
    this.categories,
    this.language,
    this.status = 'notStarted',
    this.id,
  });

  void setStatus(String st){
    status = st;
  }

  factory Book.fromJson(Map<String, dynamic> json) {
    final volumeInfo = json['volumeInfo'];

    return Book(
      title: volumeInfo['title'] ?? 'No title',
      authors: List<String>.from(volumeInfo['authors'] ?? ['Unknown author']),
      description: volumeInfo['description'] ?? 'No description available',
      img: volumeInfo['imageLinks']?['thumbnail'] ?? 'defaultimg.jpg',
      subtitle: volumeInfo['subtitle'],
      publisher: volumeInfo['publisher'],
      publishedDate: volumeInfo['publishedDate'],
      pageCount: volumeInfo['pageCount'],
      categories:
          (volumeInfo['categories'] as List?)
              ?.map((e) => e.toString())
              .toList(),
      language: volumeInfo['language'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'author': authors.join(', '),
      'status': status, // você pode alterar conforme o necessário
      'start_date': null,
      'end_date': null,
      'notes': description,
      'rating': null,
      'img': img,
      'pageCount': pageCount,

    };
  }

  factory Book.fromDb(Map<String, dynamic> map) {
  return Book(
    title: map['title'],
    authors: map['author'] != null ? map['author'].split(', ') : ['Unknown'],
    description: map['notes'] ?? 'No description',
    img: map['img'] ?? 'defaultimg.jpg', // ou uma imagem default
    subtitle: null,
    publisher: null,
    publishedDate: null,
    pageCount: map['pageCount'],
    categories: null,
    language: null,
    status: map['status'],
    id: map['id'],
  );
}
}

Future<List<Book>> fetchBooks(String query) async {
  final url = Uri.parse('https://www.googleapis.com/books/v1/volumes?q=$query');
  final response = await get(url);

  // log('Resposta da API:', name: 'GoogleBooksAPI');
  // log(response.body, name: 'GoogleBooksAPI');

  if (response.statusCode == 200) {
    final Map data = jsonDecode(response.body);
    final items = data['items'] as List<dynamic>;
    return items.map((item) => Book.fromJson(item)).toList();
  } else {
    throw Exception('Erro ao carregar livros');
  }
}

Future<Book> fetchBook(String query) async {
  final url = Uri.parse('https://www.googleapis.com/books/v1/volumes?q=$query');
  final response = await get(url);

  // log('Resposta da API:', name: 'GoogleBooksAPI');
  // log(response.body, name: 'GoogleBooksAPI');

  if (response.statusCode == 200) {
    final Map data = jsonDecode(response.body);
    final item = data['items']?.first;  // Pegando apenas o primeiro item
    if (item != null) {
      return Book.fromJson(item);
    } else {
      throw Exception('Nenhum livro encontrado');
    }
  } else {
    throw Exception('Erro ao carregar livro');
  }
}
