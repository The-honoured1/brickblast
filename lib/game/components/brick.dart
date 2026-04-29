import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../block_blaster_game.dart';
import '../../models/brick_type.dart';
import '../../models/powerup_type.dart';
import 'powerup.dart';
import 'ball.dart';
import 'dart:math' as math;

class Brick extends PositionComponent with HasGameRef<BlockBlasterGame> {
  final BrickType type;
  late int health;
  late final RectangleHitbox _hitbox;
  
  // Special brick state
  double _bombTimer = 3.0;
  TextComponent? _bombText;
  double _opacity = 1.0;

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

    if (type == BrickType.bomb) {
      _bombText = TextComponent(
        text: '3',
        textRenderer: TextPaint(
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        position: size / 2,
        anchor: Anchor.center,
      );
      add(_bombText!);
    }

    if (type == BrickType.ghost) {
      _opacity = 0.0;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (type == BrickType.ghost) {
      final ball = gameRef.ball;
      final dist = ball.position.distanceTo(position);
      if (dist < 100) {
        _opacity = (1.0 - (dist / 100)).clamp(0.0, 1.0);
      } else {
        _opacity = 0.0;
      }
    }

    if (type == BrickType.bomb) {
      _bombTimer -= dt;
      if (_bombTimer <= 0) {
        _triggerBombFailure();
      } else {
        _bombText?.text = _bombTimer.ceil().toString();
      }
    }
  }

  void _triggerBombFailure() {
    // Destroy a row of bricks from the bottom
    final bricks = gameRef.world.children.whereType<Brick>().toList();
    if (bricks.isNotEmpty) {
      double maxY = bricks.map((e) => e.position.y).reduce(math.max);
      final bottomBricks = bricks.where((e) => (e.position.y - maxY).abs() < 5).toList();
      for (var b in bottomBricks) {
        b.destroy(chainTrigger: true);
      }
    }
    removeFromParent();
  }

  @override
  void render(Canvas canvas) {
    // Dynamic styling based on health/type
    Color brickColor = type.color;
    if (type == BrickType.tough && health < type.hitPoints) {
      // Darken slightly as it gets damaged
      brickColor = brickColor.withOpacity((0.5 + (0.5 * (health / type.hitPoints))).clamp(0.0, 1.0));
    }

    if (type == BrickType.ghost) {
      brickColor = brickColor.withOpacity(_opacity);
    }

    final RRect rrect = RRect.fromRectAndRadius(
      size.toRect(),
      const Radius.circular(2),
    );
    
    // Flat depth: Draw a darker bottom layer
    final depthOffset = Vector2(0, 3).toOffset();
    final depthRRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 2, size.x, size.y),
      const Radius.circular(2),
    );
    canvas.drawRRect(depthRRect, Paint()..color = Colors.black.withOpacity(0.3));
    
    // Main brick face
    canvas.drawRRect(rrect, Paint()..color = brickColor);
    
    // Top highlight line for extra "flat" pop
    final highlightPaint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawLine(const Offset(2, 2), Offset(size.x - 2, 2), highlightPaint);
    
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
      gameRef.playSfx('clink.wav');
      return;
    }

    health--;
    gameRef.playSfx('hit.wav');
    
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
      gameRef.playSfx('explosion.wav');
      _triggerExplosion();
    }
    
    // Chain reaction
    if (type == BrickType.chain) {
      _triggerChain();
    }

    if (type == BrickType.multiplier) {
      _triggerMultiplier();
    }

    // Powerup drop roll (10% chance)
    if (math.Random().nextDouble() < 0.15) {
      _dropPowerup();
    }

    removeFromParent();
  }

  void _triggerMultiplier() {
    for (int i = 0; i < 2; i++) {
      final newBall = Ball(radius: gameRef.ball.radius);
      newBall.position = position.clone();
      newBall.velocity = Vector2(math.cos(i * math.pi), math.sin(i * math.pi))..normalize();
      newBall.velocity *= gameRef.ball.speed;
      gameRef.world.add(newBall);
    }
  }

  void _dropPowerup() {
    final types = PowerupType.values;
    final type = types[math.Random().nextInt(types.length)];
    gameRef.world.add(Powerup(position: position.clone(), type: type));
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
