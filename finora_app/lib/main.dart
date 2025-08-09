import 'package:finora_app/features/welcome/presentation/pages/welcome_page.dart';
import 'package:finora_app/features/main_screen/presentation/pages/main_screen.dart';
import 'package:finora_app/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '/core/services/firebase_service.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Finora',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const AuthWrapper(),
    );
  }
}

// Authentication wrapper to check login state
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Show loading while checking auth state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Color(0xFFF8FAFC),
            body: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6366F1)),
              ),
            ),
          );
        }
        
        // User is logged in
        if (snapshot.hasData && snapshot.data != null) {
          return FutureBuilder<bool>(
            future: _checkUserProfile(snapshot.data!.uid),
            builder: (context, profileSnapshot) {
              if (profileSnapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  backgroundColor: Color(0xFFF8FAFC),
                  body: Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6366F1)),
                    ),
                  ),
                );
              }
              
              // Profile exists, go to main screen
              if (profileSnapshot.data == true) {
                return const MainScreen();
              }
              
              // Profile doesn't exist, sign out and go to welcome
              FirebaseAuth.instance.signOut();
              return const WelcomePage();
            },
          );
        }
        
        // User is not logged in
        return const WelcomePage();
      },
    );
  }

  Future<bool> _checkUserProfile(String userId) async {
    try {
      final userProfile = await UserService.getUserProfile(userId);
      return userProfile != null;
    } catch (e) {
      debugPrint('Error checking user profile: $e');
      return false;
    }
  }
}
