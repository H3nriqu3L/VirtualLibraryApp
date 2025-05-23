import 'package:flutter/material.dart';
import 'package:book_app/pages/my_home_page.dart';
import 'package:book_app/pages/loading_page.dart';
import 'package:book_app/pages/searching_page.dart';
import 'package:book_app/pages/book_page.dart';
import 'package:book_app/pages/history_book_page.dart';
import 'package:path/path.dart';


void main() {
  runApp(MaterialApp(
    title: 'Book App',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    initialRoute: '/',
    routes: {
      '/':(context) => LoadingPage(),
      '/home': (context) => MyHomePage(),
      '/search':(context) => SearchingPage(),
      '/bookpage':(context) => BookPage(),
      '/history':(context) => HistoryBookPage()
    },
  ));
}
