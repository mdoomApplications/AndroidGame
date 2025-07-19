import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechService {
  static final FlutterTts _flutterTts = FlutterTts();
  static final stt.SpeechToText _speech = stt.SpeechToText();
  static bool _isListening = false;

  static Future<void> initializeTTS() async {
    await _flutterTts.setLanguage("cs-CZ");
    await _flutterTts.setSpeechRate(0.9);
    await _flutterTts.setPitch(1.2);
    await _flutterTts.setVolume(0.8);
  }

  static Future<void> speak(String text) async {
    await _flutterTts.stop();
    await _flutterTts.speak(text);
  }

  static Future<bool> initializeSpeechRecognition() async {
    bool available = await _speech.initialize(
      onStatus: (status) => print('Speech status: $status'),
      onError: (error) => print('Speech error: $error'),
    );
    return available;
  }

  static Future<String?> startListening() async {
    if (_isListening) return null;
    
    bool available = await _speech.hasPermission;
    if (!available) {
      available = await initializeSpeechRecognition();
    }
    
    if (!available) return null;

    String? result;
    
    await _speech.listen(
      onResult: (val) {
        result = val.recognizedWords;
      },
      listenFor: Duration(seconds: 5),
      pauseFor: Duration(seconds: 3),
      localeId: 'cs_CZ',
    );
    
    _isListening = true;
    
    // Počkáme na dokončení naslouchání
    while (_speech.isListening) {
      await Future.delayed(Duration(milliseconds: 100));
    }
    
    _isListening = false;
    return result;
  }

  static Future<void> stopListening() async {
    await _speech.stop();
    _isListening = false;
  }

  static bool get isListening => _isListening;
}