import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../game/block_blaster_game.dart';
import '../../theme/colors.dart';

class GameOverOverlay extends StatefulWidget {
  final BlockBlasterGame game;
  const GameOverOverlay({super.key, required this.game});

  @override
  State<GameOverOverlay> createState() => _GameOverOverlayState();
}

class _GameOverOverlayState extends State<GameOverOverlay>
    with TickerProviderStateMixin {
  late AnimationController _crackCtrl;

  @override
  void initState() {
    super.initState();
    _crackCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
  }

  @override
  void dispose() {
    _crackCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final score = widget.game.gameState.score;
    final hi = widget.game.gameState.highScore;
    final isHighScore = score >= hi && score > 0;
    final isDark = widget.game.gameState.isDarkMode;

    return AnimatedBuilder(
      animation: _crackCtrl,
      builder: (_, __) {
        return Stack(
          children: [
            // Background overlay that responds to theme
            Container(
              color: AppColors.background(isDark).withOpacity(_crackCtrl.value * 0.95),
            ),
            // Crack lines drawn over the screen
            CustomPaint(
              painter: _CrackPainter(progress: _crackCtrl.value),
              size: MediaQuery.of(context).size,
            ),
            // Content
            SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                child: Center(
                  child: Opacity(
                    opacity: _crackCtrl.value,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                      Text(
                        'GAME OVER',
                        style: GoogleFonts.rajdhani(
                          fontSize: 52,
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFFFF2D78),
                          letterSpacing: 4,
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (isHighScore) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFD600).withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: const Color(0xFFFFD600), width: 1),
                          ),
                          child: Text(
                            '★ NEW BEST',
                            style: GoogleFonts.rajdhani(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFFFFD600),
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                      Text(
                        '$score',
                        style: GoogleFonts.rajdhani(
                          fontSize: 64,
                          fontWeight: FontWeight.w900,
                          color: AppColors.textPrimary(isDark),
                        ),
                      ),
                      Text(
                        'SCORE',
                        style: GoogleFonts.rajdhani(
                          fontSize: 14,
                          color: isDark ? Colors.white38 : Colors.black38,
                          letterSpacing: 4,
                        ),
                      ),
                      const SizedBox(height: 48),
                      // Try Again
                      GestureDetector(
                        onTap: _tryAgain,
                        child: Container(
                          width: 220,
                          height: 56,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF2D78),
                            borderRadius: BorderRadius.circular(12),
                            border: const Border(
                              bottom: BorderSide(color: Colors.black, width: 4),
                              top: BorderSide(color: Colors.black, width: 2),
                              left: BorderSide(color: Colors.black, width: 2),
                              right: BorderSide(color: Colors.black, width: 2),
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'TRY AGAIN',
                            style: GoogleFonts.rajdhani(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Home
                      GestureDetector(
                        onTap: _home,
                        child: Text(
                          'HOME',
                          style: GoogleFonts.rajdhani(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: isDark ? Colors.white38 : Colors.black38,
                            letterSpacing: 3,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _tryAgain() {
    widget.game.gameState.resetGame();
    widget.game.resetLevel();
  }

  void _home() {
    widget.game.gameState.resetGame();
    widget.game.overlays.remove('GameOverOverlay');
    widget.game.overlays.add('HomeOverlay');
    widget.game.pauseEngine();
  }
}

class _CrackPainter extends CustomPainter {
  final double progress;
  _CrackPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(progress * 0.15)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Static crack lines branching from bottom-center
    final paths = [
      [
        Offset(size.width * 0.5, size.height),
        Offset(size.width * 0.35, size.height * 0.6),
        Offset(size.width * 0.2, size.height * 0.4),
      ],
      [
        Offset(size.width * 0.5, size.height),
        Offset(size.width * 0.6, size.height * 0.55),
        Offset(size.width * 0.75, size.height * 0.3),
      ],
      [
        Offset(size.width * 0.5, size.height),
        Offset(size.width * 0.45, size.height * 0.7),
        Offset(size.width * 0.55, size.height * 0.4),
        Offset(size.width * 0.4, size.height * 0.1),
      ],
    ];

    for (final pts in paths) {
      final path = Path()..moveTo(pts[0].dx, pts[0].dy);
      for (int i = 1; i < pts.length; i++) {
        path.lineTo(pts[i].dx, pts[i].dy);
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(_CrackPainter old) => old.progress != progress;
}
