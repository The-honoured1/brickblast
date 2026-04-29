import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/powerup_type.dart';

class GameState extends ChangeNotifier {
  int _score = 0;
  int _highScore = 0;
  int _lives = 3;
  int _combo = 0;
  int _coins = 0;
  int _currentLevel = 1;
  PowerupType? _activePowerup;
  double _powerupTimeRemaining = 0;
  bool _isDarkMode = false;

  int get score => _score;
  int get highScore => _highScore;
  int get lives => _lives;
  int get combo => _combo;
  int get coins => _coins;
  int get currentLevel => _currentLevel;
  PowerupType? get activePowerup => _activePowerup;
  double get powerupTimeRemaining => _powerupTimeRemaining;
  bool get isDarkMode => _isDarkMode;

  GameState() {
    _loadState();
  }

  Future<void> _loadState() async {
    final prefs = await SharedPreferences.getInstance();
    _highScore = prefs.getInt('highScore') ?? 0;
    _coins = prefs.getInt('coins') ?? 0;
    _currentLevel = prefs.getInt('currentLevel') ?? 1;
    _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    notifyListeners();
  }

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    SharedPreferences.getInstance().then((prefs) => prefs.setBool('isDarkMode', _isDarkMode));
    notifyListeners();
  }

  void addScore(int points, {bool isTrickShot = false, bool speedBonus = false}) {
    int multiplier = (_combo > 0) ? _combo : 1;
    int finalPoints = points * multiplier;
    if (isTrickShot) finalPoints += 50;
    if (speedBonus) finalPoints += 20;

    _score += finalPoints;
    if (_score > _highScore) {
      _highScore = _score;
      SharedPreferences.getInstance().then((prefs) => prefs.setInt('highScore', _highScore));
    }
    notifyListeners();
  }

  void loseLife() {
    if (_lives > 0) {
      _lives--;
      _combo = 0;
      notifyListeners();
    }
  }

  void addLives(int count) {
    _lives += count;
    notifyListeners();
  }

  void incrementCombo() {
    _combo++;
    notifyListeners();
  }

  void resetCombo() {
    _combo = 0;
    notifyListeners();
  }

  void activatePowerup(PowerupType type) {
    _activePowerup = type;
    _powerupTimeRemaining = type.durationSeconds.toDouble();
    notifyListeners();
  }

  void updatePowerupTime(double dt) {
    if (_activePowerup != null && _powerupTimeRemaining > 0) {
      _powerupTimeRemaining -= dt;
      if (_powerupTimeRemaining <= 0) {
        _activePowerup = null;
        _powerupTimeRemaining = 0;
      }
      notifyListeners();
    }
  }

  void addCoins(int count) {
    _coins += count;
    SharedPreferences.getInstance().then((prefs) => prefs.setInt('coins', _coins));
    notifyListeners();
  }
  
  void nextLevel() {
    _currentLevel++;
    SharedPreferences.getInstance().then((prefs) => prefs.setInt('currentLevel', _currentLevel));
    notifyListeners();
  }

  void resetGame() {
    _score = 0;
    _lives = 3;
    _combo = 0;
    _activePowerup = null;
    notifyListeners();
  }
}
