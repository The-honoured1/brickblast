import 'package:flutter/material.dart';
import '../models/powerup_type.dart';

/// Centralised "Juice" helpers — colours, flashes, and heat effects.
class GameEffects {
  // Background heat — interpolates from cool dark to volcanic warm as combo rises
  static Color backgroundForCombo(int combo) {
    final t = (combo / 20.0).clamp(0.0, 1.0);
    return Color.lerp(const Color(0xFF0F0F0F), const Color(0xFF2D0A18), t)!;
  }

  // HUD combo colour heat progression
  static Color comboColor(int combo) {
    if (combo >= 10) return const Color(0xFFFF1744);
    if (combo >= 5) return const Color(0xFFFF9100);
    if (combo >= 2) return const Color(0xFFFFD600);
    return Colors.white;
  }

  // Glow colour for the paddle based on the active powerup
  static Color paddleGlow(PowerupType? type) {
    if (type == null) return const Color(0xFF05D9E8);
    return type.color;
  }

  // Star rating based on whether the player missed any ball drops
  static int starRating({required bool noMiss, required int score, required int target}) {
    if (noMiss && score >= target) return 3;
    if (noMiss || score >= target) return 2;
    return 1;
  }
}

/// Fullscreen flash overlay used for screen-flash juice effects.
class ScreenFlash extends StatefulWidget {
  final Color color;
  final Duration duration;
  const ScreenFlash({super.key, required this.color, required this.duration});

  @override
  State<ScreenFlash> createState() => _ScreenFlashState();
}

class _ScreenFlashState extends State<ScreenFlash>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: widget.duration)..forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) => IgnorePointer(
        child: Container(
          // Simplified to a more solid pop
          color: widget.color.withOpacity((1 - _ctrl.value) * 0.45),
        ),
      ),
    );
  }
}
