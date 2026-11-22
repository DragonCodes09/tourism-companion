import 'package:flutter/material.dart';
import 'screens/auth_landing_screen.dart';
import 'screens/home_screen.dart';
import 'services/database_service.dart';
import 'models/user_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dbService = DatabaseService();
  final currentUser = await dbService.getCurrentUser();

  runApp(TravelSarthiApp(initialUser: currentUser));
}

class TravelSarthiApp extends StatelessWidget {
  final UserModel? initialUser;

  const TravelSarthiApp({super.key, this.initialUser});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Travel Sarthi',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00897B),
          primary: const Color(0xFF00897B),
          secondary: const Color(0xFF00B4DB),
          surface: const Color(0xFFF8FBFB),
        ),
        scaffoldBackgroundColor: const Color(0xFFF8FBFB),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.black87),
          titleTextStyle: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: initialUser != null
          ? HomeScreen(currentUser: initialUser!)
          : const AuthLandingScreen(),
    );
  }
}
