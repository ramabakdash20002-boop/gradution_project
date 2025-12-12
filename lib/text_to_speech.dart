import 'package:flutter_tts/flutter_tts.dart';

class TextToSpeech {
  final FlutterTts _flutterTts = FlutterTts();

  Future<void> initTTS() async {
    // إعدادات اللغة والصوت
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);

    // *تعديل هام:* السطر ده بيخلي التطبيق يعرف إن "النطق خلص"
    // فبالتالي نقدر نستخدم await في الملف الرئيسي وننتظر انتهاء الكلام
    await _flutterTts.awaitSpeakCompletion(true);
  }

  Future<void> speak(String text) async {
    if (text.isNotEmpty) {
      await _flutterTts.speak(text);
    }
  }

  Future<void> stop() async {
    await _flutterTts.stop();
  }
}