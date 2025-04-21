import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';


class BookmarkManager extends ChangeNotifier {
  List<Map<String, dynamic>> _bookmarkedWords = [];

  List<Map<String, dynamic>> get bookmarkedWords => _bookmarkedWords;

  Future<void> loadBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString('bookmarks');
    if (data != null) {
      List<dynamic> jsonList = jsonDecode(data);
      _bookmarkedWords = List<Map<String, dynamic>>.from(jsonList);
      notifyListeners();
    }
  }

  Future<void> toggleBookmark(Map<String, dynamic> word) async {
    bool exists = _bookmarkedWords.any((w) => w['word'] == word['word']);
    if (exists) {
      _bookmarkedWords.removeWhere((w) => w['word'] == word['word']);
    } else {
      _bookmarkedWords.add(word);
    }
    notifyListeners();
    await _saveToStorage();
  }

  bool isBookmarked(String word) {
    return _bookmarkedWords.any((w) => w['word'] == word);
  }

  Future<void> _saveToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    String data = jsonEncode(_bookmarkedWords);
    await prefs.setString('bookmarks', data);
  }

  Future<void> saveToFirebase(String uid) async {
    try {
      final firestore = FirebaseFirestore.instance;
    await firestore.collection('bookmarks').doc(uid).set({
      'words': _bookmarkedWords,
    });
      print("Bookmarks đã được lưu lên Firebase");
    } catch (e) {
      print("Lỗi khi lưu bookmark: $e");
    }
  }

  Future<void> loadFromFirebase() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final doc = await FirebaseFirestore.instance
        .collection('bookmarks')
        .doc(user.uid)
        .get();

    if (doc.exists) {
      final data = doc.data();
      if (data != null && data['words'] != null) {
        List<dynamic> jsonList = data['words'];
        _bookmarkedWords = List<Map<String, dynamic>>.from(jsonList);
        notifyListeners();
      }
    }
  }
}
