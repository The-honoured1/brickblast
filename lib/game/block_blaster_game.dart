import 'package:flame/game.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:flame/camera.dart';
import 'package:flame/effects.dart';
import 'package:flame/components.dart';
import 'dart:math';

import 'components/paddle.dart';
import 'components/ball.dart';
import 'components/brick.dart';
import 'game_state.dart';
import '../models/level_data.dart';
import '../models/brick_type.dart';

class BlockBlasterGame extends FlameGame with HasCollisionDetection {
  final GameState gameState;
  late Paddle paddle;
  late Ball ball;
  
  BlockBlasterGame(this.gameState);

  @override
  Future<void> onLoad() async {
    super.onLoad();
    
    // Setup camera for shaking
    camera = CameraComponent.withFixedResolution(
      width: size.x,
      height: size.y,
    );
    camera.viewfinder.anchor = Anchor.topLeft;

    // Load level
    loadLevel(1);
    
    // Add player components
    paddle = Paddle(size: Vector2(100, 16));
    world.add(paddle);
    
    ball = Ball(radius: 8);
    world.add(ball);
  }

  void loadLevel(int levelIndex) {
    // Clear old bricks
    world.children.whereType<Brick>().forEach((b) => b.removeFromParent());
    
    final padding = 10.0;
    final cols = 6;
    final rows = 4;
    final brickWidth = (size.x - (padding * (cols + 1))) / cols;
    final brickHeight = 24.0;
    
    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < cols; col++) {
        final pos = Vector2(
          padding + (brickWidth / 2) + col * (brickWidth + padding),
          100.0 + row * (brickHeight + padding)
        );
        
        // Randomly assign some tough or explosive bricks for testing
        BrickType type = BrickType.normal;
        if (row == 0) type = BrickType.tough;
        if (col == 2 && row == 2) type = BrickType.explosive;
        
        world.add(Brick(
          position: pos,
          size: Vector2(brickWidth, brickHeight),
          type: type,
        ));
      }
    }
  }

  void shake(double intensity, double duration) {
    camera.viewfinder.add(
      MoveEffect.by(
        Vector2(intensity, intensity),
        EffectController(
          duration: duration / 4,
          reverseDuration: duration / 4,
          repeatCount: 2,
        ),
      ),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    gameState.updatePowerupTime(dt);

    if (gameState.lives <= 0 && overlays.isActive('GameOverlay')) {
      overlays.remove('GameOverlay');
      overlays.add('GameOverOverlay');
    }
  }

  @override
  Color backgroundColor() {
    // Dynamic background based on combo
    double warmth = (gameState.combo / 20).clamp(0.0, 1.0);
    return Color.lerp(const Color(0xFF0F0F0F), const Color(0xFF3B0918), warmth)!;
  }
}
