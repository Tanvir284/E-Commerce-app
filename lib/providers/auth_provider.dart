import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthProvider() {
    _auth.authStateChanges().listen((u) {
      _user = u;
      notifyListeners();
    });
  }

  User? get user => _user;
  bool get isAuthenticated => _user != null;

  Future<void> signInAnonymously() async {
    await _auth.signInAnonymously();
  }

  Future<void> signInWithEmail(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signUpWithEmail(String email, String password) async {
    await _auth.createUserWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signInWithGoogle() async {
    try {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return; // user aborted

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);
    } catch (e) {
      if (kDebugMode) print('Google sign-in failed: $e');
      rethrow;
    }
  }

  // Placeholder for Apple Sign-In (requires platform setup)
  Future<void> signInWithApple() async {
    throw UnimplementedError('Apple Sign-In not configured. Follow README to set up.');
  }

  Future<void> signOut() async {
    await _auth.signOut();
    // also sign out from Google to avoid silent sign-in
    try {
      await GoogleSignIn().signOut();
    } catch (_) {}
  }
}