import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController _genreController = TextEditingController();
  List<String> _genres = [];

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  void loadUserData() async {
    final user = _auth.currentUser;
    if (user != null) {
      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists) {
        final data = doc.data()!;
        setState(() {
          _genres = List<String>.from(data['genres'] ?? []);
        });
      }
    }
  }

  void saveGenres() async {
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).set(
        {'email': user.email, 'genres': _genres},
        SetOptions(merge: true),
      ); // 🔥 Fix: Merge instead of overwrite entire document

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Genres updated!')));
    }
  }

  void addGenre() {
    final genre = _genreController.text.trim();
    if (genre.isNotEmpty && !_genres.contains(genre)) {
      setState(() {
        _genres.add(genre);
        _genreController.clear();
      });
    }
  }

  void removeGenre(String genre) {
    setState(() => _genres.remove(genre));
  }

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFEDE7F6),
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text('Profile'),
      ),
      body:
          user == null
              ? const Center(child: Text("No user found"))
              : SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.deepPurple,
                      child: Icon(Icons.person, size: 60, color: Colors.white),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      user.email ?? '',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 32),
                    const Text(
                      "Favorite Genres",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      children:
                          _genres.map((genre) {
                            return Chip(
                              label: Text(genre),
                              backgroundColor: Colors.deepPurple.shade100,
                              deleteIcon: const Icon(Icons.close),
                              onDeleted: () => removeGenre(genre),
                            );
                          }).toList(),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _genreController,
                            decoration: InputDecoration(
                              hintText: 'Add a genre',
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: addGenre,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text("Add"),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: saveGenres,
                      icon: const Icon(Icons.save),
                      label: const Text(
                        "Save Changes",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
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
