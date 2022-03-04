import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../utils/user_preferences.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;

  AuthenticationService(this._firebaseAuth);

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<String> signIn({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return "Signed In Successfully";
    } on FirebaseAuthException catch (e) {
      return "${e.message}";
    }
  }

  Future<String> signUp({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return "Account created successfully";
    } on FirebaseAuthException catch (e) {
      return "${e.message}";
    }
  }

  Future<String> signOut() async {
    try {
      await _firebaseAuth.signOut();
      await UserPreferences.clearPreferences();
      return "Signed out";
    } on FirebaseAuthException catch (e) {
      return "${e.message}";
    }
  }

  Future<void> saveTokenToDatabase(String token) async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .update({'tokens': token});
  }

  User? getUser() {
    try {
      return _firebaseAuth.currentUser;
    } on FirebaseAuthException {
      return null;
    }
  }
}
