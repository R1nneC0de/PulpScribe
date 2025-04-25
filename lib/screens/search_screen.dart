import 'package:flutter/material.dart';
import '../models/book_model.dart';
import '../services/book_api_service.dart';
import '../widgets/book_card.dart';
import 'book_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final BookApiService _bookService = BookApiService();
  List<Book> _results = [];
  String selectedCategory = "All";

  final List<String> categories = [
    "Want to Read",
    "Currently Reading",
    "Finished",
  ];

  void searchBooks() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;

    final books = await _bookService.searchBooks(query);
    setState(() => _results = books);
  }

  void selectCategory(String label) {
    setState(() {
      selectedCategory = label;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDE7F6), 
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text("Search Books"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              onSubmitted: (_) => searchBooks(),
              decoration: InputDecoration(
                hintText: 'Search by title or author',
                filled: true,
                fillColor: Colors.white,
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: searchBooks,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),

            SizedBox(
              height: 36,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final cat = categories[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(cat),
                      selected: selectedCategory == cat,
                      onSelected: (_) => selectCategory(cat),
                      selectedColor: Colors.deepPurple,
                      backgroundColor: Colors.deepPurple.shade100,
                      labelStyle: TextStyle(
                        color:
                            selectedCategory == cat
                                ? Colors.white
                                : Colors.deepPurple,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            Expanded(
              child:
                  _results.isEmpty
                      ? const Center(child: Text("No results. Try searching!"))
                      : ListView.builder(
                        itemCount: _results.length,
                        itemBuilder: (context, index) {
                          final book = _results[index];
                          return GestureDetector(
                            onTap:
                                () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) => BookDetailScreen(book: book),
                                  ),
                                ),
                            child: BookCard(book: book),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
