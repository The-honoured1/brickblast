import 'dart:math';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../block_blaster_game.dart';
import 'paddle.dart';
import 'brick.dart';

class Ball extends CircleComponent with HasGameRef<BlockBlasterGame>, CollisionCallbacks {
  Vector2 velocity = Vector2.zero();
  double speed = 400.0;
  
  // States
  bool isFireball = false;

  Ball({required double radius}) : super(radius: radius);

  @override
  Future<void> onLoad() async {
    super.onLoad();
    anchor = Anchor.center;
    paint = Paint()..color = Colors.white;

    // Position above the paddle
    position = Vector2(gameRef.size.x / 2, gameRef.size.y - 180);
    
    // Initial velocity
    velocity = Vector2(0, -1)..normalize();
    velocity *= speed;

    add(CircleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    position += velocity * dt;

    // Screen boundary collisions
    if (position.x - radius < 0) {
      position.x = radius;
      velocity.x = -velocity.x;
    } else if (position.x + radius > gameRef.size.x) {
      position.x = gameRef.size.x - radius;
      velocity.x = -velocity.x;
    }

    if (position.y - radius < 0) {
      position.y = radius;
      velocity.y = -velocity.y;
    } else if (position.y + radius > gameRef.size.y) {
      // Bottom boundary - lose a life
      position.y = gameRef.size.y - radius;
      velocity.y = 0;
      velocity.x = 0;
      // TODO: Trigger lose life in game ref
    }
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    
    if (other is Paddle) {
      // Bounce off paddle, change angle based on hit position
      final delta = position.x - other.position.x;
      final maxDelta = other.size.x / 2;
      
      // Calculate new bounce angle between -60 and 60 degrees
      final ratio = (delta / maxDelta).clamp(-1.0, 1.0);
      final angle = ratio * (pi / 3); // pi/3 = 60 degrees

      velocity = Vector2(sin(angle), -cos(angle)) * speed;
      
      // Reset combo if it hit the paddle
      gameRef.combo = 0;
      
    } else if (other is Brick) {
      if (!isFireball) {
        // Simple bounce based on the collision points
        // Get the center of the intersection
        final intersection = intersectionPoints.reduce((a, b) => a + b) / intersectionPoints.length.toDouble();
        
        // Determine whether it's a horizontal or vertical collision
        final centerDelta = intersection - other.position;
        if (centerDelta.x.abs() > centerDelta.y.abs()) {
          velocity.x = -velocity.x; // Hit left/right
        } else {
          velocity.y = -velocity.y; // Hit top/bottom
        }
      }
      
      other.hit();
    }
  }
}
