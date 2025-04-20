import 'package:flutter/material.dart';
import 'package:book_app/utils/database_helper.dart';
import 'package:book_app/models/note.dart';
import 'package:book_app/models/book.dart';

class AddNoteSheet extends StatefulWidget {
  final int id;
  const AddNoteSheet({super.key, required this.id});

  @override
  State<AddNoteSheet> createState() => _AddNoteSheetState();
}

class _AddNoteSheetState extends State<AddNoteSheet> {
  final _formKey = GlobalKey<FormState>();
  final _pagesController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _pagesController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveNote() async {
    //DatabaseHelper().logDatabaseContent();

    if (_formKey.currentState!.validate()) {
      final pages = int.parse(_pagesController.text);
      final description = _descriptionController.text;

      //print('Páginas lidas: $pages');
      //print('Descrição: $description');

      final DateTime now = DateTime.now();
      final String date = now.toIso8601String();

      final bookMap = await DatabaseHelper().getBook(widget.id);
      final book = Book.fromDb(bookMap!);

      final int? totalPages = book.pageCount;
      double progress = 0.0;

      //print('Total de paginas no livro: $totalPages');


      if (totalPages != null && totalPages > 0) {
        progress = pages / totalPages;
        if (progress > 1.0) progress = 1.0; // Garante que não ultrapasse 100%
      }

      Note note = Note(
        bookId: widget.id,
        note: description,
        page: pages,
        date: date,
        progress: progress,
      );

      int id = await DatabaseHelper().insertNote(note);
      note.id = id;
      print('O id da note é $id');

      Navigator.of(context).pop(); // Fecha o modal
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        top: 24,
      ),
      child: Form(
        key: _formKey,
        child: Wrap(
          runSpacing: 16,
          children: [
            const Center(
              child: Text(
                'Add Note',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            TextFormField(
              controller: _pagesController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Total of pages read',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'This field is mandatory';
                }
                if (int.tryParse(value) == null) {
                  return 'Enter a valid number';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Description (optional)',
                border: OutlineInputBorder(),
              ),
            ),
            ElevatedButton.icon(
              onPressed: _saveNote,
              icon: const Icon(Icons.save, color: Colors.black),
              label: const Text('Save', style: TextStyle(color: Colors.black)),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
