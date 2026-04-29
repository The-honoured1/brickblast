import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../block_blaster_game.dart';
import '../../models/brick_type.dart';

class Brick extends PositionComponent with HasGameRef<BlockBlasterGame> {
  final BrickType type;
  late int health;
  late final RectangleHitbox _hitbox;

  Brick({
    required Vector2 position,
    required Vector2 size,
    this.type = BrickType.normal,
  }) : super(position: position, size: size) {
    health = type.hitPoints;
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    anchor = Anchor.center;
    _hitbox = RectangleHitbox();
    add(_hitbox);
  }

  @override
  void render(Canvas canvas) {
    // Dynamic styling based on health/type
    Color brickColor = type.color;
    if (type == BrickType.tough && health < type.hitPoints) {
      // Darken slightly as it gets damaged
      brickColor = brickColor.withOpacity(0.5 + (0.5 * (health / type.hitPoints)));
    }

    final RRect rrect = RRect.fromRectAndRadius(
      size.toRect(),
      const Radius.circular(4),
    );
    canvas.drawRRect(rrect, Paint()..color = brickColor);
    
    // Draw crack lines if damaged
    if (type == BrickType.tough && health < type.hitPoints) {
      final paint = Paint()
        ..color = Colors.black.withOpacity(0.5)
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke;
      
      canvas.drawLine(Offset(size.x * 0.2, size.y * 0.2), Offset(size.x * 0.5, size.y * 0.8), paint);
      if (health == 1) {
        canvas.drawLine(Offset(size.x * 0.8, size.y * 0.1), Offset(size.x * 0.4, size.y * 0.9), paint);
      }
    }
  }

  void hit() {
    if (type.isIndestructible) {
      // Micro shake for hitting steel
      gameRef.shake(1.0, 0.05);
      return;
    }

    health--;
    
    // Juice: micro-shake
    gameRef.shake(2.0, 0.05);
    
    if (health <= 0) {
      destroy();
    }
  }

  void destroy({bool chainTrigger = false}) {
    if (chainTrigger == false) {
      gameRef.gameState.incrementCombo();
      gameRef.gameState.addScore(10);
    }
    
    // Juice: Screen flash/shake for explosive
    if (type == BrickType.explosive) {
      gameRef.shake(5.0, 0.15);
      _triggerExplosion();
    }
    
    // Chain reaction
    if (type == BrickType.chain) {
      _triggerChain();
    }

    removeFromParent();
  }

  void _triggerExplosion() {
    // Basic explosion finding neighbors
    final neighbors = gameRef.world.children.whereType<Brick>().where((b) {
      if (b == this) return false;
      return b.position.distanceTo(position) < size.x * 1.5;
    });
    
    for (var b in neighbors) {
      b.destroy(chainTrigger: true);
    }
  }
  
  void _triggerChain() {
    final neighbors = gameRef.world.children.whereType<Brick>().where((b) {
      if (b == this || b.type != BrickType.chain) return false;
      return b.position.distanceTo(position) < size.x * 1.5;
    });
    
    for (var b in neighbors) {
      b.destroy(chainTrigger: true);
    }
  }
}
