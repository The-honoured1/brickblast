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
  double baseSpeed = 450.0;
  double speedMultiplier = 1.0;
  bool isLaunched = false;
  
  // Cached trail paints
  final List<Paint> _trailPaints = List.generate(12, (i) => Paint());

  Ball({required double radius}) : super(radius: radius);

  bool get isFireball => gameRef.gameState.activePowerup == PowerupType.fireball;
  bool get isGiant => gameRef.gameState.activePowerup == PowerupType.giantBall;
  bool get isFast => gameRef.gameState.activePowerup == PowerupType.fastBall;
  bool get isSlow => gameRef.gameState.activePowerup == PowerupType.slowBall;

  double get currentSpeed {
    double s = baseSpeed * speedMultiplier;
    if (isFast) s *= 1.4;
    if (isSlow) s *= 0.7;
    return s;
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    anchor = Anchor.center;
    resetToPaddle();
    add(CircleHitbox());
  }

  void resetToPaddle() {
    isLaunched = false;
    velocity = Vector2.zero();
    speedMultiplier = 1.0;
  }

  void launch() {
    if (isLaunched) return;
    isLaunched = true;
    velocity = Vector2(0, -1)..normalize();
    velocity *= currentSpeed;
  }
  
  @override
  void render(Canvas canvas) {
    paint.color = Colors.white;
    if (isFireball) {
      paint.color = Colors.orangeAccent;
    } else if (speedMultiplier > 1.5) {
      paint.color = const Color(0xFF00E5FF); // Cyber cyan for high speed
    }
    
    // Trail juice based on speed/combo
    if (isLaunched) {
      final baseTrailColor = paint.color;
      int trailLength = (speedMultiplier * 6).toInt().clamp(4, 12);
      for (int i = 1; i <= trailLength; i++) {
        final trailPaint = _trailPaints[i - 1]
          ..color = baseTrailColor.withOpacity((0.3 - (i * 0.02)).clamp(0, 0.3));
        
        canvas.drawCircle(
          Offset(-velocity.x * (i * 0.003), -velocity.y * (i * 0.003)), 
          radius * (1.0 - (i * 0.08)).clamp(0.2, 1.0), 
          trailPaint
        );
      }
    }

    super.render(canvas);
  }

  @override
  void update(double dt) {
    super.update(dt);
    
    if (!isLaunched) {
      position.x = gameRef.paddle.position.x;
      position.y = gameRef.paddle.position.y - gameRef.paddle.size.y / 2 - radius;
      return;
    }
    
    Vector2 moveStep = velocity.normalized() * currentSpeed * dt;
    position += moveStep;
    
    double currentRadius = isGiant ? radius * 3 : radius;

    if (position.x - currentRadius < 0) {
      position.x = currentRadius;
      velocity.x = -velocity.x;
      gameRef.shake(1.0, 0.05);
    } else if (position.x + currentRadius > gameRef.size.x) {
      position.x = gameRef.size.x - currentRadius;
      velocity.x = -velocity.x;
      gameRef.shake(1.0, 0.05);
    }

    if (position.y - currentRadius < 0) {
      position.y = currentRadius;
      velocity.y = -velocity.y;
      gameRef.shake(1.0, 0.05);
    } else if (position.y + currentRadius > gameRef.size.y) {
      // Failure state
      gameRef.gameState.loseLife();
      gameRef.playSfx('lose_life.wav');
      gameRef.shake(10.0, 0.2);
      
      if (gameRef.gameState.lives > 0) {
        resetToPaddle();
      } else {
        // Game Over handled in block_blaster_game update
        velocity = Vector2.zero();
      }
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

      velocity = Vector2(sin(angle), -cos(angle)) * currentSpeed;
      gameRef.gameState.resetCombo();
      gameRef.playSfx('paddle_hit.wav');
      
      // Impact juice
      other.impact();
      
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
      
      // Speed up!
      speedMultiplier += 0.02;
      other.hit();
    }
  }
}
