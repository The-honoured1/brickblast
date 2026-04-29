import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flame/camera.dart';
import 'package:flame/effects.dart';
import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import 'package:flame_audio/flame_audio.dart';
import 'dart:math' as math;

import 'components/paddle.dart';
import 'components/ball.dart';
import 'components/brick.dart';
import 'game_state.dart';
import '../models/brick_type.dart';
import '../models/level_data.dart';
import 'package:flame/events.dart';

class BlockBlasterGame extends FlameGame with HasCollisionDetection, TapCallbacks {
  final GameState gameState;
  late Paddle paddle;
  late Ball ball;
  ParallaxComponent? _parallax;

  // Sound debouncing
  final Map<String, double> _sfxTimers = {};
  
  BlockBlasterGame(this.gameState);

  @override
  Future<void> onLoad() async {
    super.onLoad();
    
    // Setup camera for shaking
    camera = CameraComponent.withFixedResolution(
      width: size.x,
      height: size.y,
    );
    camera.viewfinder.anchor = Anchor.topLeft;
    
    // Preload audio (assuming files exist in assets/audio/)
    // FlameAudio.audioCache.loadAll(['hit.wav', 'explosion.wav', 'powerup.wav', 'lose_life.wav']);

    // Load level
    loadLevel(gameState.currentLevel);
    
    // Add player components
    paddle = Paddle(size: Vector2(100, 16));
    world.add(paddle);
    
    ball = Ball(radius: 8);
    world.add(ball);
  }

  Future<void> _updateTheme(WorldTheme theme) async {
    _parallax?.removeFromParent();
    
    // No assets yet, so we'll just log or prepare for later.
    // In a real scenario, we'd load images here.
  }

  void loadLevel(int levelIndex) {
    // Clear old bricks
    world.children.whereType<Brick>().forEach((b) => b.removeFromParent());
    
    bool isBoss = levelIndex % 10 == 0;
    
    if (isBoss) {
      _loadBossLevel();
      return;
    }

    final padding = 10.0;
    final cols = 6;
    final rows = 5;
    final brickWidth = (size.x - (padding * (cols + 1))) / cols;
    final brickHeight = 24.0;
    
    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < cols; col++) {
        final pos = Vector2(
          padding + (brickWidth / 2) + col * (brickWidth + padding),
          100.0 + row * (brickHeight + padding)
        );
        
        BrickType type = _getBrickTypeForLevel(row, col, levelIndex);
        
        world.add(Brick(
          position: pos,
          size: Vector2(brickWidth, brickHeight),
          type: type,
        ));
      }
    }
  }

  void _loadBossLevel() {
    final centerX = size.x / 2;
    final centerY = 200.0;
    final bossSize = 120.0;

    world.add(Brick(
      position: Vector2(centerX, centerY),
      size: Vector2(bossSize, bossSize / 2),
      type: BrickType.tough, // Boss core
    ));

    for (int i = 0; i < 4; i++) {
        double angle = i * math.pi / 2;
        world.add(Brick(
            position: Vector2(centerX + math.cos(angle) * 80, centerY + math.sin(angle) * 40),
            size: Vector2(40, 20),
            type: BrickType.steel,
        ));
    }
  }

  BrickType _getBrickTypeForLevel(int row, int col, int level) {
    final rand = math.Random();
    double chance = rand.nextDouble();

    if (chance < 0.05) return BrickType.multiplier;
    if (chance < 0.10) return BrickType.bomb;
    if (chance < 0.15) return BrickType.explosive;
    if (chance < 0.20 && level > 5) return BrickType.ghost;
    if (chance < 0.25 && level > 1) return BrickType.tough;
    if (chance < 0.28 && level > 3) return BrickType.steel;
    if (chance < 0.32 && level > 2) return BrickType.chain;
    
    return BrickType.normal;
  }

  void shake(double intensity, double duration) {
    camera.viewfinder.add(
      MoveEffect.by(
        Vector2(intensity, intensity),
        EffectController(
          duration: duration / 4,
          reverseDuration: duration / 4,
          repeatCount: 2,
        ),
      ),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    gameState.updatePowerupTime(dt);

    if (gameState.lives <= 0 && overlays.isActive('HudOverlay')) {
      overlays.remove('HudOverlay');
      overlays.add('GameOverOverlay');
    }

    _sfxTimers.forEach((key, value) {
      if (value > 0) _sfxTimers[key] = value - dt;
    });
  }

  @override
  Color backgroundColor() {
    // Determine world index (0 to 5)
    int worldIndex = (gameState.currentLevel - 1) ~/ 10;
    
    // Light base color per world (Zen style)
    Color baseColor;
    switch (worldIndex % 6) {
      case 0: baseColor = const Color(0xFFF2F9F2); break; // Jungle Light
      case 1: baseColor = const Color(0xFFF2F2F9); break; // Space Light
      case 2: baseColor = const Color(0xFFF2F9F9); break; // Underwater Light
      case 3: baseColor = const Color(0xFFF9F2F2); break; // Volcano Light
      case 4: baseColor = const Color(0xFFF9F9FF); break; // Ice Light
      case 5: baseColor = const Color(0xFFF9F5F9); break; // NeonCity Light
      default: baseColor = const Color(0xFFF9F9F9);
    }

    double warmth = (gameState.combo / 20).clamp(0.0, 1.0);
    return Color.lerp(baseColor, const Color(0xFFF9EBEB), warmth)!;
  }

  void playSfx(String name) {
    // Basic debouncing: don't play same sound more than every 50ms
    if ((_sfxTimers[name] ?? 0) > 0) return;
    _sfxTimers[name] = 0.05;

    // In a real app with assets:
    // FlameAudio.play('sfx/$name');
    
    // For now we just print to console (printing is slow, so debouncing helps)
    print('SFX: $name');
  }
}
