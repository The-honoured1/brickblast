import 'package:flutter/material.dart';

enum BrickType {
  normal(hitPoints: 1, color: Color(0xFF05D9E8)),
  tough(hitPoints: 3, color: Color(0xFFFF9F1C)),
  explosive(hitPoints: 1, color: Color(0xFFFF0054)),
  ghost(hitPoints: 1, color: Color(0xFF8338EC)),
  steel(hitPoints: 999, color: Color(0xFF6C7A89), isIndestructible: true),
  chain(hitPoints: 1, color: Color(0xFF00FF7F)),
  multiplier(hitPoints: 1, color: Color(0xFFFFD700)),
  bomb(hitPoints: 1, color: Color(0xFF9D0208));

  final int hitPoints;
  final Color color;
  final bool isIndestructible;

  const BrickType({
    required this.hitPoints,
    required this.color,
    this.isIndestructible = false,
  });
}
