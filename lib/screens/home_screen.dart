import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:ui';
import '../games/game_menu_screen.dart'; // Oyun menüsü için import
import 'courses_screen.dart'; // Kurslar ekranı için import
import 'ai_chat_screen.dart'; // ChatGPT ekranı için import
import 'homework_screen.dart'; // Ödevlerim ekranı için import
import 'profile_screen.dart'; // Profilim ekranı için import

// Sabit Renkler
const Color kPrimaryColor = Color(0xFF4B2676);
const Color kSecondaryColor = Color(0xFF8A6FC7);
const Color kBackgroundColor = Color(
  0xFFF3F0FA,
); // Çekmece simgesi arka planı için

const String kAppLogo = 'lib/assets/Lemon -9.jpg';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? name;
  String? surname;
  String? email;
  bool isLoading =
      false; // Şu an kullanılmıyor ama duruma göre değerlendirilebilir.
  int _selectedTab = 0; // Alt navigasyon çubuğunun seçili sekmesi
  int _selectedGroupTab = 1; // 0: Tümü, 1: Sınıfım, 2: Ödevlerim

  // Alt navigasyon çubuğu için sayfalar listesi
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    name = user?.displayName ?? '';
    surname = '';
    email = user?.email ?? '';
    isLoading = false;

    // Sayfaları burada başlatıyoruz
    _pages = [
      _HomeContent(
        userName: name ?? '',
        userSurname: surname ?? '',
        onProfileTap: _onProfileTap,
        onSearchTap: () {
          /* Arama fonksiyonu */
        },
        onChatGptTap: () => _onBottomNavTap(2), // ChatGPT sekmesine yönlendir
        onGroupCardTap: (week) {
          Navigator.pushNamed(
            context,
            '/groupDetail',
            arguments: {'week': week},
          );
        },
        selectedGroupTab: _selectedGroupTab,
        onGroupTabSelected: (index) {
          setState(() {
            _selectedGroupTab = index;
          });
        },
      ),
      // Diğer sekmeler için örnek sayfalar. Gerçek uygulamada kendi sayfalarınız olacak.
      const CoursesScreen(), // Şimdi gerçek CourseScreen kullanılıyor
      const AiChatScreen(), // Şimdi gerçek AiChatScreen kullanılıyor
      const HomeworkScreen(), // Şimdi gerçek HomeworkScreen kullanılıyor
      const GameMenuScreen(),
      const ProfileScreen(), // Şimdi gerçek ProfileScreen kullanılıyor
    ];
  }

  void _onBottomNavTap(int index) {
    setState(() {
      _selectedTab = index;
    });
  }

  void _onProfileTap() {
    setState(() {
      _selectedTab = 5; // Profil sekmesine geçiş
    });
  }

  void onNewHomeworkTap() {
    setState(() {
      _selectedTab = 3; // Ödevlerim sekmesine geçiş
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: kPrimaryColor),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 36, color: kPrimaryColor),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$name $surname',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    email ?? '',
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Ana Sayfa'),
              onTap: () {
                _onBottomNavTap(0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.book),
              title: const Text('Kurslar'),
              onTap: () {
                _onBottomNavTap(1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.assignment),
              title: const Text('Ödevlerim'),
              onTap: () {
                _onBottomNavTap(3);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.chat_bubble),
              title: const Text('ChatGPT'),
              onTap: () {
                _onBottomNavTap(2);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.videogame_asset),
              title: const Text('Oyun'),
              onTap: () {
                _onBottomNavTap(4);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profilim'),
              onTap: () {
                _onBottomNavTap(5);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          // Blur arka plan limon resmi
          SizedBox.expand(
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
              child: Image.asset('lib/assets/Lemon -9.jpg', fit: BoxFit.cover),
            ),
          ),
          // IndexedStack ile sekmeler arası geçiş
          IndexedStack(index: _selectedTab, children: _pages),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTab,
        onTap: _onBottomNavTap,
        selectedItemColor: kPrimaryColor,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Ana Sayfa'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Kurslar'),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble),
            label: 'ChatGPT',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Ödevlerim',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.videogame_asset),
            label: 'Oyun',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profilim'),
        ],
      ),
    );
  }
}

