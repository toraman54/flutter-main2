import 'dart:ui';
import 'package:flutter/material.dart';

class AiChatScreen extends StatefulWidget {
  const AiChatScreen({super.key});

  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  bool _isLoading = false;

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add({'role': 'user', 'content': text});
      _isLoading = true;
      _controller.clear();
    });
    // Gemini API entegrasyonu burada olacak (örnek cevap)
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _messages.add({'role': 'ai', 'content': 'Elrean "Limon at abi"'});
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('ChatGPT Sohbet'),
        backgroundColor: Color.fromRGBO(
          0xB7, // Kırmızı (0-255)
          0xA4, // Yeşil (0-255)
          0x4A, // Mavi (0-255)
          0.85, // Opaklık (0.0-1.0 arası double)
        ),
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Blur limon arka plan
          SizedBox.expand(
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
              child: Image.asset('lib/assets/Lemon -9.jpg', fit: BoxFit.cover),
            ),
          ),
          Container(
            color: Color.fromRGBO(
              Colors.yellow.r.toInt(),
              Colors.yellow.g.toInt(),
              Colors.yellow.b.toInt(),
              0.08,
            ), // limon teması için hafif sarı overlay
          ),
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final msg = _messages[index];
                      final isUser = msg['role'] == 'user';
                      return Align(
                        alignment:
                            isUser
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color:
                                isUser
                                    ? const Color(0xFFB7A44A)
                                    : Color.fromRGBO(
                                      Colors.white.r.toInt(),
                                      Colors.white.g.toInt(),
                                      Colors.white.b.toInt(),
                                      0.85,
                                    ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            msg['content'] ?? '',
                            style: TextStyle(
                              color: isUser ? Colors.white : Colors.black87,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                if (_isLoading)
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(),
                  ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          decoration: InputDecoration(
                            hintText: 'Mesajınızı yazın... 🍋',
                            filled: true,
                            fillColor: Color.fromRGBO(
                              Colors.white.r.toInt(),
                              Colors.white.g.toInt(),
                              Colors.white.b.toInt(),
                              0.85,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Color(0xFFB7A44A)),
                            ),
                          ),
                          onSubmitted: (_) => _sendMessage(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: _isLoading ? null : _sendMessage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFB7A44A),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Icon(Icons.send),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
