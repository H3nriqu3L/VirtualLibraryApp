import 'package:flutter/material.dart';
import 'package:book_app/utils/database_helper.dart';
import 'package:book_app/models/book.dart';


class MyFloatingButton extends StatelessWidget {
  final Book book;
  const MyFloatingButton({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (context) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: Icon(Icons.book, color: Colors.green),
                    title: Text('Read'),
                    onTap: () async {
                      Navigator.pop(context, true); 

                      try {
                        // Add status 'read'
                        book.setStatus('read');
                        await DatabaseHelper().insertBook(book);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Added to Read list')),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text('Error: $e')));
                      }
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.menu_book, color: Colors.orange),
                    title: Text('Reading'),
                    onTap: () async {
                      Navigator.pop(context, true);

                      try {
                        // Add status 'reading'
                        book.setStatus('reading');
                        await DatabaseHelper().insertBook(book);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Added to Reading list')),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text('Error: $e')));
                      }
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
      backgroundColor: Colors.grey[300],
      foregroundColor: Colors.black,
      shape: CircleBorder(),
      child: const Icon(Icons.add),
    );
  }
}
