import 'package:flutter/material.dart';
import 'package:book_app/widgets/history_note.dart';
import 'package:book_app/audio/app_colors.dart' as AppColors;
import 'package:book_app/widgets/home_nested_scroll.dart';
import 'package:book_app/widgets/header.dart';
import 'package:book_app/models/book.dart';
import 'package:book_app/utils/database_helper.dart';
import 'package:book_app/models/book.dart';
import 'package:book_app/models/note.dart';
import 'package:book_app/widgets/floating_button_note.dart';

class HistoryBookPage extends StatefulWidget {
  const HistoryBookPage({super.key});

  @override
  State<HistoryBookPage> createState() => _HistoryBookPageState();
}

class _HistoryBookPageState extends State<HistoryBookPage> {
  List<Map<String, dynamic>> noteList = [];
  bool _isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Get book from route arguments
    final book = ModalRoute.of(context)!.settings.arguments as Book;
    // Load notes for this book
    _loadNotes(book);
  }

  Future<void> _loadNotes(Book book) async {
    try {
      final notes = await DatabaseHelper().getNotesForBook(book.id!);
      setState(() {
        noteList = notes;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error loading notes: $e');
    }
  }

   void _onNoteDeleted(Book book) {
    _loadNotes(book); // Recarrega as notas após a exclusão
  }


  @override
  Widget build(BuildContext context) {
    final book = ModalRoute.of(context)!.settings.arguments as Book;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: SafeArea(child: Header()),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 10),
          const Row(
            children: [
              Padding(
                padding:  const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
                child: Text('Notes', style: TextStyle(fontSize: 30)),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 16, 20, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MyFloatingButtonNote(id: book.id!),
              ],
            ),
          ),
          Expanded(
            child:
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      itemCount: noteList.length,
                      itemBuilder: (context, index) {
                        final note = noteList[index];
                        return HistoryNote(
                          book: book,
                          noteList: [note],
                          onNoteDeleted: _onNoteDeleted, // passa uma lista com 1 único note
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}
