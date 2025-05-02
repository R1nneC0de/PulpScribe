import 'package:flutter/material.dart';
import '../models/book_model.dart';
import '../services/book_api_service.dart';
import '../widgets/book_card.dart';
import 'book_detail_screen.dart';
import 'search_screen.dart';
import 'profile_screen.dart';
import 'reading_list_screen.dart';
import 'discussion_board_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final BookApiService _bookService = BookApiService();
  List<Book> _books = [];

  @override
  void initState() {
    super.initState();
    fetchRecommendations();
  }

  void fetchRecommendations() async {
    final books = await _bookService.searchBooks('top rated books');
    setState(() => _books = books);
  }

  void openDrawer() {
    Scaffold.of(context).openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDE7F6), // lavender background
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text("Home"),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.deepPurple),
              child: Text(
                'Book AI Menu',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.search),
              title: const Text('Search Books'),
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SearchScreen()),
                  ),
            ),
            ListTile(
              leading: const Icon(Icons.bookmark),
              title: const Text('Reading List'),
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ReadingListScreen(),
                    ),
                  ),
            ),
            ListTile(
              leading: const Icon(Icons.forum),
              title: const Text('Discussion Board'),
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const DiscussionBoardScreen(),
                    ),
                  ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ProfileScreen()),
                  ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Personalized Recommendations",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child:
                  _books.isEmpty
                      ? const Center(child: CircularProgressIndicator())
                      : ListView.builder(
                        itemCount: _books.length,
                        itemBuilder: (context, index) {
                          final book = _books[index];
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