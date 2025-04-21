import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lazylingua/viewModel/steak_manager.dart';
import 'package:provider/provider.dart';

import 'bookmark.dart';

class LoginViewModel {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> loginWithEmail({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đăng nhập thành công!')),
      );
      await context.read<BookmarkManager>().loadFromFirebase();
      await context.read<StreakManager>().loadStreakFromFirestore();
      Navigator.pushReplacementNamed(context, '/dictionary');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: $e')),
      );
    }
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);
      await context.read<BookmarkManager>().loadFromFirebase();
      await context.read<StreakManager>().loadStreakFromFirestore();
      Navigator.pushReplacementNamed(context, '/dictionary');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Google Sign-In failed: $e')),
      );
    }
  }

  void signInAsGuest(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/dictionary');
  }

  void goToRegister(BuildContext context) {
    Navigator.pushNamed(context, '/register');
  }
}
