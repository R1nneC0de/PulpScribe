import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/review_model.dart';
import '../services/firestore_service.dart';

class ReviewScreen extends StatefulWidget {
  final String bookId;
  const ReviewScreen({super.key, required this.bookId});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  final TextEditingController _reviewController = TextEditingController();
  final FirestoreService _firestore = FirestoreService();
  final _auth = FirebaseAuth.instance;
  int _rating = 0;

  void submitReview() async {
    final user = _auth.currentUser;
    final reviewText = _reviewController.text.trim();

    if (user != null && _rating > 0 && reviewText.isNotEmpty) {
      final review = Review(
        userId: user.uid,
        bookId: widget.bookId,
        review: reviewText,
        rating: _rating,
      );

      await _firestore.submitReview(review);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Review submitted!")));

      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please complete all fields.")),
      );
    }
  }

  Widget buildStarRating() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return IconButton(
          icon: Icon(
            index < _rating ? Icons.star : Icons.star_border,
            color: Colors.amber,
            size: 32,
          ),
          onPressed: () {
            setState(() => _rating = index + 1);
          },
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDE7F6), 
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text('Write a Review'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Your Rating",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 12),
            buildStarRating(),
            const SizedBox(height: 24),

            const Text(
              "Your Review",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),

            TextField(
              controller: _reviewController,
              maxLines: 6,
              decoration: InputDecoration(
                hintText: 'Write something about the book...',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 32),

            ElevatedButton.icon(
              onPressed: submitReview,
              icon: const Icon(Icons.send),
              label: const Text(
                "Submit Review",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white, 
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
