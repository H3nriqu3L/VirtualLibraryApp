import 'package:flutter/material.dart';
import 'package:book_app/audio/app_colors.dart' as AppColors;
import 'package:book_app/widgets/home_nested_scroll.dart';
import 'package:book_app/widgets/header.dart';
import 'package:book_app/models/book.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final Map<String, dynamic> args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final List<Book> books = List<Book>.from(args['books']);
    
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
                  margin: EdgeInsets.fromLTRB(20,16,16,10),
                  child: Text(
                    'Popular Books',
                    style: TextStyle(fontSize: 30),
                  ),
                ),
              ],
            ),
            Divider(color: Colors.black, thickness: 2.0,),
            SizedBox(height: 15,),
            Container(
              height: 180,
              child: Stack(
                children: [
                  Positioned(
                    top:0,
                    left:0,
                    right:0,
                    child: Container(
                      height: 180,
                      child: PageView.builder(
                        controller: PageController(viewportFraction: 0.5),
                        itemCount: books.isEmpty?0:books.length,
                        itemBuilder: (_, index) {
                          final book = books[index];
                          return Container(
                            height: 180,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              image: DecorationImage(
                                image: AssetImage(
                                  "assets/${book.img}",
                                ),
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
            SizedBox(height: 10,),
            Expanded(child: HomeNestedScroll(books: books)),
          ],
        ),
      ),
    );
  }
}
