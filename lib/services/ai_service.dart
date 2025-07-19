import 'dart:convert';
import 'package:http/http.dart' as http;

class AIService {
  static const String _apiKey = 'AIzaSyCSw0tpn7rMZ46lndRul25sI8HW8dw17Y8';
  static const String _baseUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent';

  static Future<String> getGeminiResponse(String userText, String dragonName, Map<String, dynamic> stats) async {
    if (userText.trim().isEmpty) return 'Hrrr... Nerozumím. 🐉';

    try {
      final prompt = '''
      Jsi roztomilý dráček jménem $dragonName. 
      Jsi virtuální mazlíček pro děti.
      Tvoje statistiky: hlad ${stats['hunger']}%, žízeň ${stats['thirst']}%, nálada ${stats['mood']}%.
      Věk: ${stats['age']} dní, mince: ${stats['coins']}.
      
      Odpověz krátce (max 2 věty), přátelsky a dětsky na: "$userText"
      
      Používej emotikony a česky.
      ''';

      final response = await http.post(
        Uri.parse('$_baseUrl?key=$_apiKey'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'contents': [{
            'parts': [{
              'text': prompt
            }]
          }]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['candidates'] != null && 
            data['candidates'].isNotEmpty && 
            data['candidates'][0]['content'] != null) {
          return data['candidates'][0]['content']['parts'][0]['text'];
        }
      }
      
      throw Exception('Invalid response from Gemini');
      
    } catch (error) {
      print('Gemini AI error: $error');
      
      // Fallback odpovědi
      final responses = [
        'Hrrr! Jsem tvůj dráček $dragonName! 🐉',
        'Mám hlad! Nakrm mě prosím! 🍖',
        'Hraju si rád! Děkuji za povídání! 😊',
        'Jsem mladý dráček, ale učím se! 📚',
        'Rád počítám! Dej mi nějaký příklad! 🧮',
        'Cítím se dobře když si se mnou povídáš! 💚'
      ];
      
      return responses[(DateTime.now().millisecondsSinceEpoch % responses.length)];
    }
  }
}