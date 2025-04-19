import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:book_app/utils/book.dart';


class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  Future<void> readData(BuildContext context) async {
    final String filePath = 'json/popular_books.json';
    final String jsonString = await rootBundle.loadString(filePath);

    List<dynamic> booksJson = jsonDecode(jsonString);

    List<Book> books = booksJson.map((json) => Book.fromJson(json)).toList();
    // List<Map<String, dynamic>> booksData = List<Map<String, dynamic>>.from(
    //   booksJson,
    // );



    Navigator.pushReplacementNamed(
      context,
      '/home',
      arguments: {'books': books},
    );
  }

  @override
  void initState() {
    super.initState();
    readData(context);
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
