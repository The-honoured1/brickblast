import 'package:flutter/material.dart';

enum PowerupCategory {
  positive,
  negative,
}

enum PowerupType {
  widePaddle(category: PowerupCategory.positive, durationSeconds: 10, color: Color(0xFF00E5FF)),
  slowBall(category: PowerupCategory.positive, durationSeconds: 8, color: Color(0xFF00BFA5)),
  laserPaddle(category: PowerupCategory.positive, durationSeconds: 8, color: Color(0xFFFF1744)),
  fireball(category: PowerupCategory.positive, durationSeconds: 5, color: Color(0xFFFF3D00)),
  magnet(category: PowerupCategory.positive, durationSeconds: 10, color: Color(0xFF651FFF)),
  multiBall(category: PowerupCategory.positive, durationSeconds: 0, color: Color(0xFFFFEA00)),
  shield(category: PowerupCategory.positive, durationSeconds: 15, color: Color(0xFF00C853)),
  giantBall(category: PowerupCategory.positive, durationSeconds: 8, color: Color(0xFFFF9100)),
  shrinkPaddle(category: PowerupCategory.negative, durationSeconds: 8, color: Color(0xFFD50000)),
  fastBall(category: PowerupCategory.negative, durationSeconds: 8, color: Color(0xFF880E4F)),
  reverseControls(category: PowerupCategory.negative, durationSeconds: 5, color: Color(0xFF3E2723)),
  fog(category: PowerupCategory.negative, durationSeconds: 8, color: Color(0xFF424242));

  final PowerupCategory category;
  final int durationSeconds;
  final Color color;

  const PowerupType({
    required this.category,
    required this.durationSeconds,
    required this.color,
  });
}
