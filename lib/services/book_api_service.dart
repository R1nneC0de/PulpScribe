import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/book_model.dart';

class BookApiService {
  static const String _baseUrl =
      "https://www.googleapis.com/books/v1/volumes?q=";

  Future<List<Book>> searchBooks(String query) async {
    final url = Uri.parse('$_baseUrl$query');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final items = data['items'] as List<dynamic>?;

      if (items == null) return [];

      return items.map((item) => Book.fromJson(item)).toList();
    } else {
      throw Exception("Failed to load books: ${response.statusCode}");
    }
  }
}