// Ana ekranın içeriğini barındıran yeni widget
class _HomeContent extends StatefulWidget {
  final String userName;
  final String userSurname;
  final VoidCallback onProfileTap;
  final VoidCallback onSearchTap;
  final VoidCallback onChatGptTap;
  final Function(int) onGroupCardTap;
  final int selectedGroupTab;
  final Function(int) onGroupTabSelected;

  const _HomeContent({
    super.key,
    required this.userName,
    required this.userSurname,
    required this.onProfileTap,
    required this.onSearchTap,
    required this.onChatGptTap,
    required this.onGroupCardTap,
    required this.selectedGroupTab,
    required this.onGroupTabSelected,
  });

  @override
  State<_HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<_HomeContent> {
  Widget _buildGroupTab(String label, int index) {
    final isSelected = widget.selectedGroupTab == index;
    return GestureDetector(
      onTap: () => widget.onGroupTabSelected(index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: isSelected ? kPrimaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : kPrimaryColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildGroupCard({
    required int week,
    required int userCount,
    required String time,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.25),
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                'lib/assets/Lemon -9.jpg',
                height: 40,
                width: 40,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$week. Hafta',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.circle, color: Colors.green, size: 12),
                      const SizedBox(width: 4),
                      Text(userCount.toString()),
                      const SizedBox(width: 16),
                      const Icon(
                        Icons.access_time,
                        size: 14,
                        color: kSecondaryColor,
                      ),
                      const SizedBox(width: 4),
                      Text(time),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Builder(
                    builder:
                        (context) => GestureDetector(
                          onTap: () => Scaffold.of(context).openDrawer(),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: kBackgroundColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 8,
                                      height: 8,
                                      color: kPrimaryColor,
                                    ),
                                    const SizedBox(width: 4),
                                    Container(
                                      width: 8,
                                      height: 8,
                                      color: kPrimaryColor,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Container(
                                      width: 8,
                                      height: 8,
                                      color: kPrimaryColor,
                                    ),
                                    const SizedBox(width: 4),
                                    Container(
                                      width: 8,
                                      height: 8,
                                      color: kPrimaryColor,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${widget.userName} ${widget.userSurname}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Bugün ne öğrenmek istiyorsun?',
                        style: TextStyle(fontSize: 14, color: kSecondaryColor),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: widget.onProfileTap,
                    child: const CircleAvatar(
                      backgroundColor: kPrimaryColor,
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: kPrimaryColor, width: 1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.search, color: kSecondaryColor),
                    SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Arama yap...',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Mor kutunun içindeki limon resmi ve chat butonu
              GestureDetector(
                onTap: widget.onChatGptTap,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(0x7B, 0x3F, 0xE4, 0.95),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Yapay Zeka ile Sohbet!',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Sorularını ChatGPT ile sorabilirsin',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              width: 120,
                              child: ElevatedButton(
                                onPressed: widget.onChatGptTap,
                                style: const ButtonStyle(
                                  backgroundColor: WidgetStatePropertyAll(
                                    kPrimaryColor,
                                  ),
                                  foregroundColor: WidgetStatePropertyAll(
                                    Colors.white,
                                  ),
                                  padding: WidgetStatePropertyAll(
                                    EdgeInsets.symmetric(vertical: 8),
                                  ),
                                ),
                                child: const Text('ChatGPT ile Aç'),
                              ),
                            ),
                          ],
                        ),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          'lib/assets/Lemon -9.jpg',
                          height: 60,
                          width: 60,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Bartalk Grupları',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  _buildGroupTab('Tümü', 0),
                  _buildGroupTab('Sınıfım', 1),
                  _buildGroupTab('Ödevlerim', 2),
                  _buildGroupTab('Deney', 3),
                ],
              ),
              const SizedBox(height: 16),
              // Grup listesi örnek
              Column(
                children: List.generate(
                  20,
                  (i) => _buildGroupCard(
                    week: i + 1,
                    userCount: i == 0 ? 5 : 4,
                    time: '20:00',
                    onTap: () => widget.onGroupCardTap(i + 1),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
