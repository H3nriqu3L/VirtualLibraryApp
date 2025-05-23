import 'package:flutter/material.dart';
import 'package:book_app/audio/app_colors.dart' as AppColors;
import 'package:book_app/widgets/header.dart';
import 'package:book_app/models/book.dart';
import 'package:book_app/widgets/description.dart';
import 'package:book_app/widgets/floating_button.dart';
import 'package:book_app/utils/database_helper.dart';

class BookPage extends StatelessWidget {
  const BookPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Book book = ModalRoute.of(context)?.settings.arguments as Book;
    final db = DatabaseHelper();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: SafeArea(child: Header()),
      ),
      floatingActionButton: MyFloatingButton(book: book),
      body: SingleChildScrollView(
        // Isso permite que a tela role para baixo
        child: Column(
          children: [
            // Imagem do livro
            Container(
              margin: EdgeInsets.only(top: 16),
              child: Center(
                child:
                    book.img.startsWith('http')
                        ? Image.network(
                          book.img,
                          width: 150,
                          height: 220,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              'assets/defaultimg.jpg',
                              width: 150,
                              height: 220,
                              fit: BoxFit.cover,
                            );
                          },
                        )
                        : Image.asset(
                          'assets/defaultimg.jpg',
                          width: 150,
                          height: 220,
                          fit: BoxFit.cover,
                        ),
              ),
            ),
            SizedBox(height: 5),
            Divider(color: Colors.black, thickness: 2.0),
            // Título do livro
            Container(
              margin: EdgeInsets.fromLTRB(20, 16, 16, 10),
              child: Text(book.title, style: TextStyle(fontSize: 22)),
            ),
            // Autor
            Container(
              margin: EdgeInsets.fromLTRB(20, 8, 16, 5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Authors: ',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: Text(
                      book.authors.join(', '),
                      style: TextStyle(
                        fontSize: 18,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Descrição
            DescriptionWidget(book: book),
            Container(
              margin: EdgeInsets.fromLTRB(20, 8, 16, 5),
              child: Row(
                children: [
                  Text(
                    'Genders',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(20, 0, 16, 3),
              child: Row(
                children: [
                  Wrap(
                    alignment: WrapAlignment.start,
                    spacing: 8, // Gap between adjacent chips
                    runSpacing: 8, // Gap between lines
                    children:
                        book.categories?.map<Widget>((category) {
                          return Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 7,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              category,
                              style: TextStyle(fontSize: 14),
                            ),
                          );
                        }).toList() ??
                        [], // Provide empty list as fallback if categories is null
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Container(
              margin: EdgeInsets.fromLTRB(20, 8, 16, 5),
              child: Row(
                children: [
                  Text(
                    'Status',

                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(20, 0, 16, 3),
              child: Row(
                children: [
                  FutureBuilder(
                    future: db.getBookStatusByTitle(book.title),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        final bool showEditButton =
                            snapshot.data == 'reading' ||
                            snapshot.data == 'read';
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 7,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    snapshot.data == 'read'
                                        ? Colors.green
                                        : snapshot.data == 'reading'
                                        ? Colors.yellow
                                        : Colors.grey[200],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                snapshot.data?.toUpperCase() ?? 'notStarted',
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                            if (showEditButton)
                              TextButton.icon(
                                icon: Icon(
                                  Icons.edit,
                                  size: 20,
                                  color: Colors.black,
                                ),
                                label: Text(
                                  'Edit Notes',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ), // Estilo do texto
                                ),
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/history',
                                    arguments: book,
                                  );
                                },
                              ),
                          ],
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
