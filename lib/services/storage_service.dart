import 'package:shared_preferences/shared_preferences.dart';
import '../models/dragon_model.dart';

class StorageService {
  static const String _dragonKey = 'dragon_data';
  
  static Future<void> saveDragon(DragonModel dragon) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_dragonKey, dragon.toJson());
  }
  
  static Future<DragonModel?> loadDragon() async {
    final prefs = await SharedPreferences.getInstance();
    final dragonJson = prefs.getString(_dragonKey);
    
    if (dragonJson != null) {
      try {
        return DragonModel.fromJson(dragonJson);
      } catch (e) {
        print('Error loading dragon: $e');
        return null;
      }
    }
    
    return null;
  }
  
  static Future<void> clearData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_dragonKey);
  }
}