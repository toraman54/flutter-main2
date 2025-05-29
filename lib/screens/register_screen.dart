import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

const String kAppLogo = 'assets/EngCourse.png';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _signUp() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // Boş alan kontrolü
    if (_nameController.text.trim().isEmpty ||
        _surnameController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Lütfen tüm alanları doldurun.';
        _isLoading = false;
      });
      return;
    }

    // E-posta format kontrolü
    if (!RegExp(
      r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
    ).hasMatch(_emailController.text.trim())) {
      setState(() {
        _errorMessage = 'Geçerli bir e-posta adresi girin.';
        _isLoading = false;
      });
      return;
    }

    // Şifre eşleşme kontrolü
    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() {
        _errorMessage = 'Şifreler eşleşmiyor!';
        _isLoading = false;
      });
      return;
    }

    try {
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );

      // Firestore'a kullanıcı bilgilerini kaydet
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
            'name': _nameController.text.trim(),
            'surname': _surnameController.text.trim(),
            'email': _emailController.text.trim(),
            'createdAt': FieldValue.serverTimestamp(),
          });

      // Profil adı güncelle (opsiyonel)
      await userCredential.user!.updateDisplayName(
        '${_nameController.text.trim()} ${_surnameController.text.trim()}',
      );

      // Form alanlarını temizle
      _nameController.clear();
      _surnameController.clear();
      _emailController.clear();
      _passwordController.clear();
      _confirmPasswordController.clear();

      // Ana sayfaya yönlendir
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } on FirebaseAuthException catch (e) {
      String message = 'Bir hata oluştu.';

      if (e.code == 'email-already-in-use') {
        message = 'Bu e-posta adresi zaten kullanımda.';
      } else if (e.code == 'invalid-email') {
        message = 'Geçersiz e-posta adresi.';
      } else if (e.code == 'weak-password') {
        message = 'Şifreniz çok zayıf. En az 6 karakter olmalıdır.';
      }

      setState(() {
        _errorMessage = message;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Beklenmeyen bir hata oluştu.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
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
                  Image.asset(kAppLogo, height: 150),
                  const SizedBox(height: 16),
                  const Text(
                    'Lütfen Bir Hesap Oluşturun',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4B2676),
                    ),
                  ),
                  const SizedBox(height: 24),

                  _buildTextField('Ad', _nameController),
                  const SizedBox(height: 16),

                  _buildTextField('Soyad', _surnameController),
                  const SizedBox(height: 16),

                  _buildTextField(
                    'E-posta Adresi',
                    _emailController,
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: const Icon(
                      Icons.email_outlined,
                      color: Color(0xFF4B2676),
                    ),
                  ),
                  const SizedBox(height: 16),

                  _buildPasswordField(
                    'Şifre',
                    _passwordController,
                    _obscurePassword,
                    () {
                      setState(() => _obscurePassword = !_obscurePassword);
                    },
                  ),
                  const SizedBox(height: 16),

                  _buildPasswordField(
                    'Şifreyi Onayla',
                    _confirmPasswordController,
                    _obscureConfirmPassword,
                    () {
                      setState(
                        () =>
                            _obscureConfirmPassword = !_obscureConfirmPassword,
                      );
                    },
                  ),
                  const SizedBox(height: 20),

                  if (_errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        _errorMessage!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _signUp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4B2676),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child:
                          _isLoading
                              ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                              : const Text(
                                'Kayıt Ol',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Zaten bir hesabınız var mı?'),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Text(
                          ' Giriş Yap',
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

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    TextInputType? keyboardType,
    Widget? prefixIcon,
  }) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF4B2676),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              prefixIcon: prefixIcon,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFF4B2676)),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordField(
    String label,
    TextEditingController controller,
    bool obscureText,
    VoidCallback toggleVisibility,
  ) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF4B2676),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            obscureText: obscureText,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFF4B2676)),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 14,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  obscureText ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: toggleVisibility,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
