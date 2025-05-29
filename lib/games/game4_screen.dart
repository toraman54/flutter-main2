import 'dart:async';

import 'package:flutter/material.dart';

class Game4Screen extends StatefulWidget {
  const Game4Screen({super.key});

  @override
  State<Game4Screen> createState() => _Game4ScreenState();
}

class _Game4ScreenState extends State<Game4Screen> {
  // Kelimeler seviye bazlı gruplandı
  final Map<String, List<String>> _wordsByLevel = {
    'easy': [
      'apple',
      'banana',
      'dog',
      'cat',
      'house',
      'car',
      'book',
      'table',
      'chair',
      'water',
      'sun',
      'tree',
      'milk',
      'door',
      'phone',
    ],
    'medium': [
      'computer',
      'developer',
      'keyboard',
      'monitor',
      'internet',
      'language',
      'programming',
      'coffee',
      'window',
      'garden',
      'library',
      'picture',
      'notebook',
      'pencil',
      'light',
      'teacher',
      'school',
      'movie',
      'camera',
    ],
    'hard': [
      'application',
      'architecture',
      'microcontroller',
      'responsibility',
      'comprehensive',
      'philosophy',
      'psychology',
      'environment',
      'algorithm',
      'optimization',
      'sophisticated',
      'entrepreneurship',
      'hypothesis',
      'exaggeration',
      'circumstance',
      'unfortunately',
    ],
  };

  late List<String> _allWords;
  late List<String> _remainingWords; // Kalan kelimeler (tekrar etmemesi için)
  late String _currentWord;
  final TextEditingController _controller = TextEditingController();
  int _score = 0;
  int _timeLeft = 60;
  Timer? _timer;

  String _selectedLevel = 'easy';

  @override
  void initState() {
    super.initState();
    _prepareWords();
    _nextWord();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _prepareWords() {
    // Seçilen seviyeye göre kelimeleri al
    _allWords = _wordsByLevel[_selectedLevel]!;
    // Tüm kelimeleri karıştır
    _remainingWords = List.from(_allWords);
    _remainingWords.shuffle();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft == 0) {
        timer.cancel();
        _showGameOverDialog();
      } else {
        setState(() {
          _timeLeft--;
        });
      }
    });
  }

  void _nextWord() {
    if (_remainingWords.isEmpty) {
      // Kelime bitti, oyunu bitir
      _showGameOverDialog();
      return;
    }
    setState(() {
      _currentWord = _remainingWords.removeLast();
      _controller.clear();
    });
  }

  void _checkWord() {
    final input = _controller.text.trim().toLowerCase();
    if (input.isEmpty) return;

    if (input == _currentWord) {
      setState(() {
        _score += 10;
      });
      _nextWord();
    } else {
      setState(() {
        _score = (_score - 5).clamp(0, 99999);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Yanlış yazdınız! Tekrar deneyin.')),
      );
      _controller.clear();
    }
  }

  void _showGameOverDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            title: const Text('Oyun Bitti!'),
            content: Text('Skorunuz: $_score'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _restartGame();
                },
                child: const Text('Tekrar Oyna'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Ana Menüye Dön'),
              ),
            ],
          ),
    );
  }

  void _restartGame() {
    setState(() {
      _score = 0;
      _timeLeft = 60;
      _prepareWords();
      _nextWord();
      _startTimer();
    });
  }

  void _changeLevel(String? level) {
    if (level == null || level == _selectedLevel) return;
    setState(() {
      _selectedLevel = level;
      _restartGame();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Hızlı Kelime Yazma Oyunu')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Seviye seçimi
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Seviye: ', style: TextStyle(fontSize: 18)),
                DropdownButton<String>(
                  value: _selectedLevel,
                  items:
                      _wordsByLevel.keys
                          .map(
                            (level) => DropdownMenuItem(
                              value: level,
                              child: Text(
                                level[0].toUpperCase() + level.substring(1),
                              ),
                            ),
                          )
                          .toList(),
                  onChanged: _changeLevel,
                ),
              ],
            ),

            const SizedBox(height: 16),
            Text(
              'Kalan Süre: $_timeLeft saniye',
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Text(
              _currentWord,
              style: theme.textTheme.displayMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Kelimeyi yazın',
              ),
              onSubmitted: (_) => _checkWord(),
              autofocus: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _checkWord,
              child: const Text('Kontrol Et'),
            ),
            const Spacer(),
            Text(
              'Skor: $_score',
              style: theme.textTheme.headlineMedium?.copyWith(
                color: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
