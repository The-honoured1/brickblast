import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../../theme/styles.dart';

class LevelsTab extends StatelessWidget {
  const LevelsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('- LEVELS', style: AppStyles.headline.copyWith(fontSize: 32)),
                const Row(
                  children: [
                    Icon(Icons.star, color: AppColors.neonYellow, size: 20),
                    SizedBox(width: 4),
                    Text('47 / 90', style: TextStyle(color: AppColors.neonYellow, fontWeight: FontWeight.bold)),
                  ],
                )
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              children: [
                _buildWorldSection('JUNGLE', '10/10 done', AppColors.neonGreen, 1, 3, true),
                const SizedBox(height: 32),
                _buildWorldSection('SPACE', '4/10 done', AppColors.neonCyan, 11, 14, false),
                const SizedBox(height: 32),
                _buildWorldSection('ICE', 'LOCKED', AppColors.textMuted, 21, 24, false, locked: true),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorldSection(String title, String status, Color color, int startLevel, int endLevel, bool hasBoss, {bool locked = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.eco, color: color), // Placeholder icon
                const SizedBox(width: 8),
                Text(title, style: AppStyles.headline.copyWith(fontSize: 24, color: color)),
              ],
            ),
            Text(status, style: AppStyles.labelText),
          ],
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            for (int i = startLevel; i <= endLevel; i++)
              _buildLevelButton(i.toString(), locked ? 0 : 3, locked),
            if (hasBoss && !locked) _buildBossButton(title == 'JUNGLE' ? 'BOSS\nREX' : 'BOSS\nALIEN', color),
          ],
        )
      ],
    );
  }

  Widget _buildLevelButton(String number, int stars, bool locked) {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        color: AppColors.bottomNavDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: locked ? AppColors.borderNeon : (number == '14' ? AppColors.neonPink : AppColors.neonCyan.withOpacity(0.5)),
          width: 2,
        ),
        boxShadow: number == '14' ? [BoxShadow(color: AppColors.neonPink.withOpacity(0.3), blurRadius: 8)] : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (locked)
            const Icon(Icons.lock, color: AppColors.textMuted)
          else ...[
             Text(number, style: AppStyles.headline.copyWith(fontSize: 28)),
             Row(
               mainAxisAlignment: MainAxisAlignment.center,
               children: List.generate(3, (index) => Icon(
                 Icons.star,
                 size: 10,
                 color: index < stars ? AppColors.neonYellow : AppColors.borderNeon,
               )),
             )
          ]
        ],
      ),
    );
  }

  Widget _buildBossButton(String name, Color color) {
    return Container(
      width: 160,
      height: 72,
      decoration: BoxDecoration(
        color: AppColors.bottomNavDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.neonRed.withOpacity(0.5), width: 2),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.pets, color: AppColors.neonGreen, size: 32),
          const SizedBox(width: 8),
          Text(name, style: AppStyles.headline.copyWith(fontSize: 20, color: AppColors.neonRed)),
        ],
      ),
    );
  }
}
