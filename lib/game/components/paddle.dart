import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import '../block_blaster_game.dart';
import '../../models/powerup_type.dart';

class Paddle extends PositionComponent
    with HasGameRef<BlockBlasterGame>, DragCallbacks, CollisionCallbacks {
  
  late RectangleHitbox _hitbox;
  final double baseWidth = 100.0;
  
  Paddle({required Vector2 size}) : super(size: size);

  bool get isWide => gameRef.gameState.activePowerup == PowerupType.widePaddle;
  bool get isShrunk => gameRef.gameState.activePowerup == PowerupType.shrinkPaddle;
  bool get isReverse => gameRef.gameState.activePowerup == PowerupType.reverseControls;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    anchor = Anchor.center;
    
    position = Vector2(gameRef.size.x / 2, gameRef.size.y - 150);

    _hitbox = RectangleHitbox();
    add(_hitbox);
  }

  @override
  void update(double dt) {
    super.update(dt);
    
    double targetWidth = baseWidth;
    if (isWide) targetWidth = baseWidth * 1.5;
    if (isShrunk) targetWidth = baseWidth * 0.5;
    
    // Smooth size tween
    size.x += (targetWidth - size.x) * 10 * dt;
  }

  @override
  void render(Canvas canvas) {
    Color paddleColor = const Color(0xFF05D9E8); // Base color
    
    // Apply powerup color glow if active
    if (gameRef.gameState.activePowerup != null) {
      paddleColor = gameRef.gameState.activePowerup!.color;
    }

    final RRect rrect = RRect.fromRectAndRadius(
      size.toRect(),
      const Radius.circular(8),
    );
    canvas.drawRRect(rrect, Paint()..color = paddleColor);
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    double directionMultiplier = isReverse ? -1.0 : 1.0;
    position.x += event.localDelta.x * directionMultiplier;
    
    final halfWidth = size.x / 2;
    if (position.x < halfWidth) {
      position.x = halfWidth;
    } else if (position.x > gameRef.size.x - halfWidth) {
      position.x = gameRef.size.x - halfWidth;
    }
  }
}
