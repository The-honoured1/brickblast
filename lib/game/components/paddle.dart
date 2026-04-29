import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../block_blaster_game.dart';

class Paddle extends PositionComponent
    with HasGameRef<BlockBlasterGame>, DragCallbacks, CollisionCallbacks {
  
  late final RectangleHitbox _hitbox;
  final Paint _paint = Paint()..color = AppColors.primary;
  
  // Power-up states
  bool isWide = false;
  bool isShrunk = false;
  
  Paddle({required Vector2 size}) : super(size: size);

  @override
  Future<void> onLoad() async {
    super.onLoad();
    anchor = Anchor.center;
    
    // Position at the bottom center
    position = Vector2(gameRef.size.x / 2, gameRef.size.y - 150);

    _hitbox = RectangleHitbox();
    add(_hitbox);
  }

  @override
  void render(Canvas canvas) {
    // Sleek flat bar appearance
    final RRect rrect = RRect.fromRectAndRadius(
      size.toRect(),
      const Radius.circular(8),
    );
    canvas.drawRRect(rrect, _paint);
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    // Move paddle horizontally based on drag
    position.x += event.localDelta.x;
    
    // Clamp to screen bounds
    final halfWidth = size.x / 2;
    if (position.x < halfWidth) {
      position.x = halfWidth;
    } else if (position.x > gameRef.size.x - halfWidth) {
      position.x = gameRef.size.x - halfWidth;
    }
  }
}
