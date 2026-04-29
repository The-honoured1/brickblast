import 'package:flutter/material.dart';
import '../theme/colors.dart';

class ShapeConfig {
  final List<List<int>> matrix;
  final Color color;

  const ShapeConfig(this.matrix, this.color);
}

class Shapes {
  static const List<ShapeConfig> all = [
    // 1x1
    ShapeConfig([[1]], AppColors.neonPink),
    // 2x2
    ShapeConfig([
      [1, 1],
      [1, 1],
    ], AppColors.electricBlue),
    // 3x3
    ShapeConfig([
      [1, 1, 1],
      [1, 1, 1],
      [1, 1, 1],
    ], AppColors.pureYellow),
    // 2x1 horizontal
    ShapeConfig([[1, 1]], AppColors.acidLime),
    // 1x2 vertical
    ShapeConfig([
      [1],
      [1]
    ], AppColors.acidLime),
    // 3x1 horizontal
    ShapeConfig([[1, 1, 1]], AppColors.brightOrange),
    // 1x3 vertical
    ShapeConfig([
      [1],
      [1],
      [1]
    ], AppColors.brightOrange),
    // 4x1 horizontal
    ShapeConfig([[1, 1, 1, 1]], AppColors.neonPink),
    // 1x4 vertical
    ShapeConfig([
      [1],
      [1],
      [1],
      [1]
    ], AppColors.neonPink),
    // 5x1 horizontal
    ShapeConfig([[1, 1, 1, 1, 1]], AppColors.deepPurple),
    // 1x5 vertical
    ShapeConfig([
      [1],
      [1],
      [1],
      [1],
      [1]
    ], AppColors.deepPurple),
    // L-shape small right
    ShapeConfig([
      [1, 0],
      [1, 1]
    ], AppColors.electricBlue),
    // L-shape small left
    ShapeConfig([
      [0, 1],
      [1, 1]
    ], AppColors.electricBlue),
    // L-shape big top-right
    ShapeConfig([
      [1, 1, 1],
      [0, 0, 1],
      [0, 0, 1]
    ], AppColors.brightOrange),
    // L-shape big bottom-left
    ShapeConfig([
      [1, 0, 0],
      [1, 0, 0],
      [1, 1, 1]
    ], AppColors.brightOrange),
    // Cross
    ShapeConfig([
      [0, 1, 0],
      [1, 1, 1],
      [0, 1, 0]
    ], AppColors.pureYellow),
    // T-shape down
    ShapeConfig([
      [1, 1, 1],
      [0, 1, 0]
    ], AppColors.neonPink),
    // T-shape up
    ShapeConfig([
      [0, 1, 0],
      [1, 1, 1]
    ], AppColors.neonPink),
  ];
}
