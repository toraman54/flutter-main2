import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb; // Platforma özel kod için

const String kAppLogo = 'assets/EngCourse.png';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;
  bool _isLoading = false;
  String? _errorMessage;

  // GoogleSignIn nesnesini sadece mobilde oluşturmak için nullable yaptık
  GoogleSignIn? _googleSignIn;

  @override
  void initState() {
    super.initState();
    // Sadece web dışındaki platformlarda (mobil) GoogleSignIn nesnesini başlat
    if (!kIsWeb) {
      _googleSignIn = GoogleSignIn();
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed('/home');
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = _firebaseErrorToTurkish(e);
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      if (kIsWeb) {
        GoogleAuthProvider googleProvider = GoogleAuthProvider();
        await FirebaseAuth.instance.signInWithPopup(googleProvider);
      } else {
        final GoogleSignInAccount? googleUser = await _googleSignIn?.signIn();

        if (googleUser == null) {
          if (mounted) {
            setState(() {
              _isLoading = false;
            });
          }
          return;
        }

        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        await FirebaseAuth.instance.signInWithCredential(credential);
      }

      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed('/home');
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = _firebaseErrorToTurkish(e);
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Google ile giriş başarısız oldu: $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _resetPassword() async {
    setState(() {
      _errorMessage = null; // Şifre sıfırlama denemesinde önceki hatayı temizle
    });

    if (_emailController.text.trim().isEmpty) {
      setState(() {
        _errorMessage = 'Şifre sıfırlamak için e-posta girin.';
      });
      return;
    }

    // Basit e-posta formatı kontrolü
    if (!RegExp(
      r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    ).hasMatch(_emailController.text.trim())) {
      setState(() {
        _errorMessage = 'Geçerli bir e-posta adresi girin.';
      });
      return;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailController.text.trim(),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Şifre sıfırlama bağlantısı e-postanıza gönderildi.'),
        ),
      );
      setState(() {
        // Başarılı mesaj gösterildiğinde hata mesajını temizle
        _errorMessage = null;
      });
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      setState(() {
        // Şifre sıfırlama hatalarına özel mesajlar
        switch (e.code) {
          case 'user-not-found':
            _errorMessage = 'Bu e-posta adresine kayıtlı kullanıcı bulunamadı.';
            break;
          case 'invalid-email':
            _errorMessage = 'Geçersiz e-posta adresi biçimi.';
            break;
          case 'network-request-failed':
            _errorMessage =
                'Ağ bağlantısı hatası. Lütfen internet bağlantınızı kontrol edin.';
            break;
          default:
            _errorMessage = 'Şifre sıfırlama başarısız oldu: ${e.message}';
            break;
        }
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage =
            'Şifre sıfırlama sırasında beklenmedik bir hata oluştu: $e';
      });
    }
  }

  // Hata mesajlarını Türkçeye çeviren yardımcı fonksiyon
  String _firebaseErrorToTurkish(FirebaseAuthException e) {
    // Hata kodu ile Türkçeleştirme
    switch (e.code) {
      case 'invalid-email':
        return 'Geçersiz e-posta adresi girdiniz.';
      case 'user-disabled':
        return 'Bu kullanıcı hesabı devre dışı bırakılmış.';
      case 'user-not-found':
        return 'Bu e-posta ile kayıtlı kullanıcı bulunamadı.';
      case 'wrong-password':
        return 'Hatalı şifre girdiniz.';
      case 'account-exists-with-different-credential':
        return 'Bu e-posta başka bir giriş yöntemiyle zaten kayıtlı.';
      case 'invalid-credential':
        return 'Kimlik doğrulama bilgisi geçersiz veya süresi dolmuş.';
      case 'operation-not-allowed':
        return 'Bu giriş yöntemi şu anda aktif değil.';
      case 'popup-closed-by-user':
        return 'Google giriş penceresi kapatıldı.';
      case 'network-request-failed':
        return 'Ağ bağlantı hatası oluştu. Lütfen internetinizi kontrol edin.';
      case 'too-many-requests':
        return 'Çok fazla deneme yapıldı. Lütfen daha sonra tekrar deneyin.';
    }
    // Hata mesajı içeriğine göre Türkçeleştirme
    if (e.message != null) {
      if (e.message!.contains('The supplied auth credential is incorrect') ||
          e.message!.contains('malformed or has expired')) {
        return 'Kimlik doğrulama bilgisi hatalı, bozuk veya süresi dolmuş.';
      }
      if (e.message!.contains('password is invalid')) {
        return 'Hatalı şifre girdiniz.';
      }
    }
    return 'Bir hata oluştu: ${e.message ?? e.code}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    kAppLogo, // Uygulama logosu
                    height: 150,
                    errorBuilder:
                        (context, error, stackTrace) => Container(
                          height: 150,
                          width: 150,
                          color: Colors.grey[200],
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.broken_image,
                            size: 64,
                            color: Colors.grey,
                          ),
                        ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Tekrar Hoşgeldiniz',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4B2676),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Lütfen giriş yapın',
                    style: TextStyle(fontSize: 16, color: Color(0xFF8A6FC7)),
                  ),
                  const SizedBox(height: 24),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'E-posta Adresi',
                      style: TextStyle(
                        color: Color(0xFF4B2676),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFF4B2676)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        // Odaklandığında kenarlık rengi
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Color(0xFF4B2676),
                          width: 2,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        // Odaklanmadığında kenarlık rengi
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFF8A6FC7)),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Şifre',
                      style: TextStyle(
                        color: Color(0xFF4B2676),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _passwordController,
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFF4B2676)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        // Odaklandığında kenarlık rengi
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Color(0xFF4B2676),
                          width: 2,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        // Odaklanmadığında kenarlık rengi
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFF8A6FC7)),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 14,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: const Color(
                            0xFF8A6FC7,
                          ), // Göz simgesinin rengi
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: _resetPassword,
                      child: const Text(
                        'Şifremi Unuttum',
                        style: TextStyle(color: Color(0xFF8A6FC7)),
                      ),
                    ),
                  ),
                  // Hata mesajı varsa göster
                  if (_errorMessage != null) ...[
                    Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                  ],
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed:
                          _isLoading
                              ? null
                              : _signIn, // Yüklenirken butonu devre dışı bırak
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4B2676),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child:
                          _isLoading // Yüklenirken CircularProgressIndicator göster
                              ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                              : const Text(
                                'Giriş Yap',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Google ile Giriş Butonu
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed:
                          _isLoading
                              ? null
                              : _signInWithGoogle, // Yüklenirken butonu devre dışı bırak
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4B2676),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 2,
                      ),
                      icon: Image.asset(
                        'assets/google_logo_white.png', // Google logosu
                        height: 24,
                        // Eğer logo bulunamazsa bir Icon göster
                        errorBuilder:
                            (context, error, stackTrace) =>
                                const Icon(Icons.login, color: Colors.white),
                      ),
                      label: const Text(
                        'Google ile Giriş Yap',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Hesabınız yok mu? "),
                      GestureDetector(
                        onTap: () {
                          // Kayıt ekranına yönlendirme
                          Navigator.pushNamed(context, '/register');
                        },
                        child: const Text(
                          'Kayıt Olun',
                          style: TextStyle(
                            color: Color(0xFF4B2676),
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
