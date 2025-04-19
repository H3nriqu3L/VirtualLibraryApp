import 'package:flutter/material.dart';

class Header extends StatefulWidget {
  const Header({super.key});

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(Icons.dashboard, size: 30, color: Colors.black),
          Row(
            children: [
              Icon(Icons.search),
              SizedBox(width: 10),
              Icon(Icons.notifications),
            ],
          ),
        ],
      ),
    );
  }
}
