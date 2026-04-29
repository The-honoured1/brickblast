import 'package:flutter/material.dart';
import '../models/game_state.dart';
import '../models/shape.dart';
import '../theme/colors.dart';
import 'cell_widget.dart';

class BoardWidget extends StatelessWidget {
  final GameState gameState;
  final double cellSize;
  final GlobalKey boardKey;

  const BoardWidget({
    super.key,
    required this.gameState,
    required this.cellSize,
    required this.boardKey,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      key: boardKey,
      padding: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        color: AppColors.gridBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border, width: 2),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(GameState.boardSize, (r) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(GameState.boardSize, (c) {
              return DragTarget<ShapeConfig>(
                builder: (context, candidateData, rejectedData) {
                  return CellWidget(
                    color: gameState.board[r][c],
                    size: cellSize,
                  );
                },
                onWillAcceptWithDetails: (details) {
                  // Actually it's better to do collision at global drag end,
                  // because DragTarget over individual cells requires calculating offset off the piece.
                  return true;
                },
                onAcceptWithDetails: (details) {
                  // We'll handle this in GameScreen via Draggable's onDragEnd.
                },
              );
            }),
          );
        }),
      ),
    );
  }
}
