import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../game/block_blaster_game.dart';
import '../game/game_state.dart';
import '../theme/colors.dart';
import '../theme/styles.dart';
import 'overlays/level_complete_overlay.dart';
import 'overlays/game_over_overlay.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late final GameState _gameState;
  late final BlockBlasterGame _game;

  @override
  void initState() {
    super.initState();
    _gameState = GameState();
    _game = BlockBlasterGame(_gameState);
    
    // We don't pause because we jump right into playing on load 
    // unless we need a "ready" countdown. For now, immediate start!
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _gameState,
      child: Scaffold(
        backgroundColor: AppColors.backgroundDark,
        body: SafeArea(
          child: Column(
            children: [
              _buildTopHUD(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.borderNeon, width: 2),
                      ),
                      child: GameWidget<BlockBlasterGame>(
                        game: _game,
                        overlayBuilderMap: {
                          'LevelCompleteOverlay': (_, game) => LevelCompleteOverlay(game: game),
                          'GameOverOverlay': (_, game) => GameOverOverlay(game: game),
                        },
                      ),
                    ),
                  ),
                ),
              ),
              _buildBottomActions(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopHUD() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Consumer<GameState>(
        builder: (context, state, child) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('SCORE', style: AppStyles.labelText.copyWith(fontSize: 14)),
                  Text(
                    '${state.score}',
                    style: AppStyles.scoreText.copyWith(color: AppColors.neonPink, fontSize: 36, height: 1),
                  ),
                ],
              ),
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.neonCyan.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.neonCyan, width: 2),
                    ),
                    child: Text('LVL ${state.currentLevel}', style: AppStyles.labelText.copyWith(color: AppColors.neonCyan)),
                  ),
                  if (state.combo > 1)
                    Text('x${state.combo} COMBO', style: AppStyles.labelText.copyWith(color: AppColors.neonYellow, fontSize: 12)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('LIVES', style: AppStyles.labelText.copyWith(fontSize: 14)),
                  Row(
                    children: List.generate(3, (index) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 4.0),
                        child: Icon(
                          Icons.favorite,
                          color: index < state.lives ? AppColors.neonRed : AppColors.borderNeon,
                          size: 16,
                        ),
                      );
                    }),
                  )
                ],
              )
            ],
          );
        },
      ),
    );
  }

  Widget _buildBottomActions() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _actionButton('PAUSE', Icons.pause_circle_filled, () {
            if (_game.paused) {
              _game.resumeEngine();
            } else {
              _game.pauseEngine();
            }
          }),
          _actionButton('SWAP', Icons.swap_horiz, () {}),
          _actionButton('HINT', Icons.lightbulb, () {}, color: AppColors.neonYellow),
        ],
      ),
    );
  }

  Widget _actionButton(String label, IconData icon, VoidCallback onTap, {Color? color}) {
    final activeColor = color ?? AppColors.textMuted;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.bottomNavDark,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.borderNeon, width: 2),
        ),
        child: Row(
          children: [
            Icon(icon, color: activeColor, size: 20),
            const SizedBox(width: 8),
            Text(label, style: AppStyles.labelText.copyWith(color: activeColor)),
          ],
        ),
      ),
    );
  }
}
