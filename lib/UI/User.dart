import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import '../viewModel/bookmark.dart';
import '../viewModel/streak_manager.dart';

class ProfileScreen extends StatelessWidget {
  final User? user;
  ProfileScreen({required this.user});

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return Scaffold(
        body: Center(
          child: Text("No user signed in"),
        ),
      );
    }
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/nen.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            flexibleSpace: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                height: kToolbarHeight,
                margin: EdgeInsets.only(bottom: 4),
                decoration: BoxDecoration(
                  color: Colors.blue[300],
                  borderRadius: BorderRadius.circular(20),
                ),
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 16),
                child: Text(
                  "User Profile",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            // Remove the title since we're using flexibleSpace
            title: null,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/anhbautroi.png'), // Replace with your outer background image path
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: Container(
                    width: double.infinity,
                    height: 400, // Taller frame - adjust as needed
                    margin: EdgeInsets.symmetric(horizontal: 24),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/nen4.png'), // Replace with your frame background image
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 5,
                          blurRadius: 15,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          // Avatar (ảnh đại diện)
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(user?.photoURL ?? 'https://www.gravatar.com/avatar/?d=mp'),
                          ),
                          SizedBox(height: 16),

                          // Tên người dùng
                          Text(
                            "${user?.displayName ?? 'N/A'}",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white, // Consider light text color for better visibility on image background
                            ),
                          ),
                          SizedBox(height: 8),

                          // Email người dùng
                          Text(
                            "${user?.email ?? 'N/A'}",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white, // Light text for better visibility
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Nút đăng xuất
              Padding(
                padding: EdgeInsets.only(bottom: 24),
                child: ElevatedButton(
                  onPressed: () async {
                    final bookmarkManager = Provider.of<BookmarkManager>(context, listen: false);
                    await bookmarkManager.saveToFirebase(FirebaseAuth.instance.currentUser!.uid);
                    await bookmarkManager.clearBookmarks();
                    StreakManager streakManager = StreakManager();
                    await streakManager.saveStreakToFirestore();
                    await streakManager.resetStreak();
                    await FirebaseAuth.instance.signOut();
                    Navigator.pushReplacementNamed(context, '/home');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade400,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Text("Sign Out", style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
