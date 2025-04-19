import 'package:flutter/material.dart';
import 'package:book_app/models/book.dart';
import 'package:book_app/utils/database_helper.dart';

class BookListWidget extends StatelessWidget {
  final List<Book> books;
   final VoidCallback onRefreshBooks;

  const BookListWidget({Key? key, required this.books, required this.onRefreshBooks}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverOverlapInjector(
          handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                // Access the book data for this index
                final book = books[index];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/bookpage',
                        arguments: book, // envia o book como argumento
                      );
                    },
                    child: Card(
                      color: Colors.grey[100],
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          trailing: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              final existingBook = await DatabaseHelper()
                                  .getBooksByTitle(book.title);
                              if(existingBook.isNotEmpty){
                                final int existingBookId =
                                    existingBook.first['id'] as int;
                                await DatabaseHelper().deleteBook(existingBookId);

                                onRefreshBooks();
                              }
                            },
                          ),
                          // Display the book image on the left
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child:
                                book.img.startsWith('http')
                                    ? Image.network(
                                      book.img,
                                      width: 50,
                                      height: 90,
                                      fit: BoxFit.cover,
                                      errorBuilder: (
                                        context,
                                        error,
                                        stackTrace,
                                      ) {
                                        return Image.asset(
                                          'assets/defaultimg.jpg',
                                          width: 50,
                                          height: 90,
                                          fit: BoxFit.cover,
                                        );
                                      },
                                    )
                                    : Image.asset(
                                      'assets/defaultimg.jpg',
                                      width: 50,
                                      height: 90,
                                      fit: BoxFit.cover,
                                    ),
                          ),
                          // Display the book title
                          title: Text(
                            book.title,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(book.authors.join(', ')),
                        ),
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
  }
}
