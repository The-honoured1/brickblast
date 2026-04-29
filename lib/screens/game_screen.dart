import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import '../game/block_blaster_game.dart';
import '../theme/colors.dart';
import '../theme/styles.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late final BlockBlasterGame _game;

  @override
  void initState() {
    super.initState();
    _game = BlockBlasterGame();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Score Header Area
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('SCORE', style: AppStyles.subScoreText),
                      // We can use a ValueListenableBuilder later to react to game score
                      Text('0', style: AppStyles.scoreText),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.pause, color: AppColors.textPrimary, size: 32),
                    onPressed: () {
                      _game.pauseEngine();
                      // Show pause menu (todo)
                    },
                  )
                ],
              ),
            ),
            
            // Flame Game Area
            Expanded(
              child: ClipRect(
                child: GameWidget(
                  game: _game,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
