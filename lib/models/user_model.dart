class UserModel {
  final String uid;
  final String email;
  final List<String> genres;

  UserModel({required this.uid, required this.email, required this.genres});

  Map<String, dynamic> toMap() {
    return {'uid': uid, 'email': email, 'genres': genres};
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      genres: List<String>.from(map['genres'] ?? []),
    );
  }
}
