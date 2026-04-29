import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../../theme/styles.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back_ios, color: AppColors.textWhite),
                  ),
                  const SizedBox(width: 16),
                  Text('SETTINGS', style: AppStyles.headline.copyWith(fontSize: 32)),
                ],
              ),
            ),
            
            // Profile Card
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.bottomNavDark,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.borderNeon),
              ),
              child: Row(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: AppColors.neonPink,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    alignment: Alignment.center,
                    child: Text('CB', style: AppStyles.headline.copyWith(fontSize: 32)),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('ChrisBlast', style: AppStyles.headline.copyWith(fontSize: 24)),
                        Row(
                          children: [
                            const Icon(Icons.bolt, color: AppColors.neonYellow, size: 16),
                            Text(' LEVEL 14 - NOVA RANK', style: AppStyles.labelText.copyWith(color: AppColors.neonYellow, fontSize: 12)),
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.textMuted),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text('EDIT', style: AppStyles.labelText),
                  )
                ],
              ),
            ),

            const SizedBox(height: 32),
            
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                children: [
                  Text('AUDIO', style: AppStyles.labelText),
                  const SizedBox(height: 16),
                  _buildToggleRow('Sound FX', 'Brick hits, combos', Icons.volume_up, true),
                  _buildToggleRow('Music', 'Background tracks', Icons.music_note, true),
                  _buildToggleRow('Haptics', 'Vibration feedback', Icons.vibration, true),
                  
                  const SizedBox(height: 32),
                  Text('GAMEPLAY', style: AppStyles.labelText),
                  const SizedBox(height: 16),
                  _buildDropdownRow('Control mode', 'Drag or tilt', Icons.gamepad, 'DRAG >'),
                  _buildToggleRow('Show hints', 'Trajectory guide', Icons.lightbulb, false),
                  _buildDropdownRow('Difficulty', '', Icons.bolt, 'NORMAL >'),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildToggleRow(String title, String subtitle, IconData icon, bool value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.bottomNavDark,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppColors.textMuted),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: AppColors.textWhite, fontSize: 16, fontWeight: FontWeight.bold)),
                if (subtitle.isNotEmpty) Text(subtitle, style: AppStyles.labelText.copyWith(fontSize: 12)),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: (_) {},
            activeColor: AppColors.neonPink,
            activeTrackColor: AppColors.neonPink.withOpacity(0.3),
            inactiveThumbColor: AppColors.textWhite,
            inactiveTrackColor: AppColors.borderNeon,
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownRow(String title, String subtitle, IconData icon, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.bottomNavDark,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppColors.textMuted),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: AppColors.textWhite, fontSize: 16, fontWeight: FontWeight.bold)),
                if (subtitle.isNotEmpty) Text(subtitle, style: AppStyles.labelText.copyWith(fontSize: 12)),
              ],
            ),
          ),
          Text(value, style: AppStyles.labelText),
        ],
      ),
    );
  }
}
