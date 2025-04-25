import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReadingListScreen extends StatefulWidget {
  const ReadingListScreen({super.key});

  @override
  State<ReadingListScreen> createState() => _ReadingListScreenState();
}

class _ReadingListScreenState extends State<ReadingListScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String selectedTab = 'Want to Read';

  final List<String> tabs = ['Want to Read', 'Currently Reading', 'Finished'];

  Future<List<Map<String, dynamic>>> fetchBooks(String category) async {
    final user = _auth.currentUser;
    if (user == null) return [];

    final snapshot =
        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('readingList')
            .where('status', isEqualTo: category)
            .get();

    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<void> removeBook(String bookId) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final ref = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('readingList');

    final snapshot = await ref.where('id', isEqualTo: bookId).get();

    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }

    setState(() {}); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDE7F6), 
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text("Your Reading List"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ToggleButtons(
              isSelected: tabs.map((tab) => tab == selectedTab).toList(),
              onPressed: (index) {
                setState(() => selectedTab = tabs[index]);
              },
              borderRadius: BorderRadius.circular(12),
              selectedColor: Colors.white,
              fillColor: Colors.deepPurple,
              color: Colors.deepPurple,
              children:
                  tabs
                      .map(
                        (label) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(label),
                        ),
                      )
                      .toList(),
            ),
            const SizedBox(height: 16),

            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: fetchBooks(selectedTab),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final books = snapshot.data!;
                  if (books.isEmpty) {
                    return const Center(child: Text("No books here yet."));
                  }

                  return ListView.builder(
                    itemCount: books.length,
                    itemBuilder: (context, index) {
                      final book = books[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          leading:
                              book['thumbnail'] != null
                                  ? Image.network(
                                    book['thumbnail'],
                                    width: 50,
                                    fit: BoxFit.cover,
                                  )
                                  : const Icon(Icons.book, size: 50),
                          title: Text(book['title'] ?? 'No Title'),
                          subtitle: Text(book['author'] ?? 'Unknown Author'),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.redAccent,
                            ),
                            onPressed: () => removeBook(book['id']),
                          ),
                        ),
                      );
                    },
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
