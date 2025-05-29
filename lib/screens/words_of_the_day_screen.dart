import 'package:flutter/material.dart';

class WordsOfTheDayScreen extends StatelessWidget {
  const WordsOfTheDayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final words = [
      'Motivation',
      'Productivity',
      'Innovation',
      'Collaboration',
      'Success',
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Günün Kelimeleri')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: words.length,
        itemBuilder:
            (context, i) => Card(child: ListTile(title: Text(words[i]))),
      ),
    );
  }
}
