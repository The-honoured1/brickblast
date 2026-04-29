import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../game/block_blaster_game.dart';

class HomeOverlay extends StatefulWidget {
  final BlockBlasterGame game;
  const HomeOverlay({super.key, required this.game});

  @override
  State<HomeOverlay> createState() => _HomeOverlayState();
}

class _HomeOverlayState extends State<HomeOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseCtrl;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF120A1E), Color(0xFF0D1B2A)],
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 2),
            // Wordmark
            _buildWordmark(),
            const Spacer(flex: 1),
            // Play button
            _buildPlayButton(),
            const SizedBox(height: 32),
            // Secondary options
            _buildMenuButtons(),
            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }

  Widget _buildWordmark() {
    return AnimatedBuilder(
      animation: _pulseAnim,
      builder: (_, __) => Transform.scale(
        scale: _pulseAnim.value,
        child: Column(
          children: [
            Text(
              'BLOCK',
              style: GoogleFonts.rajdhani(
                fontSize: 72,
                fontWeight: FontWeight.w900,
                color: const Color(0xFF05D9E8),
                letterSpacing: 8,
                shadows: [
                  const Shadow(color: Color(0xFF05D9E8), blurRadius: 24),
                  const Shadow(color: Color(0xFF05D9E8), blurRadius: 48),
                ],
              ),
            ),
            Text(
              'BLASTER',
              style: GoogleFonts.rajdhani(
                fontSize: 72,
                fontWeight: FontWeight.w900,
                color: const Color(0xFFFF2D78),
                letterSpacing: 8,
                shadows: [
                  const Shadow(color: Color(0xFFFF2D78), blurRadius: 24),
                  const Shadow(color: Color(0xFFFF2D78), blurRadius: 48),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayButton() {
    return ScaleTransition(
      scale: _pulseAnim,
      child: GestureDetector(
        onTap: _startGame,
        child: Container(
          width: 200,
          height: 60,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFF2D78), Color(0xFFFF7043)],
            ),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFF2D78).withOpacity(0.6),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            'PLAY',
            style: GoogleFonts.rajdhani(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: 4,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _menuButton('DAILY\nBLAST', const Color(0xFFFFD600), Icons.flash_on),
        const SizedBox(width: 16),
        _menuButton('LEVELS', const Color(0xFF05D9E8), Icons.grid_view_rounded),
        const SizedBox(width: 16),
        _menuButton('SHOP', const Color(0xFF00E676), Icons.shopping_bag_rounded),
      ],
    );
  }

  Widget _menuButton(String label, Color color, IconData icon) {
    return GestureDetector(
      onTap: () {}, // TODO: navigate to section
      child: Container(
        width: 90,
        height: 90,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.5), width: 1.5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 6),
            Text(
              label,
              textAlign: TextAlign.center,
              style: GoogleFonts.rajdhani(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: color,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _startGame() {
    widget.game.overlays.remove('HomeOverlay');
    widget.game.overlays.add('HudOverlay');
    widget.game.resumeEngine();
  }
}
