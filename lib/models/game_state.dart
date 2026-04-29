import 'package:flutter/material.dart';

class GameState extends ChangeNotifier {
  static const int boardSize = 8;
  // A 2D list of Colors. Null means empty.
  List<List<Color?>> board = List.generate(boardSize, (_) => List.filled(boardSize, null));

  int score = 0;
  bool isGameOver = false;

  void placeShape(int startRow, int startCol, List<List<int>> matrix, Color color) {
    if (!canPlace(startRow, startCol, matrix)) return;

    for (int r = 0; r < matrix.length; r++) {
      for (int c = 0; c < matrix[r].length; c++) {
        if (matrix[r][c] == 1) {
          board[startRow + r][startCol + c] = color;
        }
      }
    }

    score += _getShapeScore(matrix);
    _checkClears();
    notifyListeners();
  }

  bool canPlace(int startRow, int startCol, List<List<int>> matrix) {
    for (int r = 0; r < matrix.length; r++) {
      for (int c = 0; c < matrix[r].length; c++) {
        if (matrix[r][c] == 1) {
          int boardRow = startRow + r;
          int boardCol = startCol + c;

          if (boardRow < 0 || boardRow >= boardSize || boardCol < 0 || boardCol >= boardSize) {
            return false;
          }
          if (board[boardRow][boardCol] != null) {
            return false;
          }
        }
      }
    }
    return true;
  }

  void _checkClears() {
    List<int> rowsToClear = [];
    List<int> colsToClear = [];

    // Check rows
    for (int r = 0; r < boardSize; r++) {
      if (board[r].every((cell) => cell != null)) {
        rowsToClear.add(r);
      }
    }

    // Check columns
    for (int c = 0; c < boardSize; c++) {
      bool colFilled = true;
      for (int r = 0; r < boardSize; r++) {
        if (board[r][c] == null) {
          colFilled = false;
          break;
        }
      }
      if (colFilled) colsToClear.add(c);
    }

    // Clear and score
    int linesCleared = rowsToClear.length + colsToClear.length;
    if (linesCleared > 0) {
      // Calculate score based on lines
      score += linesCleared * 100;
      // Bonus for multiple lines
      if (linesCleared > 1) score += (linesCleared - 1) * 50;

      for (int r in rowsToClear) {
        for (int c = 0; c < boardSize; c++) {
          board[r][c] = null;
        }
      }
      for (int c in colsToClear) {
        for (int r = 0; r < boardSize; r++) {
          board[r][c] = null;
        }
      }
    }
  }

  int _getShapeScore(List<List<int>> matrix) {
    int blocks = 0;
    for (var row in matrix) {
      for (var val in row) {
        if (val == 1) blocks++;
      }
    }
    return blocks * 10;
  }

  void reset() {
    board = List.generate(boardSize, (_) => List.filled(boardSize, null));
    score = 0;
    isGameOver = false;
    notifyListeners();
  }

  void checkGameOver(List<List<List<int>>> availableShapesMatrix) {
    bool canPlaceAny = false;
    for (var shapeMatrix in availableShapesMatrix) {
      for (int r = 0; r < boardSize; r++) {
        for (int c = 0; c < boardSize; c++) {
          if (canPlace(r, c, shapeMatrix)) {
            canPlaceAny = true;
            break;
          }
        }
        if (canPlaceAny) break;
      }
      if (canPlaceAny) break;
    }

    if (!canPlaceAny && availableShapesMatrix.isNotEmpty) {
      isGameOver = true;
      notifyListeners();
    }
  }
}
