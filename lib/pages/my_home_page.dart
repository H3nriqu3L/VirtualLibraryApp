import 'package:flutter/material.dart';
import 'package:book_app/audio/app_colors.dart' as AppColors;
import 'package:book_app/widgets/home_nested_scroll.dart';
import 'package:book_app/widgets/header.dart';
import 'package:book_app/models/book.dart';
import 'package:book_app/utils/database_helper.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();

}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  List<Book> books = [];
  bool _isLoading = true;




  Future<void> _loadBooks() async {
    try {
      final db = DatabaseHelper();
      final List<Map<String, dynamic>> booksMap = await db.getBooks();

      setState(() {
        books = booksMap.map((map) => Book.fromDb(map)).toList();
        _isLoading = false;
      });
    } catch (e, stacktrace) {
      print('Error loading books: $e');
      print(stacktrace);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error loading data')));
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> refreshBooks() async {
    setState(() {
      _isLoading = true;
    });
    await _loadBooks();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadBooks();
  }

  @override
  void dispose(){
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _loadBooks();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadBooks();
  }

  @override
  Widget build(BuildContext context) {

    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final List<Book> popular_books = args?['popular_books'] ?? [];

    return Container(
      color: AppColors.background,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: SafeArea(child: Header()),
        ),
        backgroundColor: AppColors.background,
        body: Column(
          children: [
            SizedBox(height: 10),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(20, 16, 16, 10),
                  child: Text('Popular Books', style: TextStyle(fontSize: 30)),
                ),
              ],
            ),
            Divider(color: Colors.black, thickness: 2.0),
            SizedBox(height: 15),
            Container(
              height: 180,
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 180,
                      child: PageView.builder(
                        controller: PageController(viewportFraction: 0.5),
                        itemCount: popular_books.isEmpty ? 0 : popular_books.length,
                        itemBuilder: (_, index) {
                          final popular_book = popular_books[index];
                          return Container(
                            height: 180,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              image: DecorationImage(
                                image: AssetImage("assets/${popular_book.img}"),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Expanded(child: HomeNestedScroll(books: books, onRefreshBooks:refreshBooks ,)),
          ],
        ),
      ),
    );
  }
}
