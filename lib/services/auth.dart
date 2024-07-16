// import 'package:hive/hive.dart';

// class Auth {
//   static final Auth _instance = Auth._internal();
//   factory Auth() => _instance;
//   Auth._internal();

//   final String _userBoxName = 'users';
//   final String _currentUserKey = 'currentUser';

//   Future<Box> _openUserBox() async {
//     return await Hive.openBox(_userBoxName);
//   }

//   Future<Map<String, dynamic>?> get currentUser async {
//     final userBox = await _openUserBox();
//     return userBox.get(_currentUserKey);
//   }

//   Future<void> register(String username, String email, String password) async {
//     final userBox = await _openUserBox();
//     final newUser = {
//       'username': username,
//       'email': email,
//       'password': password,
//     };
//     await userBox.put(email, newUser);
//   }

//   Future<void> login(String email, String password) async {
//     final userBox = await _openUserBox();
//     final user = userBox.get(email);
//     if (user != null && user['password'] == password) {
//       await userBox.put(_currentUserKey, user);
//     } else {
//       throw Exception('Invalid email or password');
//     }
//   }

//   Future<void> logout() async {
//     final userBox = await _openUserBox();
//     await userBox.delete(_currentUserKey);
//   }

//   Future<void> updateProfile(String username, String email) async {
//     final userBox = await _openUserBox();
//     final currentUser = await this.currentUser;
//     if (currentUser != null) {
//       currentUser['username'] = username;
//       currentUser['email'] = email;
//       await userBox.put(currentUser['email'], currentUser);
//       await userBox.put(_currentUserKey, currentUser);
//     } else {
//       throw Exception('No user logged in');
//     }
//   }
// }
