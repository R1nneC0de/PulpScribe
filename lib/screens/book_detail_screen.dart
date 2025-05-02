import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/book_model.dart';
import '../models/review_model.dart';
import '../services/firestore_service.dart';
import 'review_screen.dart';
import '../widgets/review_tile.dart';

class BookDetailScreen extends StatefulWidget {
  final Book book;
  const BookDetailScreen({super.key, required this.book});

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  final FirestoreService _firestore = FirestoreService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  void addToReadingList() async {
    final user = _auth.currentUser;
    if (user != null) {
      final bookData = {
        'id': widget.book.id,
        'title': widget.book.title,
        'author': widget.book.author,
        'thumbnail': widget.book.thumbnail,
        'status': 'Want to Read', // Default status when added
      };

      await _db
          .collection('users')
          .doc(user.uid)
          .collection('readingList')
          .add(bookData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Book added to your reading list!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDE7F6),
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text("Book Details"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child:
                  widget.book.thumbnail.isNotEmpty
                      ? Image.network(widget.book.thumbnail, height: 200)
                      : const Icon(Icons.book, size: 100),
            ),
            const SizedBox(height: 20),
            Text(
              widget.book.title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              "by ${widget.book.author}",
              style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: addToReadingList,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text("Add to Reading List"),
            ),
            const SizedBox(height: 24),
            const Text(
              "Summary",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "This is a placeholder summary. You can use the OpenAI API to generate real summaries here.",
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Reviews",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.add_comment_rounded,
                    color: Colors.deepPurple,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ReviewScreen(bookId: widget.book.id),
                      ),
                    );
                  },
                ),
              ],
            ),
            StreamBuilder<List<Review>>(
              stream: _firestore.getReviewsForBook(widget.book.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final reviews = snapshot.data ?? [];
                if (reviews.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Text("No reviews yet."),
                  );
                }
                return Column(
                  children: reviews.map((r) => ReviewTile(review: r)).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
