import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/review_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Submit a review to Firestore
  Future<void> submitReview(Review review) async {
    print('Submitting review for bookId: ${review.bookId}');
    await _db.collection('reviews').add({
      'userId': review.userId,
      'bookId': review.bookId,
      'review': review.review,
      'rating': review.rating,
      'timestamp': FieldValue.serverTimestamp(), 
    });
  }

  /// Get all reviews for a specific book
  Stream<List<Review>> getReviewsForBook(String bookId) {
    return _db
        .collection('reviews')
        .where('bookId', isEqualTo: bookId)
        .orderBy('rating', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Review.fromMap(doc.data())).toList(),
        );
  }

  /// Get reviews submitted by a specific user (optional feature)
  Stream<List<Review>> getReviewsByUser(String userId) {
    return _db
        .collection('reviews')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Review.fromMap(doc.data())).toList(),
        );
  }
}
