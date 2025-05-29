import 'package:flutter/material.dart';

class LessonsScreen extends StatelessWidget {
  const LessonsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dersler')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          ListTile(title: Text('Ders 1: Flutter Giriş')),
          ListTile(title: Text('Ders 2: Firebase Authentication')),
          ListTile(title: Text('Ders 3: Firestore Kullanımı')),
          ListTile(title: Text('Ders 4: State Management')),
        ],
      ),
    );
  }
}
