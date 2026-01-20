import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/block_selection_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const HallWayApp());
}

class HallWayApp extends StatelessWidget {
  const HallWayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HallWay',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFB4FF39), // Neon green accent
          secondary: Color(0xFF7C3AED), // Purple accent
          surface: Color(0xFF1A1625), // Deep dark background
          onPrimary: Color(0xFF0F0B1B), // Text on primary
          onSurface: Color(0xFFFFFFFF),
        ),
        textTheme: GoogleFonts.dmSansTextTheme(ThemeData.dark().textTheme),
        scaffoldBackgroundColor: const Color(0xFF0F0B1B),
        cardTheme: CardThemeData(
          elevation: 0,
          color: const Color(0xFF1A1625).withOpacity(0.6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
      ),
      home: const BlockSelectionScreen(),
    );
  }
}
