import 'package:flutter/material.dart';

class Game2Screen extends StatefulWidget {
  const Game2Screen({super.key});

  @override
  State<Game2Screen> createState() => _Game2ScreenState();
}

class _Game2ScreenState extends State<Game2Screen> {
  late List<Map<String, dynamic>> _questions;
  final List<Map<String, dynamic>> _allQuestions = [
    {'word': 'Elma', 'answer': 'Apple'},
    {'word': 'Köpek', 'answer': 'Dog'},
    {'word': 'Kitap', 'answer': 'Book'},
    {'word': 'Araba', 'answer': 'Car'},
    {'word': 'Güneş', 'answer': 'Sun'},
    {'word': 'Masa', 'answer': 'Table'},
    {'word': 'Kalem', 'answer': 'Pen'},
    {'word': 'Kapı', 'answer': 'Door'},
    {'word': 'Ayakkabı', 'answer': 'Shoe'},
    {'word': 'Telefon', 'answer': 'Phone'},
    {'word': 'Bilgisayar', 'answer': 'Computer'},
    {'word': 'Pencere', 'answer': 'Window'},
    {'word': 'Su', 'answer': 'Water'},
    {'word': 'Kedi', 'answer': 'Cat'},
    {'word': 'Armut', 'answer': 'Pear'},
    {'word': 'Muz', 'answer': 'Banana'},
    {'word': 'Çiçek', 'answer': 'Flower'},
    {'word': 'Şehir', 'answer': 'City'},
    {'word': 'Deniz', 'answer': 'Sea'},
    {'word': 'Hava', 'answer': 'Air'},
  ];

  int _currentIndex = 0;
  final _controller = TextEditingController();
  bool _isCorrect = false;
  bool _answered = false;

  @override
  void initState() {
    super.initState();
    _questions = List.from(_allQuestions);
    _questions.shuffle();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _checkAnswer() {
    if (_answered) return;

    final userAnswer = _controller.text.trim().toLowerCase();
    final correctAnswer =
        _questions[_currentIndex]['answer'].toString().toLowerCase();

    setState(() {
      _isCorrect = userAnswer == correctAnswer;
      _answered = true;
    });

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _answered = false;
        _controller.clear();
        _currentIndex++;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_currentIndex >= _questions.length) {
      return Scaffold(
        appBar: AppBar(title: const Text('Yazma Oyunu')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Oyun Bitti!',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _questions.shuffle();
                    _currentIndex = 0;
                    _answered = false;
                    _controller.clear();
                  });
                },
                child: const Text('Tekrar Oyna'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Ana Menüye Dön'),
              ),
            ],
          ),
        ),
      );
    }

    final question = _questions[_currentIndex];

    return Scaffold(
      appBar: AppBar(title: const Text('Yazma Oyunu')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Aşağıdaki kelimenin İngilizcesini yazın:',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Text(
              question['word'],
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _controller,
              enabled: !_answered,
              autofocus: true,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: 'İngilizce kelimeyi yazın',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _checkAnswer,
                ),
              ),
              onSubmitted: (_) => _checkAnswer(),
            ),
            const SizedBox(height: 24),
            if (_answered)
              Text(
                _isCorrect
                    ? 'Doğru!'
                    : 'Yanlış! Doğru cevap: ${question['answer']}',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: _isCorrect ? Colors.green : Colors.red,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
