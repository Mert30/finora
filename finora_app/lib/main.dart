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
      theme: AppTheme.lightTheme,
      home: const WelcomePage(), // Temporarily bypass AuthWrapper
      debugShowCheckedModeBanner: false,
    );
  }
}

// Authentication wrapper to check login state
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('🔐 AuthWrapper: Starting auth check...');
    
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        debugPrint('🔐 AuthWrapper: Connection state: ${snapshot.connectionState}');
        debugPrint('🔐 AuthWrapper: Has data: ${snapshot.hasData}');
        debugPrint('🔐 AuthWrapper: Data: ${snapshot.data?.uid}');
        
        // Show loading while checking auth state
        if (snapshot.connectionState == ConnectionState.waiting) {
          debugPrint('🔐 AuthWrapper: Showing auth loading...');
          return const Scaffold(
            backgroundColor: Color(0xFFF8FAFC),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6366F1)),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Giriş durumu kontrol ediliyor...',
                    style: TextStyle(
                      color: Color(0xFF6B7280),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        // User is logged in
        if (snapshot.hasData && snapshot.data != null) {
          debugPrint('🔐 AuthWrapper: User logged in, checking profile...');
          return FutureBuilder<bool>(
            future: _checkUserProfile(snapshot.data!.uid),
            builder: (context, profileSnapshot) {
              debugPrint('🔐 AuthWrapper: Profile check state: ${profileSnapshot.connectionState}');
              debugPrint('🔐 AuthWrapper: Profile exists: ${profileSnapshot.data}');
              
              if (profileSnapshot.connectionState == ConnectionState.waiting) {
                debugPrint('🔐 AuthWrapper: Showing profile loading...');
                return const Scaffold(
                  backgroundColor: Color(0xFFF8FAFC),
                  body: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6366F1)),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Profil bilgileri yükleniyor...',
                          style: TextStyle(
                            color: Color(0xFF6B7280),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              // Handle timeout or error
              if (profileSnapshot.hasError) {
                debugPrint('🔐 AuthWrapper: Profile check error: ${profileSnapshot.error}');
                // On error, go to welcome page
                return const WelcomePage();
              }

              // Profile exists, go to main screen
              if (profileSnapshot.data == true) {
                debugPrint('🔐 AuthWrapper: Profile exists, going to MainScreen');
                return const MainScreen();
              }

              // Profile doesn't exist, sign out and go to welcome
              debugPrint('🔐 AuthWrapper: Profile missing, signing out...');
              WidgetsBinding.instance.addPostFrameCallback((_) {
                FirebaseAuth.instance.signOut();
              });
              return const WelcomePage();
            },
          );
        }

        // User is not logged in
        debugPrint('🔐 AuthWrapper: No user, going to WelcomePage');
        return const WelcomePage();
      },
    );
  }

  Future<bool> _checkUserProfile(String userId) async {
    try {
      debugPrint('🔐 AuthWrapper: Checking profile for user: $userId');
      
      // Add timeout to prevent infinite loading
      final userProfile = await UserService.getUserProfile(userId)
          .timeout(const Duration(seconds: 10));
      
      final exists = userProfile != null;
      debugPrint('🔐 AuthWrapper: Profile check result: $exists');
      return exists;
    } catch (e) {
      debugPrint('🔐 AuthWrapper: Error checking user profile: $e');
      return false;
    }
  }
}
