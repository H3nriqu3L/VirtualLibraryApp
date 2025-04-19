import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:book_app/models/book.dart';
import 'package:book_app/utils/database_helper.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {

  
  Future<void> readData(BuildContext context) async {
    final List<String> queries = [
      "Crime e castigo",
      "Dom Quixote",
      "A irmandade do Anel",
      "Moby Dick",
      "A fazenda dos Animais",
      "A metamorfose",
      "Os miseráveis",
      "A guerra dos tronos",
      "Duna"

    ];

    List<Book> books = [];

    for (var query in queries) {
      try {
        Book book = await fetchBook(query);  // Busca o livro individualmente
        books.add(book);  // Adiciona o livro à lista
      } catch (e) {
        //log('Erro ao buscar livro: $query - $e', name: 'GoogleBooksAPI');
      }
    }

    Navigator.pushReplacementNamed(
      context,
      '/home',
      arguments: {'popular_books': books},
    );
  }

  Future<void> setupDatabase() async {
    DatabaseHelper databaseHelper =
        DatabaseHelper(); // Instancia o DatabaseHelper
    await databaseHelper.database;
  }

  @override
  void initState() {
    super.initState();
    readData(context);
    setupDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Center(
        child: SpinKitRing(color: Colors.grey, size: 100.0, lineWidth: 10.0),
      ),
    );
  }
}
