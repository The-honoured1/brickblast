import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../game/block_blaster_game.dart';
import '../game/game_state.dart';
import 'overlays/home_overlay.dart';
import 'overlays/hud_overlay.dart';
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
    // Start paused on the home screen
    _game.pauseEngine();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _gameState,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: GameWidget<BlockBlasterGame>(
          game: _game,
          overlayBuilderMap: {
            'HomeOverlay': (_, game) => HomeOverlay(game: game),
            'HudOverlay': (_, game) => HudOverlay(game: game),
            'LevelCompleteOverlay': (_, game) => LevelCompleteOverlay(game: game),
            'GameOverOverlay': (_, game) => GameOverOverlay(game: game),
          },
          initialActiveOverlays: const ['HomeOverlay'],
        ),
      ),
    );
  }
}
