import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'screens/home_screen.dart';
import 'screens/courses_screen.dart';
import 'screens/homework_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/lessons_screen.dart';
import 'screens/words_of_the_day_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/ai_chat_screen.dart';
import 'games/game_menu_screen.dart';
import 'games/game1_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Firebase Login',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const AuthOrHome(),
        '/home': (context) => const HomeScreen(),
        '/courses': (context) => const CoursesScreen(),
        '/homework': (context) => const HomeworkScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/ai_chat': (context) => const AiChatScreen(),
        '/lessons': (context) => const LessonsScreen(),
        '/words': (context) => const WordsOfTheDayScreen(),
        '/register': (context) => const RegisterScreen(),
        '/game': (context) => const GameMenuScreen(),
        '/game1': (context) => const Game1Screen(),
        '/login': (context) => const LoginScreen(),
      },
      debugShowCheckedModeBanner: false, // <-- Debug yazısını kaldır
    );
  }
}

class AuthOrHome extends StatelessWidget {
  const AuthOrHome({super.key});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError) {
          return Scaffold(body: Center(child: Text('Hata: ${snapshot.error}')));
        }
        if (snapshot.hasData) {
          return const HomeScreen();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}
