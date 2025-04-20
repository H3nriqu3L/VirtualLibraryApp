import 'package:flutter/material.dart';
import 'package:book_app/models/note.dart';
import 'package:book_app/widgets/add_note_widget.dart';

class MyFloatingButtonNote extends StatelessWidget {
  final int id;
  const MyFloatingButtonNote({super.key, required this.id});

  @override
   Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        margin: const EdgeInsets.only(bottom: 16.0),
        child: FloatingActionButton.extended(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              builder: (context) => AddNoteSheet(id:id),
            );
          },
          isExtended: true,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          label: const Text('Add Note', style: TextStyle(color: Colors.black)),
          icon: const Icon(Icons.add, color: Colors.black),
          backgroundColor: Colors.blue,
        ),
      ),
    );
  }
}