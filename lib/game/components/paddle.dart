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

  // Cached Paints and Shapes
  late final Paint _depthPaint;
  late final Paint _bodyPaint;
  late final Paint _accentPaint;
  late RRect _rrect;
  late RRect _depthRRect;

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

    _depthPaint = Paint()..color = const Color(0xFF000000);
    _bodyPaint = Paint()..color = const Color(0xFF05D9E8);
    _accentPaint = Paint()
      ..color = const Color(0xFF000000)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    
    _updateShapes();
  }

  void _updateShapes() {
    _rrect = RRect.fromRectAndRadius(size.toRect(), const Radius.circular(8));
    _depthRRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 5, size.x, size.y),
      const Radius.circular(8),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    
    double targetWidth = baseWidth;
    if (isWide) targetWidth = baseWidth * 1.5;
    if (isShrunk) targetWidth = baseWidth * 0.5;
    
    // Smooth size tween
    double oldWidth = size.x;
    size.x += (targetWidth - size.x) * 10 * dt;
    if ((size.x - oldWidth).abs() > 0.1) {
      _updateShapes();
    }

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

  void impact() {
    add(
      ScaleEffect.to(
        Vector2(1.2, 0.8),
        EffectController(duration: 0.05, reverseDuration: 0.05),
      ),
    );
  }

  void _releaseBall() {
    if (_stuckBall != null) {
      _stuckBall!.launch();
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
    // Apply powerup color glow if active
    if (gameRef.gameState.activePowerup != null) {
      _bodyPaint.color = gameRef.gameState.activePowerup!.color;
    } else {
      _bodyPaint.color = const Color(0xFF05D9E8);
    }

    canvas.drawRRect(_depthRRect, _depthPaint);
    canvas.drawRRect(_rrect, _bodyPaint);
    canvas.drawRRect(_rrect, _accentPaint); // Draw the bold outline
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
