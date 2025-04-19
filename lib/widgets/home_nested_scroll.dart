import 'package:flutter/material.dart';
import 'package:book_app/audio/app_colors.dart' as AppColors;
import 'package:book_app/widgets/book_list_widget.dart';
import 'package:book_app/utils/book.dart';


class HomeNestedScroll extends StatefulWidget {
  final List<Book> books;
  const HomeNestedScroll({super.key, required this.books});

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
    final List<String> tabs = <String>['Read', 'Reading'];
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
            // These are the contents of the tab views, below the tabs.
            children:
                tabs.map((String name) {
                  return SafeArea(
                    top: false,
                    bottom: false,
                    child: Builder(
                      builder: (BuildContext context) {
                        return BookListWidget(books: books);
                      },
                    ),
                  );
                }).toList(),
          ),
        ),
      ),
    );
  }
}
