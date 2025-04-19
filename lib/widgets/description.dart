import 'package:flutter/material.dart';
import 'package:book_app/models/book.dart';

class DescriptionWidget extends StatefulWidget {
  final Book book;
  const DescriptionWidget({required this.book});

  @override
  DescriptionWidgetState createState() => DescriptionWidgetState();
}

class DescriptionWidgetState extends State<DescriptionWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final description = widget.book.description;
    final shortDescription =
        description.length > 100
            ? description.substring(0, 130) + '...'
            : description;

    return Container(
      margin: EdgeInsets.fromLTRB(20, 8, 16, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Description: ',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          Text(
            _isExpanded ? description : shortDescription,
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.justify,
          ),
          SizedBox(height: 10),
          GestureDetector(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _isExpanded ? 'Show less' : 'Show more',
                  style: TextStyle(color: Colors.blue[900], fontSize: 16),
                ),
                SizedBox(width: 4),
                Icon(
                  _isExpanded ? Icons.expand_less : Icons.expand_more,
                  color: Colors.blue[900],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
