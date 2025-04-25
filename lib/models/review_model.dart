class Review {
  final String userId;
  final String bookId;
  final String review;
  final int rating;

  Review({
    required this.userId,
    required this.bookId,
    required this.review,
    required this.rating,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'bookId': bookId,
      'review': review,
      'rating': rating,
    };
  }

  factory Review.fromMap(Map<String, dynamic> map) {
    return Review(
      userId: map['userId'],
      bookId: map['bookId'],
      review: map['review'],
      rating: map['rating'],
    );
  }
}
