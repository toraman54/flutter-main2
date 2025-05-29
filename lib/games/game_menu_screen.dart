import 'dart:ui';

import 'package:flutter/material.dart';
import 'game1_screen.dart';
import 'game2_screen.dart';
import 'game3_screen.dart';
import 'game4_screen.dart';

class GameMenuScreen extends StatelessWidget {
  const GameMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final games = [
      {
        'title': 'Kelime Seçme Oyunu',
        'icon': Icons.spellcheck,
        'color': const Color(0xFF7B3FE4),
        'widget': const Game1Screen(),
      },
      {
        'title': 'Yazma Oyunu',
        'icon': Icons.edit_note,
        'color': const Color(0xFF4B2676),
        'widget': const Game2Screen(),
      },
      {
        'title': 'Boşluk Doldurma Oyunu',
        'icon': Icons.text_fields,
        'color': const Color(0xFF8A6FC7),
        'widget': const Game3Screen(),
      },
      {
        'title': 'Hızlı Kelime Yazma Oyunu',
        'icon': Icons.flash_on,
        'color': const Color(0xFFF3C623),
        'widget': const Game4Screen(),
      },
    ];

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Oyunlar'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Arka plan limonlu ve blur efekti
          SizedBox.expand(
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
              child: Image.asset('lib/assets/Lemon -9.jpg', fit: BoxFit.cover),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Oyunlar',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                      color: Color(0xFF4B2676),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: ListView.separated(
                      itemCount: games.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 20),
                      itemBuilder: (context, i) {
                        final game = games[i];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => game['widget'] as Widget,
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(
                                (game['color'] as Color).r
                                    .toInt(), // 'red' yerine '.r' kullanıldı
                                (game['color'] as Color).g
                                    .toInt(), // 'green' yerine '.g' kullanıldı
                                (game['color'] as Color).b
                                    .toInt(), // 'blue' yerine '.b' kullanıldı
                                0.93, // Opaklık değeri (double olarak kalır)
                              ),
                              borderRadius: BorderRadius.circular(18),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 22,
                              horizontal: 18,
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 28,
                                  child: Icon(
                                    game['icon'] as IconData,
                                    color: game['color'] as Color,
                                    size: 32,
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: Text(
                                    game['title'] as String,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                const Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.white,
                                  size: 22,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
