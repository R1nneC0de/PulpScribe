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

    return snapshot.docs.map((doc) {
      final data = doc.data();
      data['docId'] = doc.id; 
      return data;
    }).toList();
  }

  Future<void> updateBookStatus(String docId, String newStatus) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('readingList')
        .doc(docId)
        .update({'status': newStatus});

    setState(() {}); 
  }

  Future<void> removeBook(String docId) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('readingList')
        .doc(docId)
        .delete();

    setState(() {}); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDE7F6), // Lavender background
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
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(book['author'] ?? 'Unknown Author'),
                              const SizedBox(height: 4),
                              Text(
                                "Status: ${book['status']}",
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                          trailing: PopupMenuButton<String>(
                            icon: const Icon(Icons.more_vert),
                            onSelected: (value) {
                              if (value == 'Delete') {
                                removeBook(book['docId']);
                              } else {
                                updateBookStatus(book['docId'], value);
                              }
                            },
                            itemBuilder:
                                (context) => [
                                  const PopupMenuItem(
                                    value: 'Want to Read',
                                    child: Text('Mark as Want to Read'),
                                  ),
                                  const PopupMenuItem(
                                    value: 'Currently Reading',
                                    child: Text('Mark as Currently Reading'),
                                  ),
                                  const PopupMenuItem(
                                    value: 'Finished',
                                    child: Text('Mark as Finished'),
                                  ),
                                  const PopupMenuItem(
                                    value: 'Delete',
                                    child: Text('Delete'),
                                  ),
                                ],
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