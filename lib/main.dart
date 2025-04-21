import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lazylingua/viewModel/quiz_view_model.dart';
import 'package:lazylingua/viewModel/splash_view_model.dart';
import 'package:lazylingua/viewModel/translate_view_model.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'viewModel/bookmark.dart';
import 'viewModel/steak_manager.dart';
import 'viewModel/chat_view_model.dart';
import 'viewModel/chat_service.dart';

import 'UI/LoadingScreen.dart';
import 'UI/login_screen.dart';
import 'UI/register_screen.dart';
import 'UI/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => BookmarkManager()..loadBookmarks(),
        ),
        ChangeNotifierProvider(
          create: (_) => StreakManager()..loadStreak(),
        ),
        ChangeNotifierProvider(
          create: (_) => ChatViewModel(
            chatService: ChatService("AIzaSyDMMj0WhdkG7UZ2E26SZHVfJ6edylwtBB8"),
          ),
        ),
        ChangeNotifierProvider(create: (_) => TranslateViewModel()),
        ChangeNotifierProvider(create: (_) => SplashViewModel()),
        ChangeNotifierProvider(create: (_) => QuizViewModel(<dynamic>[])),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/home': (context) => LoginScreen(),
        '/dictionary': (context) => HomePage(),
        '/register': (context) => RegisterScreen(),
        '/login': (context) => LoginScreen(),
      },
    );
  }
}
