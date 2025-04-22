import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../UI/FlashCard.dart';
import '../UI/Quiz.dart';
import '../UI/chat_page.dart';
import '../UI/User.dart';
import '../viewModel/bookmark.dart';
import '../UI/dictionary_screen.dart';
import '../viewModel/home_view_model.dart';
import '../viewModel/streak_manager.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  int _selectedIndex = 0;
  StreakManager streakManager = StreakManager();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Future<void> dispose() async {
    WidgetsBinding.instance.removeObserver(this);
    final bookmarkManager =
    Provider.of<BookmarkManager>(context, listen: false);
    bookmarkManager.saveToFirebase(FirebaseAuth.instance.currentUser!.uid);
    await streakManager.saveStreakToFirestore();
    super.dispose();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      final bookmarkManager =
      Provider.of<BookmarkManager>(context, listen: false);
      bookmarkManager.saveToFirebase(FirebaseAuth.instance.currentUser!.uid);
      await streakManager.saveStreakToFirestore();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeViewModel(),
      child: Consumer<HomeViewModel>(
        builder: (context, model, _) {
          if (model.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (model.error != null) {
            return const Scaffold(
                body: Center(child: Text('Lỗi khi tải dữ liệu')));
          } else {
            final words = model.words;
            final _widgetOptions = [
              DictionaryScreen(words: words),
              FlashCardScreen(words: words),
              QuizScreen(words: words),
              const ChatPage(),
              ProfileScreen(user: FirebaseAuth.instance.currentUser),
            ];

            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                titleSpacing: 50,
                title: Image.asset(
                  "assets/images/logocuak.png",
                  width: 400,
                  height: 65,
                ),
                flexibleSpace: Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/nen.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              body: IndexedStack(
                index: _selectedIndex,
                children: _widgetOptions,
              ),
              bottomNavigationBar: BottomNavigationBar(
                iconSize: 30,
                backgroundColor: Colors.white,
                type: BottomNavigationBarType.fixed,
                selectedItemColor: Colors.blue,
                unselectedItemColor: Colors.black,
                currentIndex: _selectedIndex,
                onTap: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(Icons.menu_book),
                    label: 'Dictionary',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.flash_on),
                    label: 'Flash Card',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.quiz),
                    label: 'Quiz',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.android),
                    label: 'ChatBot',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person),
                    label: 'User',
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
