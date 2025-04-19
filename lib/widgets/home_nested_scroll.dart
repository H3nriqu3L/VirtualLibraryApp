import 'package:flutter/material.dart';
import 'package:book_app/audio/app_colors.dart' as AppColors;


class HomeNestedScroll extends StatefulWidget {
  final List<Map<String, dynamic>> books;
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
                        return CustomScrollView(
                          key: PageStorageKey<String>(name),
                          slivers: <Widget>[
                            SliverOverlapInjector(
                              handle:
                                  NestedScrollView.sliverOverlapAbsorberHandleFor(
                                    context,
                                  ),
                            ),
                            SliverPadding(
                              padding: const EdgeInsets.all(16),
                              sliver: SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (BuildContext context, int index) {
                                    // Access the book data for this index
                                    final book = books[index];

                                    return Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 12,
                                      ),
                                      child: Card(
                                        color: Colors.grey[100],
                                        elevation: 2,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ListTile(
                                            // Display the book image on the left
                                            leading: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              child: Image.asset(
                                                'assets/${book['img']}',
                                                width: 50,
                                                height: 80,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            // Display the book title
                                            title: Text(
                                              book['title'],
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            subtitle: Text(book['author']),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  // Use the number of books as the child count
                                  childCount: books.length,
                                ),
                              ),
                            ),
                          ],
                        );
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
