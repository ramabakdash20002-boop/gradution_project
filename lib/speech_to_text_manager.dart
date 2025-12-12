import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechManager {
  // كائن مكتبة تحويل الكلام لنص
  late stt.SpeechToText _speech;
  bool _isListening = false;

  // دالة التهيئة: بتشيك إذا الموبايل بيدعم الخدمة ولا لأ
  Future<bool> initSTT() async {
    _speech = stt.SpeechToText();
    try {
      bool available = await _speech.initialize(
        onStatus: (status) => print('STT Status: $status'), // عشان نتابع الحالة في الكونسول
        onError: (error) => print('STT Error: $error'),     // لو حصل خطأ يظهر لنا
      );
      return available;
    } catch (e) {
      print("Error initializing STT: $e");
      return false;
    }
  }

  // دالة بدء الاستماع
  // بتاخد دالة (onResult) عشان ترجعلك الكلام أول بأول
  void startListening(Function(String) onResult) {
    if (!_isListening) {
      _speech.listen(
        onResult: (val) => onResult(val.recognizedWords), // بنرجع الكلمات اللي اتعرف عليها
        localeId: "en-US",                // ضبط اللغة للعربية (مصر)
        cancelOnError: true,              // يلغي لو حصل خطأ
        partialResults: true,             // يظهر النتائج وهي بتتكتب (مش لازم يستنى لما تخلصي جملة)
        listenMode: stt.ListenMode.dictation, // وضع الإملاء لدقة أعلى
      );
      _isListening = true;
    }
  }

  // دالة إيقاف الاستماع يدوياً (لو حبينا نستخدمها)
  void stopListening() {
    if (_isListening) {
      _speech.stop();
      _isListening = false;
    }
  }
}