import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../block_blaster_game.dart';
import 'ball.dart';
import '../../models/powerup_type.dart';

/// A one-hit safety net that appears below the paddle when Shield powerup is active.
class Shield extends PositionComponent
    with HasGameRef<BlockBlasterGame>, CollisionCallbacks {
  Shield() : super(size: Vector2.zero());

  @override
  Future<void> onLoad() async {
    super.onLoad();
    anchor = Anchor.center;
    size = Vector2(gameRef.size.x * 0.8, 8);
    position = Vector2(gameRef.size.x / 2, gameRef.size.y - 90);
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    // Remove itself when shield powerup expires
    if (gameRef.gameState.activePowerup != PowerupType.shield) {
      removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    final paint = Paint()
      ..color = PowerupType.shield.color.withOpacity(0.85)
      ..style = PaintingStyle.fill;
    final rrect = RRect.fromRectAndRadius(size.toRect(), const Radius.circular(4));
    canvas.drawRRect(rrect, paint);

    // Glowing top edge
    final glowPaint = Paint()
      ..color = Colors.greenAccent.withOpacity(0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawRRect(rrect, glowPaint);
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is Ball) {
      other.velocity.y = -other.velocity.y.abs(); // Always bounce up
      // Single-use: remove after absorbing one hit
      removeFromParent();
    }
  }
}


/// An upward-moving laser bolt fired from the paddle
class LaserBolt extends PositionComponent
    with HasGameRef<BlockBlasterGame>, CollisionCallbacks {
  LaserBolt({required Vector2 position})
      : super(position: position, size: Vector2(4, 20));

  final double _speed = 600.0;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    anchor = Anchor.center;
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.y -= _speed * dt;
    if (position.y < -20) removeFromParent();
  }

  @override
  void render(Canvas canvas) {
    final paint = Paint()..color = PowerupType.laserPaddle.color;
    canvas.drawRect(size.toRect(), paint);

    final glowPaint = Paint()
      ..color = Colors.redAccent.withOpacity(0.4)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawRect(size.toRect(), glowPaint);
  }
}
