import 'package:book_app/widgets/header.dart';
import 'package:flutter/material.dart';
import 'package:book_app/utils/book.dart';

class SearchingPage extends StatefulWidget {
  const SearchingPage({super.key});

  @override
  State<SearchingPage> createState() => _SearchingPageState();
}

class _SearchingPageState extends State<SearchingPage> {
  List<Book> books = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Recupera o valor do 'query' que foi passado via argumentos
    final String query = ModalRoute.of(context)?.settings.arguments as String;
    _searchController.text =
        query; // Atualiza o controlador com o valor passado
    searchBook(query); // Chama a função para buscar os livros com o 'query'
  }

  void searchBook(String query) async {
    try {
      List<Book> fetchedBooks = await fetchBooks(query);
      setState(() {
        books = fetchedBooks;
      });
    } catch (e) {
      print('Erro ao buscar livros: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: SafeArea(child: Header()),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(20, 16, 16, 10),
                child: Text('Searched Books', style: TextStyle(fontSize: 30)),
              ),
            ],
          ),
          Divider(color: Colors.black, thickness: 2.0),
          SizedBox(height: 15),
          //Shows Books Found
          //Expanded(),
        ],
      ),
    );
  }
}
