import 'package:flutter/material.dart';
import 'brick_type.dart';

enum WorldTheme {
  jungle,
  space,
  underwater,
  volcano,
  ice,
  neonCity,
}

class LevelData {
  final int levelNumber;
  final WorldTheme theme;
  final List<List<BrickType?>> brickLayout;
  final bool isBossLevel;

  const LevelData({
    required this.levelNumber,
    required this.theme,
    required this.brickLayout,
    this.isBossLevel = false,
  });
}
