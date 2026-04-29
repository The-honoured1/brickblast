import 'package:flutter/material.dart';
import 'screens/game_screen.dart';

void main() {
  runApp(const BrickBlastApp());
}

class BrickBlastApp extends StatelessWidget {
  const BrickBlastApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Block Blast',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Roboto', // Default fallback, but could be customized
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF05D9E8),
          surface: Color(0xFF0F0F0F),
        ),
        useMaterial3: true,
      ),
      home: const GameScreen(),
    );
  }
}
