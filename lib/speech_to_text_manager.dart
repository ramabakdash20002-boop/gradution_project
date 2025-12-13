import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechManager {
  // كائن مكتبة تحويل الكلام لنص
  late stt.SpeechToText _speech;
  bool _isListening = false;

  // إضافة خاصية وصول (Getter) لحالة الاستماع
  bool get isListening => _isListening;
  
  // دالة التهيئة: بتشيك إذا الموبايل بيدعم الخدمة ولا لأ
  Future<bool> initSTT() async {
    _speech = stt.SpeechToText();
    try {
      bool available = await _speech.initialize(
        onStatus: (status) {
           print('STT Status: $status'); 
           // تحديث الحالة الداخلية عند تغيير حالة الـ STT
           if (status == stt.SpeechToText.listeningStatus) {
             _isListening = true;
           } else {
             _isListening = false;
           }
        }, 
        onError: (error) => print('STT Error: $error'),
      );
      return available;
    } catch (e) {
      print("Error initializing STT: $e");
      return false;
    }
  }

  // دالة بدء الاستماع
  void startListening(Function(String) onResult) async {
    if (!_speech.isListening) { 
      await _speech.listen(
        onResult: (val) {
          // نرسل النتيجة فقط عندما تكون نهائية
          if (val.finalResult) {
            onResult(val.recognizedWords);
          }
        },
        localeId: "en-US", // **تعديل: ضعي هنا رمز اللغة العربية المناسب (مثل ar-EG) إذا كنت تريدين الأوامر العربية**
        cancelOnError: true,
        partialResults: false, 
        listenMode: stt.ListenMode.dictation,
        listenFor: const Duration(seconds: 5), // إضافة مهلة زمنية إفتراضية
      );
    }
  }

  // دالة إيقاف الاستماع يدوياً
  void stopListening() {
    if (_speech.isListening) {
      _speech.stop();
    }
  }
}