import 'package:book_app/utils/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:book_app/models/book.dart';
import 'package:book_app/models/note.dart';

class HistoryNote extends StatefulWidget {
  final Book book;
  final List<Map<String, dynamic>> noteList;
  final Function(Book) onNoteDeleted;

  const HistoryNote({super.key, required this.book, required this.noteList, required this.onNoteDeleted});

  @override
  State<HistoryNote> createState() => _HistoryNoteState();
}

class _HistoryNoteState extends State<HistoryNote> {
  @override
  Widget build(BuildContext context) {
    // Cálculo do progresso máximo entre as notas
    final double progress = widget.noteList
        .map((n) => (n['progress'] as num?)?.toDouble() ?? 0.0)
        .fold(0.0, (prev, curr) => curr > prev ? curr : prev);

    return Card(
      color: Colors.grey[100],
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child:
                    widget.book.img.startsWith('http')
                        ? Image.network(
                          widget.book.img,
                          width: 50,
                          height: 90,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
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
              title: Text(
                widget.book.title,
                style: TextStyle(fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              subtitle: Text(
                widget.book.authors.join(', '),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 16.0,
                right: 16.0,
                bottom: 8.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Reading Progress: ${(progress * 100).toStringAsFixed(0)}%',
                    style: TextStyle(fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                  const SizedBox(height: 8),
                  if (widget.noteList.isNotEmpty)
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: widget.noteList.length,
                      itemBuilder: (context, index) {
                        final note = widget.noteList[index];
                        if (note.containsKey('note') &&
                            note['note'] != null &&
                            note['note'].isNotEmpty) {
                          return Container(
                            padding: const EdgeInsets.all(8.0),
                            margin: const EdgeInsets.only(bottom: .0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: Colors.grey[50],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (note.containsKey('timestamp') &&
                                    note['timestamp'] != null)
                                  Text(
                                    'Note ${index + 1} - ${note['timestamp']}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                const SizedBox(height: 4),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      note['note'],
                                      style: TextStyle(fontSize: 13),
                                      textAlign: TextAlign.justify,
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.redAccent,
                                      ),
                                      tooltip: 'Delete this history',
                                      onPressed: () async {
                                        final note = widget.noteList[0];
                                        print(
                                          'tentando excluit a note com id ${note['id']}',
                                        );
                                        await DatabaseHelper().deleteNote(
                                          note['id'],
                                        );
                                        widget.onNoteDeleted(widget.book);
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        } else {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox.shrink(),
                              IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.redAccent,
                                ),
                                tooltip: 'Delete this history',
                                onPressed: () async {
                                  final note = widget.noteList[0];
                                  print(
                                    'tentando excluit a note com id ${note['id']}',
                                  );
                                  await DatabaseHelper().deleteNote(note['id']);
                                  widget.onNoteDeleted(widget.book);
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
          ],
        ),
      ),
    );
  }
}
