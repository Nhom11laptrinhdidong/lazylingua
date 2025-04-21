import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewModel/bookmark.dart';
import '../viewModel/steak_manager.dart';

class SplashViewModel extends ChangeNotifier {
  Future<void> checkLogin(BuildContext context) async {
    await Future.delayed(Duration(seconds: 2)); // Hiệu ứng splash

    final user = FirebaseAuth.instance.currentUser;

    if (user != null && !user.isAnonymous) {
      // Đăng nhập rồi, load dữ liệu nếu cần
      await context.read<BookmarkManager>().loadFromFirebase();
      await context.read<StreakManager>().loadStreakFromFirestore();
      Navigator.pushReplacementNamed(context, '/dictionary');
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }
}
