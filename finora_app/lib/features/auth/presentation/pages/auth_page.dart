import 'package:flutter/material.dart';
import 'login_page.dart';
import 'register_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool showLogin = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Hafif degrade arka plan
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1E3C72), Color(0xFF2A5298)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 30),
              // Toggle Butonlar
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _toggleButton('Giriş Yap', showLogin),
                  _toggleButton('Kayıt Ol', !showLogin),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  child: showLogin
                      ? const LoginPage(key: ValueKey('login'))
                      : const RegisterPage(key: ValueKey('register')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _toggleButton(String text, bool isActive) {
    return GestureDetector(
      onTap: () {
        setState(() {
          showLogin = (text == 'Giriş Yap');
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 36),
        decoration: BoxDecoration(
          color: isActive ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(40),
          border: Border.all(
            color: isActive ? Colors.white : Colors.white70,
            width: 2,
          ),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.35),
                    blurRadius: 15,
                    offset: const Offset(0, 6),
                  ),
                ]
              : [],
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isActive ? Color(0xFF1E3C72) : Colors.white70,
            fontWeight: FontWeight.w700,
            fontSize: 18,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }
}
