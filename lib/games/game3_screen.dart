import 'dart:async';
import 'package:flutter/material.dart';

class Game3Screen extends StatefulWidget {
  const Game3Screen({super.key});

  @override
  State<Game3Screen> createState() => _Game3ScreenState();
}

class _Game3ScreenState extends State<Game3Screen> {
  final Map<String, List<String>> _sentencesByDifficulty = {
    'Easy': [
      'She ____ (to be) happy.',
      'They ____ (to have) a dog.',
      'I ____ (to go) to school every day.',
      'He ____ (to like) pizza.',
    ],
    'Medium': [
      'I ____ (to be) reading a book right now.',
      'They ____ (to visit) their grandparents last weekend.',
      'She ____ (to not like) spinach.',
      'We ____ (to play) football when it started raining.',
    ],
    'Hard': [
      'If I ____ (to be) you, I would study more.',
      'By this time tomorrow, they ____ (to finish) the project.',
      'She wishes she ____ (to know) the answer.',
      'He ____ (to have) been working here for five years before he quit.',
    ],
  };

  final Map<String, List<String>> _answersByDifficulty = {
    'Easy': ['is', 'have', 'go', 'likes'],
    'Medium': ['am', 'visited', 'does not like', 'were playing'],
    'Hard': ['were', 'will have finished', 'knew', 'had'],
  };

  String _selectedDifficulty = 'Easy';
  int _currentSentenceIndex = 0;
  Timer? _timer;
  int _timeLeft = 30;
  int _score = 0;
  bool _isAnswered = false;

  String _hintText = '';
  int _hintIndex = 0;

  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _startNewGame();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _startNewGame() {
    _timer?.cancel();
    setState(() {
      _currentSentenceIndex = 0;
      _score = 0;
      _isAnswered = false;
      _timeLeft = 30;
      _controller.text = '';
      _hintText = '';
      _hintIndex = 0;
    });
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timeLeft = 30;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft == 0) {
        _showCorrectAnswer();
      } else {
        setState(() {
          _timeLeft--;
        });
      }
    });
  }

  void _checkAnswer() {
    _timer?.cancel();
    final correctAnswer =
        _answersByDifficulty[_selectedDifficulty]![_currentSentenceIndex]
            .toLowerCase()
            .trim();
    final userAnswer = _controller.text.toLowerCase().trim();

    setState(() {
      _isAnswered = true;
      if (userAnswer == correctAnswer) {
        _score += 10;
      }
    });
  }

  void _showCorrectAnswer() {
    _timer?.cancel();
    setState(() {
      _isAnswered = true;
      _controller.text =
          _answersByDifficulty[_selectedDifficulty]![_currentSentenceIndex];
    });
  }

  void _nextSentence() {
    if (_currentSentenceIndex + 1 <
        _sentencesByDifficulty[_selectedDifficulty]!.length) {
      setState(() {
        _currentSentenceIndex++;
        _controller.text = '';
        _isAnswered = false;
        _timeLeft = 30;
        _hintText = '';
        _hintIndex = 0;
      });
      _startTimer();
    } else {
      _timer?.cancel();
      showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              title: const Text('Game Over!'),
              content: Text('Your score: $_score'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _startNewGame();
                  },
                  child: const Text('Play Again'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Return to Menu'),
                ),
              ],
            ),
      );
    }
  }

  void _showHint() {
    if (_isAnswered) return;
    final correctAnswer =
        _answersByDifficulty[_selectedDifficulty]![_currentSentenceIndex];
    if (_hintIndex < correctAnswer.length) {
      setState(() {
        _hintText += correctAnswer[_hintIndex];
        _hintIndex++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final sentence =
        _sentencesByDifficulty[_selectedDifficulty]![_currentSentenceIndex];

    return Scaffold(
      appBar: AppBar(title: const Text('English Grammar Fill-in-the-Blank')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            DropdownButton<String>(
              value: _selectedDifficulty,
              items:
                  _sentencesByDifficulty.keys
                      .map(
                        (diff) =>
                            DropdownMenuItem(value: diff, child: Text(diff)),
                      )
                      .toList(),
              onChanged: (val) {
                if (val != null) {
                  setState(() {
                    _selectedDifficulty = val;
                  });
                  _startNewGame();
                }
              },
            ),
            const SizedBox(height: 10),
            LinearProgressIndicator(
              value: _timeLeft / 30,
              minHeight: 8,
              color: Colors.teal,
              backgroundColor: Colors.grey.shade300,
            ),
            const SizedBox(height: 10),
            Text(
              'Time Left: $_timeLeft seconds',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Text(
              sentence.replaceAll('____', '_____'),
              style: const TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            TextField(
              enabled: !_isAnswered,
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Fill in the blank (grammatically correct form)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                ElevatedButton(onPressed: _showHint, child: const Text('Hint')),
                const SizedBox(width: 20),
                if (_hintText.isNotEmpty)
                  Text(
                    'Hint: $_hintText',
                    style: const TextStyle(fontSize: 18, color: Colors.orange),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            if (!_isAnswered)
              ElevatedButton(
                onPressed: _checkAnswer,
                child: const Text('Check Answer'),
              ),
            if (_isAnswered)
              Column(
                children: [
                  Text(
                    _controller.text.toLowerCase().trim() ==
                            _answersByDifficulty[_selectedDifficulty]![_currentSentenceIndex]
                                .toLowerCase()
                        ? 'Correct!'
                        : 'Incorrect! Correct answer: ${_answersByDifficulty[_selectedDifficulty]![_currentSentenceIndex]}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color:
                          _controller.text.toLowerCase().trim() ==
                                  _answersByDifficulty[_selectedDifficulty]![_currentSentenceIndex]
                                      .toLowerCase()
                              ? Colors.green
                              : Colors.red,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text('Score: $_score', style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: _nextSentence,
                    child: const Text('Next Sentence'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
