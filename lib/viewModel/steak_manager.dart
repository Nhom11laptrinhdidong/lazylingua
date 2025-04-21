import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StreakManager extends ChangeNotifier{
  int currentStreak = 0;
  int highestStreak = 0;

  /// Load streak từ local SharedPreferences
  Future<void> loadStreak() async {
    final prefs = await SharedPreferences.getInstance();
    highestStreak = prefs.getInt('highestStreak') ?? 0;
    currentStreak = prefs.getInt('currentStreak') ?? 0;
    notifyListeners();
  }

  /// Lưu highest streak vào SharedPreferences
  Future<void> saveCurrentStreak(int streak) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('currentStreak', streak);
    notifyListeners();
  }

  /// Lưu current streak vào SharedPreferences
  Future<void> saveHighestStreak(int streak) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('highestStreak', streak);
    notifyListeners();
  }

  /// Lưu streak (highest + current) lên Firestore
  Future<void> saveStreakToFirestore() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final prefs = await SharedPreferences.getInstance();
    final localHighestStreak = prefs.getInt('highestStreak') ?? 0;
    final localCurrentStreak = prefs.getInt('currentStreak') ?? 0;

    final docRef = FirebaseFirestore.instance.collection('streak').doc(uid);

    await docRef.set({
      'highestStreak': localHighestStreak,
      'currentStreak': localCurrentStreak,
    }, SetOptions(merge: true));
    notifyListeners();
  }

  /// Tải streak từ Firestore và cập nhật local
  Future<void> loadStreakFromFirestore() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final docRef = FirebaseFirestore.instance.collection('streak').doc(uid);
    final snapshot = await docRef.get();

    if (snapshot.exists) {
      final data = snapshot.data();
      if (data != null) {
        currentStreak = data['currentStreak'] ?? 0;
        highestStreak = data['highestStreak'] ?? 0;

        // Đồng bộ xuống local SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('currentStreak', currentStreak);
        await prefs.setInt('highestStreak', highestStreak);
        notifyListeners();
      }
    }
  }
}
