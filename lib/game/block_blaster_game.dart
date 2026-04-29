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
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    if (!ball.isLaunched && gameState.lives > 0) {
      ball.launch();
    }
    
    if (paddle.isLaser) {
      paddle.onTapDown(event);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    gameState.updatePowerupTime(dt);

    // Check for level completion
    final bricks = world.children.whereType<Brick>();
    final destructibleBricks = bricks.where((b) => !b.type.isIndestructible);
    
    if (destructibleBricks.isEmpty && !overlays.isActive('LevelCompleteOverlay')) {
       _completeLevel();
    }

    if (gameState.lives <= 0 && !overlays.isActive('GameOverOverlay')) {
      overlays.add('GameOverOverlay');
      pauseEngine();
    }

    _sfxTimers.forEach((key, value) {
      if (value > 0) _sfxTimers[key] = value - dt;
    });
  }

  void _completeLevel() {
    overlays.add('LevelCompleteOverlay');
    playSfx('level_complete.wav');
    gameState.nextLevel();
    // Don't pause engine yet so we can see particles?
    // Actually, usually we pause or wait for user to click next.
  }

  void resetLevel() {
    ball.resetToPaddle();
    loadLevel(gameState.currentLevel);
    resumeEngine();
    overlays.remove('LevelCompleteOverlay');
    overlays.remove('GameOverOverlay');
  }

  void spawnParticles(Vector2 position, Color color) {
    // Basic particle burst using Flame's ParticleSystemComponent
    world.add(
      ParticleSystemComponent(
        particle: Particle.generate(
          count: 15,
          lifespan: 0.5,
          generator: (i) => AcceleratedParticle(
            acceleration: Vector2(0, 200),
            speed: Vector2(
              (math.Random().nextDouble() - 0.5) * 400,
              (math.Random().nextDouble() - 0.5) * 400,
            ),
            position: position.clone(),
            child: CircleParticle(
              radius: 2.0 + math.Random().nextDouble() * 3.0,
              paint: Paint()..color = color,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Color backgroundColor() {
    return const Color(0xFF0F0B1E); // Match AppColors.backgroundDark
  }

  void playSfx(String name) {
    if ((_sfxTimers[name] ?? 0) > 0) return;
    _sfxTimers[name] = 0.05;
    // print('SFX: $name');
  }
}
