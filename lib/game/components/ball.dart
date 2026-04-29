import 'dart:math';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../block_blaster_game.dart';
import 'paddle.dart';
import 'brick.dart';
import '../../models/powerup_type.dart';

class Ball extends CircleComponent with HasGameRef<BlockBlasterGame>, CollisionCallbacks {
  Vector2 velocity = Vector2.zero();
  double speed = 400.0;
  
  // Cached trail paints
  final List<Paint> _trailPaints = List.generate(8, (i) => Paint());

  Ball({required double radius}) : super(radius: radius);

  bool get isFireball => gameRef.gameState.activePowerup == PowerupType.fireball;
  bool get isGiant => gameRef.gameState.activePowerup == PowerupType.giantBall;
  bool get isFast => gameRef.gameState.activePowerup == PowerupType.fastBall;
  bool get isSlow => gameRef.gameState.activePowerup == PowerupType.slowBall;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    anchor = Anchor.center;
    
    position = Vector2(gameRef.size.x / 2, gameRef.size.y - 180);
    
    velocity = Vector2(0, -1)..normalize();
    velocity *= speed;

    add(CircleHitbox());
  }
  
  @override
  void render(Canvas canvas) {
    paint.color = Colors.white;
    if (isFireball) {
      paint.color = Colors.orange;
    }
    
    // Trail juice based on combo
    int combo = gameRef.gameState.combo;
    if (combo > 2) {
      final baseTrailColor = paint.color;
      for (int i = 1; i <= min(combo, 8); i++) {
        final trailPaint = _trailPaints[i - 1]
          ..color = baseTrailColor.withOpacity(0.4 - (i * 0.04).clamp(0, 0.4));
        
        canvas.drawCircle(
          Offset(-velocity.x * (i * 0.004), -velocity.y * (i * 0.004)), 
          radius * (1.0 - (i * 0.1)).clamp(0.1, 1.0), 
          trailPaint
        );
      }
    }

    super.render(canvas);
  }

  @override
  void update(double dt) {
    super.update(dt);
    
    double currentSpeed = speed;
    if (isFast) currentSpeed *= 1.5;
    if (isSlow) currentSpeed *= 0.6;
    
    Vector2 moveStep = velocity.normalized() * currentSpeed * dt;
    position += moveStep;
    
    double currentRadius = isGiant ? radius * 3 : radius;

    if (position.x - currentRadius < 0) {
      position.x = currentRadius;
      velocity.x = -velocity.x;
    } else if (position.x + currentRadius > gameRef.size.x) {
      position.x = gameRef.size.x - currentRadius;
      velocity.x = -velocity.x;
    }

    if (position.y - currentRadius < 0) {
      position.y = currentRadius;
      velocity.y = -velocity.y;
    } else if (position.y + currentRadius > gameRef.size.y) {
      // Bottom boundary
      position.y = gameRef.size.y - currentRadius;
      velocity.y = 0;
      velocity.x = 0;
      gameRef.gameState.loseLife();
      gameRef.playSfx('lose_life.wav');
      // Drop logic will be handled outside
    }
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    
    if (other is Paddle) {
      final delta = position.x - other.position.x;
      final maxDelta = other.size.x / 2;
      final ratio = (delta / maxDelta).clamp(-1.0, 1.0);
      final angle = ratio * (pi / 3); 

      velocity = Vector2(sin(angle), -cos(angle)) * speed;
      gameRef.gameState.resetCombo();
      gameRef.playSfx('paddle_hit.wav');
      
    } else if (other is Brick) {
      if (!isFireball) {
        final intersection = intersectionPoints.reduce((a, b) => a + b) / intersectionPoints.length.toDouble();
        
        final centerDelta = intersection - other.position;
        if (centerDelta.x.abs() > centerDelta.y.abs()) {
          velocity.x = -velocity.x; 
        } else {
          velocity.y = -velocity.y;
        }
      }
      
      other.hit();
    }
  }
}
