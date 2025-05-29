import 'package:flutter/material.dart';

class CoursesScreen extends StatelessWidget {
  const CoursesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kurslar'),
        backgroundColor: const Color(0xFF4B2676), // Sabit renk kullanıldı
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildCourseCard(
            'İngilizce Başlangıç',
            'A1-A2 Seviyesi',
            'lib/assets/Lemon -9.jpg',
          ),
          _buildCourseCard(
            'İngilizce Orta',
            'B1-B2 Seviyesi',
            'lib/assets/Lemon -9.jpg',
          ),
          _buildCourseCard(
            'İngilizce İleri',
            'C1-C2 Seviyesi',
            'lib/assets/Lemon -9.jpg',
          ),
        ],
      ),
    );
  }

  Widget _buildCourseCard(String title, String subtitle, String imagePath) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(
            imagePath,
            width: 48,
            height: 48,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 18),
        onTap: () {
          // Kursa tıklandığında yapılacak işlem (örneğin, kurs detay sayfasına gitme)
          // Navigator.push(context, MaterialPageRoute(builder: (context) => CourseDetailScreen(title: title)));
        },
      ),
    );
  }
}
