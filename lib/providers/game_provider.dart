import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import '../models/dragon_model.dart';
import '../services/storage_service.dart';

enum GamePhase { nameInput, hatching, playing, gameOver }

class GameProvider extends ChangeNotifier {
  GamePhase _gamePhase = GamePhase.nameInput;
  DragonModel? _dragon;
  Timer? _gameTimer;
  Timer? _hatchTimer;
  
  int _hatchCountdown = 3;
  bool _isHatching = false;
  String _gameOverReason = '';
  
  GamePhase get gamePhase => _gamePhase;
  DragonModel? get dragon => _dragon;
  int get hatchCountdown => _hatchCountdown;
  bool get isHatching => _isHatching;
  String get gameOverReason => _gameOverReason;

  GameProvider() {
    _loadGame();
  }

  void _loadGame() async {
    final savedDragon = await StorageService.loadDragon();
    if (savedDragon != null) {
      _dragon = savedDragon;
      if (_dragon!.isAlive) {
        _gamePhase = GamePhase.playing;
        _startGameLoop();
      } else {
        _gamePhase = GamePhase.gameOver;
        _gameOverReason = 'Dráček zemřel během tvé nepřítomnosti';
      }
      notifyListeners();
    }
  }

  void startGame(String name) {
    if (name.isEmpty || name.length < 2) return;
    
    _dragon = DragonModel(name: name.toUpperCase());
    _gamePhase = GamePhase.hatching;
    _hatchCountdown = 3;
    _isHatching = true;
    
    _startHatchingCountdown();
    notifyListeners();
  }

  void _startHatchingCountdown() {
    _hatchTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      _hatchCountdown--;
      
      if (_hatchCountdown <= 0) {
        timer.cancel();
        _isHatching = false;
      }
      
      notifyListeners();
    });
  }

  void hatchDragon() {
    if (_isHatching || _hatchCountdown > 0) return;
    
    _hatchTimer?.cancel();
    _gamePhase = GamePhase.playing;
    _startGameLoop();
    _saveDragon();
    notifyListeners();
  }

  void _startGameLoop() {
    _gameTimer = Timer.periodic(Duration(seconds: 5), (timer) {
      if (_dragon == null || !_dragon!.isAlive) {
        timer.cancel();
        return;
      }
      
      _dragon!.updateStats();
      
      // Přidání věku
      if (Random().nextDouble() < 0.15) {
        _dragon!.age++;
      }
      
      if (!_dragon!.isAlive) {
        _gamePhase = GamePhase.gameOver;
        _gameOverReason = _getDeathReason();
        timer.cancel();
      }
      
      _saveDragon();
      notifyListeners();
    });
  }

  String _getDeathReason() {
    if (_dragon!.hunger <= 0) return 'DRÁČEK ZEMŘEL HLADY! 🍖';
    if (_dragon!.thirst <= 0) return 'DRÁČEK ZEMŘEL ŽÍZNÍ! 💧';
    if (_dragon!.mood <= 0) return 'DRÁČEK ZEMŘEL SMUTKEM! 😢';
    return 'DRÁČEK ZEMŘEL!';
  }

  void petDragon() {
    if (_dragon == null || !_dragon!.isAlive) return;
    
    _dragon!.mood = (_dragon!.mood + 8).clamp(0, 100);
    _saveDragon();
    notifyListeners();
  }

  void feedDragon() {
    if (_dragon == null || !_dragon!.isAlive) return;
    
    if (_dragon!.coins >= 8) {
      _dragon!.coins -= 8;
      _dragon!.hunger = (_dragon!.hunger + 35).clamp(0, 100);
      _saveDragon();
      notifyListeners();
    }
  }

  void giveDrink() {
    if (_dragon == null || !_dragon!.isAlive) return;
    
    if (_dragon!.coins >= 5) {
      _dragon!.coins -= 5;
      _dragon!.thirst = (_dragon!.thirst + 40).clamp(0, 100);
      _saveDragon();
      notifyListeners();
    }
  }

  void playMath() {
    if (_dragon == null || !_dragon!.isAlive) return;
    
    // Tuto logiku implementujeme v UI
    // Zde jen přidáme coiny a mood za správnou odpověď
  }

  void addCoinsForCorrectAnswer() {
    if (_dragon == null || !_dragon!.isAlive) return;
    
    _dragon!.coins += 2;
    _dragon!.mood = (_dragon!.mood + 12).clamp(0, 100);
    _saveDragon();
    notifyListeners();
  }

  void penalizeWrongAnswer() {
    if (_dragon == null || !_dragon!.isAlive) return;
    
    _dragon!.mood = (_dragon!.mood - 8).clamp(0, 100);
    _saveDragon();
    notifyListeners();
  }

  void resetGame() {
    _gameTimer?.cancel();
    _hatchTimer?.cancel();
    _dragon = null;
    _gamePhase = GamePhase.nameInput;
    _hatchCountdown = 3;
    _isHatching = false;
    _gameOverReason = '';
    
    StorageService.clearData();
    notifyListeners();
  }

  void _saveDragon() {
    if (_dragon != null) {
      StorageService.saveDragon(_dragon!);
    }
  }

  @override
  void dispose() {
    _gameTimer?.cancel();
    _hatchTimer?.cancel();
    super.dispose();
  }
}