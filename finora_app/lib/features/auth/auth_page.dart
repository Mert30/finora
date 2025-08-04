import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage>
    with SingleTickerProviderStateMixin {
  bool isLogin = true;
  bool showSuccessAnimation = false;

  final _formKey = GlobalKey<FormState>();

  // Kayıt alanları
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Giriş alanları
  final _loginEmailController = TextEditingController();
  final _loginPasswordController = TextEditingController();

  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _loginEmailController.dispose();
    _loginPasswordController.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      isLogin = !isLogin;
      _formKey.currentState?.reset();
      _clearFields();

      if (isLogin) {
        _animationController.reverse();
      } else {
        _animationController.forward();
      }
    });
  }

  void _clearFields() {
    _nameController.clear();
    _emailController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();
    _loginEmailController.clear();
    _loginPasswordController.clear();
  }

  void _register() {
    if (_formKey.currentState?.validate() ?? false) {
      // TODO: Firebase Authentication ile kayıt işlemini buraya ekle

      setState(() {
        showSuccessAnimation = true;
      });

      Future.delayed(const Duration(seconds: 3), () {
        setState(() {
          showSuccessAnimation = false;
          isLogin = true;
          _clearFields();
          _animationController.reverse();
        });
      });
    }
  }

  void _login() {
    if (_formKey.currentState?.validate() ?? false) {
      // TODO: Firebase Authentication ile giriş işlemini buraya ekle

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Giriş başarılı gibi varsayıldı!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (showSuccessAnimation) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Lottie.asset(
            'assets/success.json',
            repeat: false,
            width: 200,
            height: 200,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Başlık
                  Text(
                    isLogin ? 'Finora\'ya Giriş Yap' : 'Finora\'ya Kayıt Ol',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                      letterSpacing: 1,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Toggle Butonları
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _animatedToggleButton('Giriş', isLogin),
                      const SizedBox(width: 16),
                      _animatedToggleButton('Kayıt', !isLogin),
                    ],
                  ),

                  const SizedBox(height: 24),

                  Form(
                    key: _formKey,
                    child: isLogin ? _buildLoginForm() : _buildRegisterForm(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _animatedToggleButton(String text, bool active) {
    return GestureDetector(
      onTap: () {
        if ((text == 'Giriş' && !isLogin) || (text == 'Kayıt' && isLogin)) {
          _toggle();
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 28),
        decoration: BoxDecoration(
          color: active ? Colors.blueAccent : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: active ? Colors.blueAccent : Colors.grey.shade400,
            width: 2,
          ),
          boxShadow: active
              ? [
                  BoxShadow(
                    color: Colors.blueAccent.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Text(
          text,
          style: TextStyle(
            color: active ? Colors.white : Colors.grey.shade700,
            fontWeight: FontWeight.bold,
            fontSize: 16,
            letterSpacing: 0.6,
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Column(
      children: [
        _buildInputField(
          controller: _loginEmailController,
          label: 'E-posta',
          icon: Icons.email_outlined,
          validator: (value) {
            if (value == null || value.isEmpty) return 'E-posta gerekli';
            if (!value.contains('@')) return 'Geçerli bir e-posta girin';
            return null;
          },
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16),
        _buildInputField(
          controller: _loginPasswordController,
          label: 'Şifre',
          icon: Icons.lock_outline,
          obscureText: true,
          validator: (value) {
            if (value == null || value.isEmpty) return 'Şifre gerekli';
            if (value.length < 6) return 'Şifre en az 6 karakter olmalı';
            return null;
          },
        ),
        const SizedBox(height: 28),
        ElevatedButton(
          onPressed: _login,
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 52),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            backgroundColor: Colors.blueAccent,
          ),
          child: const Text(
            'Giriş Yap',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildRegisterForm() {
    return Column(
      children: [
        _buildInputField(
          controller: _nameController,
          label: 'Ad Soyad',
          icon: Icons.person_outline,
          validator: (value) {
            if (value == null || value.isEmpty) return 'Ad Soyad gerekli';
            return null;
          },
        ),
        const SizedBox(height: 16),
        _buildInputField(
          controller: _emailController,
          label: 'E-posta',
          icon: Icons.email_outlined,
          validator: (value) {
            if (value == null || value.isEmpty) return 'E-posta gerekli';
            if (!value.contains('@')) return 'Geçerli bir e-posta girin';
            return null;
          },
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16),
        _buildInputField(
          controller: _passwordController,
          label: 'Şifre',
          icon: Icons.lock_outline,
          obscureText: true,
          validator: (value) {
            if (value == null || value.isEmpty) return 'Şifre gerekli';
            if (value.length < 6) return 'Şifre en az 6 karakter olmalı';
            return null;
          },
        ),
        const SizedBox(height: 16),
        _buildInputField(
          controller: _confirmPasswordController,
          label: 'Şifre Tekrar',
          icon: Icons.lock_outline,
          obscureText: true,
          validator: (value) {
            if (value == null || value.isEmpty) return 'Şifre tekrar gerekli';
            if (value != _passwordController.text) return 'Şifreler uyuşmuyor';
            return null;
          },
        ),
        const SizedBox(height: 28),
        ElevatedButton(
          onPressed: _register,
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 52),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            backgroundColor: Colors.blueAccent,
          ),
          child: const Text(
            'Kayıt Ol',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.blueAccent),
        labelText: label,
        filled: true,
        fillColor: Colors.blue.shade50,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue.shade100, width: 1),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent, width: 2),
        ),
      ),
    );
  }
}
