import 'dart:math';
import 'package:flutter/material.dart';
import '../models/game_state.dart';
import '../models/shape.dart';
import '../theme/colors.dart';
import '../theme/styles.dart';
import '../widgets/board_widget.dart';
import '../widgets/shape_widget.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final GameState _gameState = GameState();
  final GlobalKey _boardKey = GlobalKey();
  
  List<ShapeConfig?> _availableShapes = [];
  final Random _random = Random();
  double _cellSize = 0;

  @override
  void initState() {
    super.initState();
    _gameState.addListener(_onGameStateChanged);
    _generateNextShapes();
  }

  @override
  void dispose() {
    _gameState.removeListener(_onGameStateChanged);
    _gameState.dispose();
    super.dispose();
  }

  void _onGameStateChanged() {
    setState(() {});
  }

  void _generateNextShapes() {
    _availableShapes = List.generate(3, (_) {
      return Shapes.all[_random.nextInt(Shapes.all.length)];
    });
    _gameState.checkGameOver(_availableShapes.whereType<ShapeConfig>().map((s) => s.matrix).toList());
  }

  void _handleDrop(DraggableDetails details, ShapeConfig shape, int index) {
    if (_boardKey.currentContext == null) return;

    final RenderBox boardBox = _boardKey.currentContext!.findRenderObject() as RenderBox;
    final Offset boardPosition = boardBox.localToGlobal(Offset.zero);
    
    // Calculate the drop offset relative to the board
    final Offset dropOffset = details.offset - boardPosition;

    // Notice: usually when holding a piece, it's slightly above the finger so you can see it.
    // The exact cell should map to the top-left of the shape based on its matrix.
    // Let's assume the draggable feedback puts the shape directly under the finger, 
    // or offset by a fixed amount. We will add a small offset shift vertically so finger doesn't block it.
    // The finger is at details.offset.
    
    // We remove the typical Y offset we added in feedback.
    final double fingerOffsetY = -(_cellSize * 2);
    final Offset actualDrop = dropOffset - Offset(0, fingerOffsetY);

    int col = (actualDrop.dx / (_cellSize + 2)).round();
    int row = (actualDrop.dy / (_cellSize + 2)).round();

    if (_gameState.canPlace(row, col, shape.matrix)) {
      _gameState.placeShape(row, col, shape.matrix, shape.color);
      
      setState(() {
        _availableShapes[index] = null;
        if (_availableShapes.every((s) => s == null)) {
          _generateNextShapes();
        } else {
           _gameState.checkGameOver(_availableShapes.whereType<ShapeConfig>().map((s) => s.matrix).toList());
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Calculate sizing based on screen width
    final double screenWidth = MediaQuery.of(context).size.width;
    _cellSize = (screenWidth - 48) / GameState.boardSize; // 16 padding on each side, plus some inner spacing

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header / Score
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       const Text('SCORE', style: AppStyles.subScoreText),
                       Text('${_gameState.score}', style: AppStyles.scoreText),
                     ],
                   ),
                   IconButton(
                     icon: const Icon(Icons.refresh, color: AppColors.textPrimary, size: 32),
                     onPressed: () {
                       _gameState.reset();
                       _generateNextShapes();
                     },
                   )
                ],
              ),
            ),
            
            // Board
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: BoardWidget(
                    gameState: _gameState,
                    cellSize: _cellSize,
                    boardKey: _boardKey,
                  ),
                ),
              ),
            ),

            // Game Over Text
            if (_gameState.isGameOver)
               const Padding(
                 padding: EdgeInsets.all(16.0),
                 child: Text('GAME OVER!', style: TextStyle(color: AppColors.neonPink, fontSize: 32, fontWeight: FontWeight.w900)),
               ),

            // Available Shapes
            Padding(
              padding: const EdgeInsets.only(bottom: 48.0, top: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: List.generate(3, (index) {
                  final shape = _availableShapes[index];
                  if (shape == null) {
                    return SizedBox(width: _cellSize * 3, height: _cellSize * 3);
                  }
                  
                  // For the rack, we scale down the shapes slightly to fit
                  final double rackCellSize = _cellSize * 0.7;

                  return Draggable<ShapeConfig>(
                    data: shape,
                    feedback: Transform.translate(
                      // Offset feedback so the user's finger doesn't block the view
                      offset: Offset(-(_cellSize * shape.matrix[0].length) / 2, -(_cellSize * 2)), 
                      child: ShapeWidget(
                        shape: shape,
                        cellSize: _cellSize,
                      ),
                    ),
                    childWhenDragging: Opacity(
                      opacity: 0.2,
                      child: ShapeWidget(
                        shape: shape,
                        cellSize: rackCellSize,
                      ),
                    ),
                    onDragEnd: (details) {
                      _handleDrop(details, shape, index);
                    },
                    child: ShapeWidget(
                      shape: shape,
                      cellSize: rackCellSize,
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
