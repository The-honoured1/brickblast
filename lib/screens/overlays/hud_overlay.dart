import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../game/block_blaster_game.dart';
import '../../game/game_state.dart';
import '../../theme/game_effects.dart';

class HudOverlay extends StatelessWidget {
  final BlockBlasterGame game;
  const HudOverlay({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: game.gameState,
      child: Consumer<GameState>(
        builder: (_, state, __) => Stack(
          children: [
            // Top: Score + Level (left) | Lives (right)
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildScoreBlock(state),
                  _buildLives(state),
                ],
              ),
            ),
            // Combo indicator (floats above center)
            if (state.combo >= 2)
              Positioned(
                bottom: 220,
                left: 0,
                right: 0,
                child: _buildCombo(state),
              ),
            // Powerup arc timer around lower-center
            if (state.activePowerup != null)
              Positioned(
                bottom: 130,
                left: 0,
                right: 0,
                child: _buildPowerupTimer(state),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreBlock(GameState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'SCORE',
          style: GoogleFonts.rajdhani(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Colors.white38,
            letterSpacing: 2,
          ),
        ),
        Text(
          '${state.score}',
          style: GoogleFonts.rajdhani(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
        Text(
          'LEVEL ${state.currentLevel}',
          style: GoogleFonts.rajdhani(
            fontSize: 11,
            color: const Color(0xFF05D9E8),
            letterSpacing: 2,
          ),
        ),
      ],
    );
  }

  Widget _buildLives(GameState state) {
    return Row(
      children: List.generate(3, (i) {
        final active = i < state.lives;
        return Padding(
          padding: const EdgeInsets.only(left: 6),
          child: AnimatedOpacity(
            opacity: active ? 1.0 : 0.2,
            duration: const Duration(milliseconds: 300),
            child: Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: active ? const Color(0xFFFF2D78) : Colors.white24,
                boxShadow: active
                    ? [BoxShadow(color: const Color(0xFFFF2D78).withOpacity(0.7), blurRadius: 8)]
                    : null,
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildCombo(GameState state) {
    return Center(
      child: AnimatedDefaultTextStyle(
        duration: const Duration(milliseconds: 200),
        style: GoogleFonts.rajdhani(
          fontSize: 32 + (state.combo * 0.5).clamp(0, 12),
          fontWeight: FontWeight.w900,
          color: GameEffects.comboColor(state.combo),
          shadows: [
            Shadow(
              color: GameEffects.comboColor(state.combo).withOpacity(0.7),
              blurRadius: 16,
            ),
          ],
        ),
        child: Text('x${state.combo}'),
      ),
    );
  }

  Widget _buildPowerupTimer(GameState state) {
    final powerup = state.activePowerup!;
    final fraction = (state.powerupTimeRemaining / powerup.durationSeconds).clamp(0.0, 1.0);

    return Center(
      child: Column(
        children: [
          SizedBox(
            width: 48,
            height: 48,
            child: CustomPaint(
              painter: _ArcTimerPainter(
                fraction: fraction.toDouble(),
                color: powerup.color,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            state.powerupTimeRemaining.toStringAsFixed(1) + 's',
            style: GoogleFonts.rajdhani(
              fontSize: 11,
              color: powerup.color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _ArcTimerPainter extends CustomPainter {
  final double fraction;
  final Color color;
  _ArcTimerPainter({required this.fraction, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 4;

    // Background ring
    canvas.drawCircle(center, radius,
        Paint()
          ..color = color.withOpacity(0.15)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4);

    // Shrinking arc
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      2 * pi * fraction,
      false,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_ArcTimerPainter old) => old.fraction != fraction;
}
