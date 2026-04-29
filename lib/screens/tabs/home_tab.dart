import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/colors.dart';
import '../../theme/styles.dart';
import '../game_screen.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          // Title
          Text(
            'BLOCK\nBLASTER',
            textAlign: TextAlign.center,
            style: AppStyles.headline.copyWith(
              height: 0.9,
              fontSize: 72,
              shadows: [
                Shadow(color: AppColors.neonPink.withOpacity(0.5), blurRadius: 20),
              ],
            ),
          ),
          Text(
            'ARCADE EDITION',
            style: GoogleFonts.teko(
              fontSize: 24,
              color: AppColors.neonPink,
              letterSpacing: 4,
            ),
          ),
          const SizedBox(height: 32),
          // Today's Challenge Card
          _buildChallengeCard(),
          const SizedBox(height: 32),
          // Play Now Button
          _buildPlayButton(context),
          const SizedBox(height: 24),
          // Quick mode actions
          _buildQuickActions(),
          const Spacer(),
          _buildStreak(),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildChallengeCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.neonCyan, width: 2),
        boxShadow: [
          BoxShadow(
            color: AppColors.neonCyan.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('TODAY\'S CHALLENGE', style: AppStyles.labelText.copyWith(color: AppColors.neonCyan)),
          const SizedBox(height: 4),
          Text('NOVA RUSH', style: AppStyles.headline.copyWith(fontSize: 32)),
          Text('Space World - Level 14 - ★★★', style: AppStyles.labelText),
        ],
      ),
    );
  }

  Widget _buildPlayButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
         Navigator.push(context, MaterialPageRoute(builder: (_) => const GameScreen()));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        height: 72,
        decoration: BoxDecoration(
          color: AppColors.neonPink,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.neonPink.withOpacity(0.5),
              blurRadius: 15,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 40),
            const SizedBox(width: 8),
            Text('PLAY NOW', style: AppStyles.buttonText.copyWith(fontSize: 36)),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _quickActionBtn(Icons.bolt, 'ARCADE', AppColors.neonYellow),
        _quickActionBtn(Icons.smart_toy_rounded, 'VS CPU', AppColors.textMuted),
        _quickActionBtn(Icons.emoji_events_rounded, 'RANKED', AppColors.textMuted),
      ],
    );
  }

  Widget _quickActionBtn(IconData icon, String label, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.bottomNavDark,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.borderNeon, width: 2),
          ),
          child: Icon(icon, color: color, size: 32),
        ),
        const SizedBox(height: 8),
        Text(label, style: AppStyles.labelText.copyWith(fontSize: 14)),
      ],
    );
  }

  Widget _buildStreak() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text('7-DAY STREAK', style: AppStyles.labelText),
            const Row(
              children: [
                Icon(Icons.local_fire_department, color: AppColors.neonRed, size: 16),
                Text(' 7', style: TextStyle(color: AppColors.neonRed, fontWeight: FontWeight.bold)),
              ],
            )
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(7, (index) => Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: 32,
            height: 6,
            decoration: BoxDecoration(
              color: AppColors.neonPink,
              borderRadius: BorderRadius.circular(4),
              boxShadow: [
                BoxShadow(color: AppColors.neonPink.withOpacity(0.5), blurRadius: 4),
              ],
            ),
          )),
        )
      ],
    );
  }
}
