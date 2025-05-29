import 'dart:ui';
import 'package:flutter/material.dart';

class Game1Screen extends StatefulWidget {
  const Game1Screen({super.key});

  @override
  State<Game1Screen> createState() => _Game1ScreenState();
}

class _Game1ScreenState extends State<Game1Screen>
    with SingleTickerProviderStateMixin {
  String? _selectedDifficulty;
  List<Map<String, dynamic>> _questions = [];

  int _currentIndex = 0;
  String? _selectedOption;
  bool _answered = false;
  bool _isCorrect = false;
  int _score = 0;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  void _startGame() {
    if (_selectedDifficulty == null) return;

    setState(() {
      _questions = _questionsByDifficulty[_selectedDifficulty]!;
      _questions.shuffle(); // Burada soruları rastgele sırala
      _currentIndex = 0;
      _score = 0;
      _selectedOption = null;
      _answered = false;
      _isCorrect = false;
    });
    _fadeController.forward(from: 0);
  }

  void _selectOption(String option) {
    if (_answered) return;

    setState(() {
      _selectedOption = option;
      _answered = true;
      _isCorrect = option == _questions[_currentIndex]['answer'];
      if (_isCorrect) _score++;
    });

    // Skor artışında kısa animasyon için setState kullanılabilir, daha gelişmiş efekt için ekstra animasyon eklenebilir

    Future.delayed(const Duration(seconds: 2), () {
      _fadeController.reverse().then((_) {
        setState(() {
          _currentIndex++;
          _selectedOption = null;
          _answered = false;
          _isCorrect = false;
        });
        _fadeController.forward(from: 0);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox.expand(
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
            child: Image.asset('lib/assets/Lemon -9.jpg', fit: BoxFit.cover),
          ),
        ),
        _buildGameContent(context),
      ],
    );
  }

  Widget _buildGameContent(BuildContext context) {
    if (_selectedDifficulty == null) {
      // Zorluk seçme ekranı
      return Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Kelime Seçme Oyunu - Zorluk Seç'),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Center(
          child: Card(
            color: Color.fromRGBO(255, 255, 255, 0.92), // %92 opaklıkta beyaz
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Zorluk Seviyesi Seçin:',
                    style: TextStyle(
                      fontSize: 24,
                      color: Color(0xFF4B2676),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7B3FE4),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(180, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        _selectedDifficulty = 'easy';
                      });
                      _startGame();
                    },
                    child: const Text('Kolay'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4B2676),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(180, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        _selectedDifficulty = 'medium';
                      });
                      _startGame();
                    },
                    child: const Text('Orta'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8A6FC7),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(180, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        _selectedDifficulty = 'hard';
                      });
                      _startGame();
                    },
                    child: const Text('Zor'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    if (_currentIndex >= _questions.length) {
      // Oyun bitti ekranı
      return Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Kelime Seçme Oyunu'),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Center(
          child: Card(
            color: Color.fromRGBO(255, 255, 255, 0.92), // %92 opaklıkta beyaz
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Oyun Bitti!',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4B2676),
                    ),
                  ),
                  const SizedBox(height: 20),
                  AnimatedScoreText(score: _score, total: _questions.length),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7B3FE4),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(180, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        _selectedDifficulty = null; // tekrar zorluk seçime dön
                      });
                    },
                    child: const Text('Yeniden Oyna'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4B2676),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(180, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Ana Menüye Dön'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    final question = _questions[_currentIndex];

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Kelime Seçme Oyunu'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Card(
            color: Color.fromRGBO(255, 255, 255, 0.92), // %92 opaklıkta beyaz
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Kelimenin Türkçe anlamını seçin:',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: const Color(0xFF4B2676),
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  Text(
                    question['word'],
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                  const SizedBox(height: 40),
                  ...List.generate(question['options'].length, (index) {
                    final option = question['options'][index];
                    final isSelected = option == _selectedOption;
                    Color baseColor = Colors.grey.shade200;
                    Color optionColor = baseColor;
                    if (_answered) {
                      if (option == question['answer']) {
                        optionColor = Colors.green.shade400;
                      } else if (isSelected && option != question['answer']) {
                        optionColor = Colors.red.shade400;
                      }
                    }

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut,
                        decoration: BoxDecoration(
                          color: optionColor,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow:
                              isSelected
                                  ? [
                                    BoxShadow(
                                      color: Color.fromRGBO(
                                        optionColor.r.toInt(),
                                        optionColor.g.toInt(),
                                        optionColor.b.toInt(),
                                        0.6, // Yeni opaklık değeri
                                      ),
                                      blurRadius: 8,
                                      spreadRadius: 1,
                                      offset: const Offset(0, 3),
                                    ),
                                  ]
                                  : [],
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            foregroundColor: Colors.black87,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () => _selectOption(option),
                          child: Text(
                            option,
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 24),
                  if (_answered) AnimatedCorrectness(isCorrect: _isCorrect),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AnimatedCorrectness extends StatefulWidget {
  final bool isCorrect;

  const AnimatedCorrectness({super.key, required this.isCorrect});

  @override
  State<AnimatedCorrectness> createState() => _AnimatedCorrectnessState();
}

class _AnimatedCorrectnessState extends State<AnimatedCorrectness>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _scaleAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));
    _colorAnimation = ColorTween(
      begin: Colors.transparent,
      end: widget.isCorrect ? Colors.green : Colors.red,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant AnimatedCorrectness oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isCorrect != widget.isCorrect) {
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            widget.isCorrect ? Icons.check_circle : Icons.cancel,
            color: widget.isCorrect ? Colors.green : Colors.red,
            size: 48,
          ),
          const SizedBox(width: 12),
          Text(
            widget.isCorrect ? 'Doğru!' : 'Yanlış!',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: widget.isCorrect ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}

class AnimatedScoreText extends StatefulWidget {
  final int score;
  final int total;

  const AnimatedScoreText({
    super.key,
    required this.score,
    required this.total,
  });

  @override
  State<AnimatedScoreText> createState() => _AnimatedScoreTextState();
}

class _AnimatedScoreTextState extends State<AnimatedScoreText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _scoreAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _scoreAnimation = IntTween(begin: 0, end: widget.score).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    )..addListener(() {
      setState(() {});
    });
    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant AnimatedScoreText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.score != widget.score) {
      _controller.reset();
      _scoreAnimation = IntTween(
        begin: 0,
        end: widget.score,
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      'Skorunuz: ${_scoreAnimation.value} / ${widget.total}',
      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    );
  }
}

