import 'package:flame/game.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'components/paddle.dart';
import 'components/ball.dart';
import 'components/brick.dart';

class BlockBlasterGame extends FlameGame with HasCollisionDetection {
  BlockBlasterGame();

  // Score and other local state
  int score = 0;
  int lives = 3;
  int combo = 0;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    
    // Setup Paddle
    final paddle = Paddle(size: Vector2(100, 16));
    add(paddle);
    
    // Setup Ball
    final ball = Ball(radius: 8);
    add(ball);
    
    // Setup a basic row of bricks for testing
    _buildTestLevel();
  }
  
  void _buildTestLevel() {
    final padding = 10.0;
    final brickWidth = (size.x - (padding * 7)) / 6; // 6 columns
    final brickHeight = 24.0;
    
    for (int row = 0; row < 4; row++) {
      for (int col = 0; col < 6; col++) {
        final pos = Vector2(
          padding + (brickWidth / 2) + col * (brickWidth + padding),
          100.0 + row * (brickHeight + padding)
        );
        add(Brick(
          position: pos,
          size: Vector2(brickWidth, brickHeight),
          color: const Color(0xFF05D9E8),
        ));
      }
    }
  }

  @override
  Color backgroundColor() => const Color(0xFF0F0F0F); // Matching the background
}
