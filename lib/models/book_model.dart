class Book {
  final String id;
  final String title;
  final String author;
  final String thumbnail;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.thumbnail,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    final volumeInfo = json['volumeInfo'] ?? {};
    final imageLinks = volumeInfo['imageLinks'] ?? {};

    return Book(
      id: json['id'] ?? '',
      title: volumeInfo['title'] ?? 'No Title',
      author:
          (volumeInfo['authors'] as List<dynamic>?)?.join(', ') ??
          'Unknown Author',
      thumbnail: imageLinks['thumbnail'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'title': title, 'author': author, 'thumbnail': thumbnail};
  }

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'],
      title: map['title'],
      author: map['author'],
      thumbnail: map['thumbnail'],
    );
  }
}
