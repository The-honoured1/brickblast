import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../game/block_blaster_game.dart';

class LevelCompleteOverlay extends StatefulWidget {
  final BlockBlasterGame game;
  const LevelCompleteOverlay({super.key, required this.game});

  @override
  State<LevelCompleteOverlay> createState() => _LevelCompleteOverlayState();
}

class _LevelCompleteOverlayState extends State<LevelCompleteOverlay>
    with TickerProviderStateMixin {
  late AnimationController _starsCtrl;
  late AnimationController _scoreCtrl;
  late AnimationController _slideCtrl;

  late List<Animation<double>> _starAnims;
  late Animation<double> _slide;

  int _displayedScore = 0;
  int _targetScore = 0;

  @override
  void initState() {
    super.initState();
    _targetScore = widget.game.gameState.score;

    _starsCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _scoreCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _slideCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _starAnims = List.generate(3, (i) {
      final start = i * 0.25;
      return Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _starsCtrl,
          curve: Interval(start, start + 0.4, curve: Curves.elasticOut),
        ),
      );
    });

    _slide = Tween<double>(begin: 80, end: 0).animate(
      CurvedAnimation(parent: _slideCtrl, curve: Curves.easeOut),
    );

    // Sequence: stars → score count → button slide
    _starsCtrl.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _scoreCtrl.forward();
        _scoreCtrl.addListener(() {
          setState(() {
            _displayedScore = (_scoreCtrl.value * _targetScore).toInt();
          });
        });
        _scoreCtrl.addStatusListener((s2) {
          if (s2 == AnimationStatus.completed) _slideCtrl.forward();
        });
      }
    });
    _starsCtrl.forward();
  }

  @override
  void dispose() {
    _starsCtrl.dispose();
    _scoreCtrl.dispose();
    _slideCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black87,
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'LEVEL CLEAR!',
              style: GoogleFonts.rajdhani(
                fontSize: 48,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: 4,
              ),
            ),
            const SizedBox(height: 24),
            // Stars
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (i) {
                final stars = widget.game.gameState.score > 500 ? 3 : 2;
                return AnimatedBuilder(
                  animation: _starAnims[i],
                  builder: (_, __) => Transform.scale(
                    scale: _starAnims[i].value,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Icon(
                        Icons.star_rounded,
                        size: 56,
                        color: i < stars ? const Color(0xFFFFD600) : Colors.white12,
                        shadows: i < stars
                            ? [const Shadow(color: Color(0xFFFFD600), blurRadius: 20)]
                            : null,
                      ),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 32),
            // Score
            Text(
              '$_displayedScore',
              style: GoogleFonts.rajdhani(
                fontSize: 56,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
            Text(
              'SCORE',
              style: GoogleFonts.rajdhani(
                fontSize: 16,
                color: Colors.white38,
                letterSpacing: 4,
              ),
            ),
            const SizedBox(height: 48),
            // Next Level button slides up
            AnimatedBuilder(
              animation: _slide,
              builder: (_, child) => Transform.translate(
                offset: Offset(0, _slide.value),
                child: Opacity(
                  opacity: _slideCtrl.value,
                  child: child,
                ),
              ),
              child: GestureDetector(
                onTap: _nextLevel,
                child: Container(
                  width: 220,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF05D9E8), Color(0xFF00B0C8)],
                    ),
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF05D9E8).withOpacity(0.5),
                        blurRadius: 20,
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'NEXT LEVEL →',
                    style: GoogleFonts.rajdhani(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: Colors.black,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _nextLevel() {
    widget.game.gameState.nextLevel();
    widget.game.overlays.remove('LevelCompleteOverlay');
    widget.game.overlays.add('HudOverlay');
    widget.game.loadLevel(widget.game.gameState.currentLevel);
    widget.game.resumeEngine();
  }
}
