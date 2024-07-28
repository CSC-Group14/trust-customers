import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String id;
  String name;
  String email;
  String phoneNumber;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
  });

  // Converts a User instance to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
    };
  }

  // Creates a User instance from a map
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
    );
  }
}

class UserRepository {
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  // Creates a new user in Firestore
  Future<void> createUser(User user) async {
    try {
      await usersCollection.doc(user.id).set(user.toMap());
    } catch (e) {
      print('Error creating user: $e');
    }
  }

  // Retrieves a user from Firestore by ID
  Future<User?> getUser(String id) async {
    try {
      DocumentSnapshot doc = await usersCollection.doc(id).get();
      if (doc.exists) {
        return User.fromMap(doc.data() as Map<String, dynamic>);
      }
    } catch (e) {
      print('Error getting user: $e');
    }
    return null;
  }
}
