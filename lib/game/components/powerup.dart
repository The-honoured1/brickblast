import 'dart:math';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../block_blaster_game.dart';
import 'paddle.dart';
import '../../models/powerup_type.dart';

class Powerup extends PositionComponent
    with HasGameRef<BlockBlasterGame>, CollisionCallbacks {
  final PowerupType type;
  double _time = 0;
  final double _fallSpeed = 120.0;
  final double _wobbleAmplitude = 18.0;
  final double _wobbleFrequency = 2.0;
  final double _startX;

  Powerup({required Vector2 position, required this.type})
      : _startX = position.x,
        super(position: position, size: Vector2(24, 24));

  @override
  Future<void> onLoad() async {
    super.onLoad();
    anchor = Anchor.center;
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    _time += dt;

    // Wobble horizontally while falling
    position.x = _startX + sin(_time * _wobbleFrequency * pi * 2) * _wobbleAmplitude;
    position.y += _fallSpeed * dt;

    // Remove if outside screen
    if (position.y > gameRef.size.y + 30) {
      removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    final isPositive = type.category == PowerupCategory.positive;

    // Draw pill shape
    final bgPaint = Paint()..color = type.color;
    final rrect = RRect.fromRectAndRadius(size.toRect(), const Radius.circular(6));
    canvas.drawRRect(rrect, bgPaint);

    // Draw border glow ring
    final ringPaint = Paint()
      ..color = Colors.white.withOpacity(0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawRRect(rrect, ringPaint);

    // Draw icon symbol
    final textPainter = TextPainter(
      text: TextSpan(
        text: _iconForType(),
        style: TextStyle(
          fontSize: 12,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset((size.x - textPainter.width) / 2, (size.y - textPainter.height) / 2),
    );
  }

  String _iconForType() {
    switch (type) {
      case PowerupType.widePaddle:   return '↔';
      case PowerupType.slowBall:     return '∿';
      case PowerupType.laserPaddle:  return '↑';
      case PowerupType.fireball:     return '🔥';
      case PowerupType.magnet:       return 'M';
      case PowerupType.multiBall:    return '×3';
      case PowerupType.shield:       return '▬';
      case PowerupType.giantBall:    return '●';
      case PowerupType.shrinkPaddle: return '⇔';
      case PowerupType.fastBall:     return '⚡';
      case PowerupType.reverseControls: return '⇄';
      case PowerupType.fog:          return '☁';
    }
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is Paddle) {
      gameRef.gameState.activatePowerup(type);
      removeFromParent();
    }
  }
}
