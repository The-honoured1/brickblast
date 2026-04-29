import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../block_blaster_game.dart';

class Brick extends PositionComponent with HasGameRef<BlockBlasterGame> {
  int health;
  int pointValue;
  final Color color;

  Brick({
    required Vector2 position,
    required Vector2 size,
    this.health = 1,
    this.pointValue = 10,
    this.color = const Color(0xFFE2B714),
  }) : super(position: position, size: size);

  @override
  Future<void> onLoad() async {
    super.onLoad();
    anchor = Anchor.center;
    add(RectangleHitbox());
  }

  @override
  void render(Canvas canvas) {
    final RRect rrect = RRect.fromRectAndRadius(
      size.toRect(),
      const Radius.circular(4),
    );
    canvas.drawRRect(rrect, Paint()..color = color);
    
    // Add brief shine or texture if desired later
  }

  void hit() {
    health--;
    
    // Juice: small micro-shake or particle emission on hit (to be implemented)
    
    if (health <= 0) {
      destroy();
    }
  }

  void destroy() {
    // Increase combo and score
    gameRef.combo++;
    // Simple multiplier logic: base point * clamp(combo, 1, 10)
    gameRef.score += pointValue * gameRef.combo.clamp(1, 10);
    
    // Juice: Particles and explosive sound
    removeFromParent();
  }
}
