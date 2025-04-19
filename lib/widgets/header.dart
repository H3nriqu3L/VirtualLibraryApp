import 'package:flutter/material.dart';

class Header extends StatefulWidget {
  const Header({super.key});

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  bool isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(Icons.dashboard, size: 30, color: Colors.black),
          Row(
            children: [
              isSearching
                  ? Container(
                    width: 200,
                    height: 50,
                    child: TextField(
                      controller: _searchController,
                      autofocus: true,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 10),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        hintText: 'Search...',
                        border: OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () {
                            setState(() {
                              isSearching = false;
                              _searchController.clear();
                            });
                          },
                        ),
                      ),
                      onSubmitted: (query) {
                        if (ModalRoute.of(context)?.settings.name ==
                            '/search') {
                          Navigator.pushReplacementNamed(
                            context,
                            '/search',
                            arguments: query,
                          );
                        } else {
                          Navigator.pushNamed(
                            context,
                            '/search',
                            arguments: query,
                          );
                        }
                      },
                    ),
                  )
                  : IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      setState(() {
                        isSearching = true;
                      });
                    },
                  ),
              SizedBox(width: 10),
              Icon(Icons.notifications),
            ],
          ),
        ],
      ),
    );
  }
}
