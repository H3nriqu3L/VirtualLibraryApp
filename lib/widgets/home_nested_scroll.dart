import 'package:flutter/material.dart';
import 'package:book_app/audio/app_colors.dart' as AppColors;
import 'package:book_app/widgets/book_list_widget.dart';
import 'package:book_app/models/book.dart';

class HomeNestedScroll extends StatefulWidget {
  final List<Book> books;
  final VoidCallback onRefreshBooks;
  const HomeNestedScroll({super.key, required this.books, required this.onRefreshBooks,});

  @override
  State<HomeNestedScroll> createState() => _HomeNestedScrollState();
}

class _HomeNestedScrollState extends State<HomeNestedScroll> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final books = widget.books;
    books.forEach((book) {
      print('Título: ${book.title}, Status: ${book.status}');
    });
    final List<String> tabs = <String>['Read', 'Reading'];
    final readBooks = books.where((book) => book.status == 'read').toList();
    final readingBooks =
        books.where((book) => book.status == 'reading').toList();

    return DefaultTabController(
      length: tabs.length, // This is the number of tabs.
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverOverlapAbsorber(
                handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                  context,
                ),
                sliver: SliverAppBar(
                  pinned: true,
                  expandedHeight: 0,
                  backgroundColor: AppColors.background,
                  forceElevated: innerBoxIsScrolled,
                  bottom: PreferredSize(
                    preferredSize: Size.fromHeight(10),
                    child: TabBar(
                      indicatorColor: Colors.black, // Change indicator color
                      labelColor: Colors.black,
                      // These are the widgets to put in each tab in the tab bar.
                      tabs: tabs.map((String name) => Tab(text: name)).toList(),
                    ),
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(
            children: [
              SafeArea(
                top: false,
                bottom: false,
                child: BookListWidget(books: readBooks, onRefreshBooks:widget.onRefreshBooks),
              ),
              SafeArea(
                top: false,
                bottom: false,
                child: BookListWidget(books: readingBooks, onRefreshBooks: widget.onRefreshBooks),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
