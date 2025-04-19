import 'package:flutter/material.dart';

class MyFloatingButton extends StatelessWidget {
  const MyFloatingButton({super.key});

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
                        // await BookDatabase.instance.addBook(
                        //   book,
                        //   status: 'read',
                        // );
                        Navigator.pop(context); // Fecha o modal
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Added to Read list')),
                        );
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.menu_book, color: Colors.orange),
                      title: Text('Reading'),
                      onTap: () async {
                        // await BookDatabase.instance.addBook(
                        //   book,
                        //   status: 'reading',
                        // );
                        Navigator.pop(context); // Fecha o modal
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Added to Reading list')),
                        );
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