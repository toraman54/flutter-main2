import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
// Renk sabitlerini import edin. Projenizin yapısına göre path'i güncelleyin.
// Eğer sabitler ayrı bir dosyadaysa o dosyayı import edin.
// Projenizin adı "flutter_main" ise aşağıdaki gibi olmalıdır:
import 'package:flutter_firebase_dersleri/screens/home_screen.dart'; // Doğru proje ve dosya yolu

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? _user;
  // StreamSubscription<User?>? _authStateSubscription; // Dinleyiciyi yönetmek için

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser; // Mevcut kullanıcıyı al

    // Kullanıcı oturum durumu değişikliklerini dinlemek isterseniz:
    // _authStateSubscription = FirebaseAuth.instance.authStateChanges().listen((user) {
    //   setState(() {
    //     _user = user;
    //   });
    // });
  }

  // Eğer authStateChanges dinleyicisini kullanıyorsanız, dispose etmeniz gerekir.
  // @override
  // void dispose() {
  //   _authStateSubscription?.cancel();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profilim'),
        backgroundColor: kPrimaryColor, // Sabit renk kullanıldı
        foregroundColor: Colors.white, // AppBar başlık rengini beyaz yap
      ),
      backgroundColor: kBackgroundColor, // Arka plan rengi sabiti kullanıldı
      body: SingleChildScrollView(
        // İçeriğin kaydırılabilir olmasını sağlar
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 48,
                  backgroundColor: kPrimaryColor, // Sabit renk kullanıldı
                  child: const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 48,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Ad Soyad Bilgisi
              _buildProfileInfoCard(
                title: 'Ad Soyad',
                value: _user?.displayName ?? 'MELİH MÜCAHİT TORAMAN',
                icon: Icons.person_outline,
              ),

              const SizedBox(height: 16),
              // E-posta Bilgisi
              _buildProfileInfoCard(
                title: 'E-posta',
                value: _user?.email ?? 'E-posta Bilinmiyor',
                icon: Icons.email_outlined,
              ),
              const SizedBox(height: 32),
              Center(
                // Butonu ortalamak için Center
                child: ElevatedButton.icon(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    if (!context.mounted) return;
                    Navigator.of(
                      context,
                    ).pushNamedAndRemoveUntil('/login', (route) => false);
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text('Çıkış Yap'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor, // Sabit renk kullanıldı
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 32,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24), // Buton ile liste arasına boşluk
              // Ek ayarlar veya bilgiler için ListTiles
              _buildOptionTile(
                icon: Icons.settings,
                title: 'Ayarlar',
                onTap: () {
                  // Ayarlar ekranına git
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsScreen()));
                  // print('Ayarlar tıklandı'); // Bu satır kaldırıldı/yorumlandı
                },
              ),
              _buildOptionTile(
                icon: Icons.info,
                title: 'Hakkında',
                onTap: () {
                  // Hakkında ekranına git
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => AboutScreen()));
                  // print('Hakkında tıklandı'); // Bu satır kaldırıldı/yorumlandı
                },
              ),
              _buildOptionTile(
                icon: Icons.help,
                title: 'Yardım',
                onTap: () {
                  // Yardım ekranına git
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => HelpScreen()));
                  // print('Yardım tıklandı'); // Bu satır kaldırıldı/yorumlandı
                },
              ),
              const SizedBox(
                height: 24.0,
              ), // Sayfanın altına boşluk eklemek için eklendi
            ],
          ),
        ),
      ),
    );
  }

  // Profil bilgileri için yardımcı widget
  Widget _buildProfileInfoCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, color: kPrimaryColor),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Seçenekler için yardımcı widget
  Widget _buildOptionTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: Icon(icon, color: kPrimaryColor),
        title: Text(title),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey,
        ),
        onTap: onTap,
      ),
    );
  }
}
