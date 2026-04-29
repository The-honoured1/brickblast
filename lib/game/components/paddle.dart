import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import '../block_blaster_game.dart';
import '../../models/powerup_type.dart';
import 'shield.dart';
import 'ball.dart';

class Paddle extends PositionComponent
    with HasGameRef<BlockBlasterGame>, DragCallbacks, TapCallbacks, CollisionCallbacks {
  
  late RectangleHitbox _hitbox;
  final double baseWidth = 100.0;
  
  // Powerup state track
  PowerupType? _lastPowerup;
  double _laserTimer = 0.0;
  Ball? _stuckBall;
  Paddle({required Vector2 size}) : super(size: size);

  bool get isWide => gameRef.gameState.activePowerup == PowerupType.widePaddle;
  bool get isShrunk => gameRef.gameState.activePowerup == PowerupType.shrinkPaddle;
  bool get isReverse => gameRef.gameState.activePowerup == PowerupType.reverseControls;
  bool get isMagnet => gameRef.gameState.activePowerup == PowerupType.magnet;
  bool get isLaser => gameRef.gameState.activePowerup == PowerupType.laserPaddle;

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

    // Shield spawn
    if (gameRef.gameState.activePowerup == PowerupType.shield && _lastPowerup != PowerupType.shield) {
      gameRef.world.add(Shield());
    }

    // Laser firing
    if (isLaser) {
      _laserTimer += dt;
      if (_laserTimer >= 0.5) { // Auto-fire every 0.5s or on tap? Design says "tap screen to fire"
        // Let's stick to tap for now as per design document
      }
    }

    // Magnet stick logic
    if (_stuckBall != null) {
      if (!isMagnet) {
        _releaseBall();
      } else {
        _stuckBall!.position.x = position.x + (_stuckBall!.position.x - position.x); // Maintain relative offset?
        // Actually, let's keep it centered on top for simplicity
        _stuckBall!.position = Vector2(position.x, position.y - size.y / 2 - _stuckBall!.radius);
        _stuckBall!.velocity = Vector2.zero();
      }
    }

    _lastPowerup = gameRef.gameState.activePowerup;
  }

  void _releaseBall() {
    if (_stuckBall != null) {
      _stuckBall!.velocity = Vector2(0, -1)..normalize();
      _stuckBall!.velocity *= _stuckBall!.speed;
      _stuckBall = null;
    }
  }

  @override
  void onTapDown(TapDownEvent event) {
    if (isLaser) {
      _fireLasers();
    }
    if (_stuckBall != null) {
      _releaseBall();
    }
  }

  void _fireLasers() {
    gameRef.world.add(LaserBolt(position: Vector2(position.x - size.x / 4, position.y - size.y)));
    gameRef.world.add(LaserBolt(position: Vector2(position.x + size.x / 4, position.y - size.y)));
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is Ball && isMagnet && _stuckBall == null) {
      _stuckBall = other;
      _stuckBall!.velocity = Vector2.zero();
    }
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
      const Radius.circular(4),
    );

    // Flat shadow/depth
    final depthRRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 4, size.x, size.y),
      const Radius.circular(4),
    );
    canvas.drawRRect(depthRRect, Paint()..color = Colors.black.withOpacity(0.4));

    // Main body
    canvas.drawRRect(rrect, Paint()..color = paddleColor);

    // Accent line
    final accentPaint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawLine(const Offset(8, 4), Offset(size.x - 8, 4), accentPaint);
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
