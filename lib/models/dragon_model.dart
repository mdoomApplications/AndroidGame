import 'dart:convert';

class DragonModel {
  String name;
  double hunger;
  double thirst;
  double mood;
  int coins;
  int age;
  DateTime lastUpdate;
  
  DragonModel({
    required this.name,
    this.hunger = 100.0,
    this.thirst = 100.0,
    this.mood = 100.0,
    this.coins = 15,
    this.age = 0,
    DateTime? lastUpdate,
  }) : lastUpdate = lastUpdate ?? DateTime.now();

  bool get isAlive => hunger > 0 && thirst > 0 && mood > 0;

  String get dragonEmoji {
    if (!isAlive) return '💀';
    if (mood > 70) return '🐉';
    if (mood > 30) return '😐';
    return '😢';
  }

  void updateStats() {
    final now = DateTime.now();
    final timeDiff = now.difference(lastUpdate).inSeconds;
    
    if (timeDiff > 0) {
      // Snížení statistik v čase
      hunger = (hunger - (timeDiff * 0.3)).clamp(0, 100);
      thirst = (thirst - (timeDiff * 0.4)).clamp(0, 100);
      mood = (mood - (timeDiff * 0.2)).clamp(0, 100);
      
      lastUpdate = now;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'hunger': hunger,
      'thirst': thirst,
      'mood': mood,
      'coins': coins,
      'age': age,
      'lastUpdate': lastUpdate.toIso8601String(),
    };
  }

  factory DragonModel.fromMap(Map<String, dynamic> map) {
    return DragonModel(
      name: map['name'] ?? '',
      hunger: map['hunger']?.toDouble() ?? 100.0,
      thirst: map['thirst']?.toDouble() ?? 100.0,
      mood: map['mood']?.toDouble() ?? 100.0,
      coins: map['coins']?.toInt() ?? 15,
      age: map['age']?.toInt() ?? 0,
      lastUpdate: DateTime.parse(map['lastUpdate'] ?? DateTime.now().toIso8601String()),
    );
  }

  String toJson() => json.encode(toMap());

  factory DragonModel.fromJson(String source) => DragonModel.fromMap(json.decode(source));
}