import 'package:flutter/material.dart';

class HomeworkScreen extends StatelessWidget {
  const HomeworkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ödevlerim'),
        backgroundColor: Color(0xFF4B2676),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildHomeworkCard('1. Hafta Ödevi', 'Teslim: 20 Mayıs 2025', false),
          _buildHomeworkCard('2. Hafta Ödevi', 'Teslim: 27 Mayıs 2025', true),
        ],
      ),
    );
  }

  Widget _buildHomeworkCard(String title, String subtitle, bool done) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: ListTile(
        leading: Icon(
          done ? Icons.check_circle : Icons.assignment,
          color: done ? Colors.green : Color(0xFF4B2676),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing:
            done
                ? const Text(
                  'Tamamlandı',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                )
                : null,
        onTap: () {},
      ),
    );
  }
}