// Kelimeler zorluklara göre
final Map<String, List<Map<String, dynamic>>> _questionsByDifficulty = {
  'easy': [
    {
      'word': 'Apple',
      'options': ['Elma', 'Armut', 'Muz', 'Portakal'],
      'answer': 'Elma',
    },
    {
      'word': 'Dog',
      'options': ['Kedi', 'Köpek', 'At', 'Fare'],
      'answer': 'Köpek',
    },
    {
      'word': 'Book',
      'options': ['Kitap', 'Masa', 'Kalem', 'Defter'],
      'answer': 'Kitap',
    },
    {
      'word': 'Car',
      'options': ['Bisiklet', 'Araba', 'Otobüs', 'Uçak'],
      'answer': 'Araba',
    },
    {
      'word': 'Sun',
      'options': ['Ay', 'Yıldız', 'Güneş', 'Bulut'],
      'answer': 'Güneş',
    },
    {
      'word': 'House',
      'options': ['Ev', 'Araba', 'Bahçe', 'Sokak'],
      'answer': 'Ev',
    },
    {
      'word': 'Water',
      'options': ['Su', 'Hava', 'Toprak', 'Ateş'],
      'answer': 'Su',
    },
  ],
  'medium': [
    {
      'word': 'Computer',
      'options': ['Bilgisayar', 'Telefon', 'Televizyon', 'Radyo'],
      'answer': 'Bilgisayar',
    },
    {
      'word': 'Bicycle',
      'options': ['Araba', 'Bisiklet', 'Otobüs', 'Tren'],
      'answer': 'Bisiklet',
    },
    {
      'word': 'Window',
      'options': ['Kapı', 'Pencere', 'Duvar', 'Tavan'],
      'answer': 'Pencere',
    },
    {
      'word': 'Rain',
      'options': ['Kar', 'Yağmur', 'Güneş', 'Rüzgar'],
      'answer': 'Yağmur',
    },
    {
      'word': 'Table',
      'options': ['Masa', 'Sandalye', 'Koltuk', 'Kapı'],
      'answer': 'Masa',
    },
    {
      'word': 'School',
      'options': ['Okul', 'Ev', 'Ofis', 'Kütüphane'],
      'answer': 'Okul',
    },
    {
      'word': 'Garden',
      'options': ['Bahçe', 'Oda', 'Sokak', 'Araba'],
      'answer': 'Bahçe',
    },
  ],
  'hard': [
    {
      'word': 'Philosophy',
      'options': ['Felsefe', 'Matematik', 'Kimya', 'Tarih'],
      'answer': 'Felsefe',
    },
    {
      'word': 'Democracy',
      'options': ['Demokrasi', 'Monarşi', 'Oligarşi', 'Anarşi'],
      'answer': 'Demokrasi',
    },
    {
      'word': 'Economics',
      'options': ['Ekonomi', 'Sosyoloji', 'Psikoloji', 'Fizik'],
      'answer': 'Ekonomi',
    },
    {
      'word': 'Constitution',
      'options': ['Anayasa', 'Yasa', 'Mahkeme', 'Ceza'],
      'answer': 'Anayasa',
    },
    {
      'word': 'Legislation',
      'options': ['Mevzuat', 'Hukuk', 'İdare', 'Yönetim'],
      'answer': 'Mevzuat',
    },
    {
      'word': 'Architecture',
      'options': ['Mimarlık', 'İnşaat', 'Tasarım', 'Sanat'],
      'answer': 'Mimarlık',
    },
    {
      'word': 'Psychology',
      'options': ['Psikoloji', 'Felsefe', 'Sosyoloji', 'Tarih'],
      'answer': 'Psikoloji',
    },
  ],
};
