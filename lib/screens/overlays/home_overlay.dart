import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../game/block_blaster_game.dart';
import '../../theme/colors.dart';

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
    final isDark = widget.game.gameState.isDarkMode;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background(isDark), 
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
              ),
            ),
            Text(
              'BLASTER',
              style: GoogleFonts.rajdhani(
                fontSize: 72,
                fontWeight: FontWeight.w900,
                color: const Color(0xFFFF2D78),
                letterSpacing: 8,
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
            color: const Color(0xFFFF2D78),
            borderRadius: BorderRadius.circular(12),
            border: const Border(
              bottom: BorderSide(color: Colors.black, width: 4),
              left: BorderSide(color: Colors.black, width: 2),
              right: BorderSide(color: Colors.black, width: 2),
              top: BorderSide(color: Colors.black, width: 2),
            ),
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
    final isDark = widget.game.gameState.isDarkMode;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _menuButton('DAILY\nBLAST', const Color(0xFFFFD600), Icons.flash_on),
        const SizedBox(width: 16),
        _menuButton('LEVELS', const Color(0xFF05D9E8), Icons.grid_view_rounded),
        const SizedBox(width: 16),
        _menuButton('THEME', isDark ? Colors.amber : Colors.indigo, isDark ? Icons.light_mode : Icons.dark_mode, onTap: widget.game.gameState.toggleTheme),
      ],
    );
  }

  Widget _menuButton(String label, Color color, IconData icon, {VoidCallback? onTap}) {
    final isDark = widget.game.gameState.isDarkMode;
    return GestureDetector(
      onTap: onTap ?? () {}, 
      child: Container(
        width: 90,
        height: 90,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF222222) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border(isDark), width: 2),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.1), offset: const Offset(0, 4)),
          ],
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
