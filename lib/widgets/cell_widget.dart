import 'package:flutter/material.dart';
import '../theme/colors.dart';

class CellWidget extends StatelessWidget {
  final Color? color;
  final double size;

  const CellWidget({super.key, this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    bool isEmpty = color == null;
    return Container(
      width: size,
      height: size,
      margin: const EdgeInsets.all(1.0), // small gap for flat design
      decoration: BoxDecoration(
        color: isEmpty ? AppColors.emptyCell : color,
        border: Border.all(
          color: isEmpty ? AppColors.border : Colors.black.withValues(alpha: 0.2), // Darker border for colored cells to emulate flat 3D-ish stroke
          width: isEmpty ? 1 : 2, 
        ),
        // No boxShadow, no gloss. Pure, bold, flat colors!
        borderRadius: BorderRadius.circular(4), // Slightly rounded for friendliness
      ),
    );
  }
}
