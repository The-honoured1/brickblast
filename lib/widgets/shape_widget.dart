import 'package:flutter/material.dart';
import '../models/shape.dart';
import 'cell_widget.dart';

class ShapeWidget extends StatelessWidget {
  final ShapeConfig shape;
  final double cellSize;

  const ShapeWidget({
    super.key,
    required this.shape,
    required this.cellSize,
  });

  @override
  Widget build(BuildContext context) {
    int rows = shape.matrix.length;
    int cols = shape.matrix[0].length;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(rows, (r) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(cols, (c) {
            bool isFilled = shape.matrix[r][c] == 1;
            return isFilled
                ? CellWidget(color: shape.color, size: cellSize)
                : SizedBox(width: cellSize, height: cellSize);
          }),
        );
      }),
    );
  }
}
