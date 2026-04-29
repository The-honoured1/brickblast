import 'package:flutter/material.dart';
import '../../game/block_blaster_game.dart';
import '../../theme/colors.dart';
import '../../theme/styles.dart';

class LevelCompleteOverlay extends StatelessWidget {
  final BlockBlasterGame game;
  const LevelCompleteOverlay({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black87,
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.backgroundDark,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.borderNeon, width: 2),
            boxShadow: [
              BoxShadow(color: AppColors.neonCyan.withOpacity(0.1), blurRadius: 20),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'LEVEL ${game.gameState.currentLevel} COMPLETE',
                style: AppStyles.labelText.copyWith(color: AppColors.textWhite),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.star, color: AppColors.neonYellow, size: 16),
                  const SizedBox(width: 8),
                  Text('NEW HIGH SCORE', style: AppStyles.labelText.copyWith(color: AppColors.neonYellow)),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                '14,820', // Harcoded for mockup feel, in real app uses game.gameState.score
                style: AppStyles.scoreText.copyWith(fontSize: 72, height: 1),
              ),
              Text('POINTS', style: AppStyles.labelText),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.star, color: AppColors.neonYellow, size: 48),
                  const SizedBox(width: 8),
                  const Icon(Icons.star, color: AppColors.neonYellow, size: 48),
                  const SizedBox(width: 8),
                  Icon(Icons.star, color: AppColors.borderNeon.withOpacity(0.5), size: 48),
                ],
              ),
              const SizedBox(height: 32),
              _buildStatRow('BRICKS CLEARED', '84 / 86', Colors.white),
              _buildStatRow('BEST COMBO', 'x8 🔥', AppColors.neonYellow),
              _buildStatRow('POWER-UPS CAUGHT', '6', Colors.white),
              _buildStatRow('BALLS LOST', '1', AppColors.neonRed),
              _buildStatRow('TIME', '2:34', Colors.white),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        // Return to menu
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        height: 56,
                        decoration: BoxDecoration(
                          color: AppColors.bottomNavDark,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.borderNeon),
                        ),
                        alignment: Alignment.center,
                        child: Text('MENU', style: AppStyles.buttonText.copyWith(fontSize: 24)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: GestureDetector(
                      onTap: () {
                        game.resetLevel();
                      },
                      child: Container(
                        height: 56,
                        decoration: BoxDecoration(
                          color: AppColors.neonPink,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(color: AppColors.neonPink.withOpacity(0.4), blurRadius: 8),
                          ]
                        ),
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('NEXT', style: AppStyles.buttonText.copyWith(fontSize: 24)),
                            const Icon(Icons.play_arrow, color: Colors.white),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value, Color valueColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppStyles.labelText.copyWith(fontSize: 14)),
          Text(value, style: AppStyles.labelText.copyWith(fontSize: 16, color: valueColor, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
