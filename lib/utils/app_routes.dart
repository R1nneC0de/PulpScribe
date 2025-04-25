import 'package:flutter/material.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/home_screen.dart';
import '../screens/search_screen.dart';
import '../screens/book_detail_screen.dart';
import '../screens/review_screen.dart';
import '../screens/reading_list_screen.dart';
import '../screens/discussion_board_screen.dart';
import '../screens/profile_screen.dart';
import '../models/book_model.dart';

class AppRoutes {
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String search = '/search';
  static const String bookDetail = '/bookDetail';
  static const String review = '/review';
  static const String readingList = '/readingList';
  static const String discussion = '/discussion';
  static const String profile = '/profile';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case search:
        return MaterialPageRoute(builder: (_) => const SearchScreen());
      case bookDetail:
        final book = settings.arguments as Book;
        return MaterialPageRoute(builder: (_) => BookDetailScreen(book: book));
      case review:
        final bookId = settings.arguments as String;
        return MaterialPageRoute(builder: (_) => ReviewScreen(bookId: bookId));
      case readingList:
        return MaterialPageRoute(builder: (_) => const ReadingListScreen());
      case discussion:
        return MaterialPageRoute(builder: (_) => const DiscussionBoardScreen());
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      default:
        return MaterialPageRoute(
          builder:
              (_) =>
                  const Scaffold(body: Center(child: Text("No route found"))),
        );
    }
  }
}
