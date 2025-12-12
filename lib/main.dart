import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:io';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

// استيراد ملفاتك الخاصة
import 'package:gradution_project/screens/splash_screen.dart'; 
import 'text_to_speech.dart';
import 'speech_to_text_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // يمكنك إزالة هذا السطر إذا كنتِ لا تستخدمين Firebase
  // await Firebase.initializeApp(); 
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Vision Assistant',
      theme: ThemeData(primarySwatch: Colors.blue),
      // إذا كانت شاشة Splash تسبب مشاكل، استخدمي home: const HomeScreen()
      home: const SplashScreen(), 
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextToSpeech _tts = TextToSpeech();
  final SpeechManager _stt = SpeechManager();
  final ImagePicker _picker = ImagePicker(); 

  String _displayText = "Tap Anywhere to Speak..."; // تحديث الرسالة
  Color _bgColor = Colors.blueAccent;
  File? _imageFile;
  bool _isListening = false;
  
  // **مهم:** يجب تعديل هذا العنوان إلى IP الخاص بسيرفر FastAPI
  static const String _serverUrl = 'http://YOUR_SERVER_IP:8000/detect'; 

  @override
  void initState() {
    super.initState();
    _setupTools();
  }

  Future<void> _setupTools() async {
    await _tts.initTTS();
    await _stt.initSTT();
    // ترحيب صوتي واضح
    await _tts.speak("Welcome. Tap anywhere to start speaking.");
  }

  // بدء الاستماع (بضغطة واحدة - Tap)
  void _startListening() {
    // نوقف أي استماع سابق قبل البدء من جديد
    if (_isListening) {
      _stt.stopListening();
    }
    
    _stt.startListening((result) {
      setState(() {
        _displayText = result;
        _isListening = true;
        _bgColor = Colors.redAccent; 
      });
    });
    
    // إشارة صوتية فورية
    _tts.speak("Listening started. Speak now.");
  }

  // إيقاف الاستماع ومعالجة الأمر (بضغطتين - Double Tap)
  void _stopListeningAndProcess() async {
    if (!_isListening) {
        await _tts.speak("Please tap once to start recording first.");
        return; 
    }
    
    _stt.stopListening();
    
    // استدعاء دالة تحليل الأمر
    _processUserCommand(_displayText); 
  }
  
  // دالة تحليل أوامر المستخدم
  void _processUserCommand(String text) async {
    String command = text.toLowerCase();
    
    setState(() {
      _isListening = false;
      _bgColor = Colors.blueAccent; 
    });

    // منطق أمر الكشف البصري
    if (command.contains("scan") || command.contains("detect") || command.contains("look")) {
      await _tts.speak("Opening camera now.");
      _openCamera(); 
    } 
    // أمر إضافي: معرفة الوقت (لاختبار عمل STT/TTS)
    else if (command.contains("time")) {
      String time = "${DateTime.now().hour}:${DateTime.now().minute}";
      await _tts.speak("The current time is $time");
    }
    // إذا لم يفهم الأمر
    else {
      await _tts.speak("I heard $command. Please tap once, then say scan, then double tap.");
    }
  }

  // فتح الكاميرا والتقاط صورة
  Future<void> _openCamera() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);

    if (photo != null) {
      File capturedImage = File(photo.path);
      setState(() {
        _imageFile = capturedImage;
        _displayText = "Image captured. Analyzing...";
      });

      // إرسال الصورة للسيرفر
      await _uploadImageToServer(capturedImage);
      
    } else {
      await _tts.speak("Camera closed without taking a photo.");
    }
  }

  // دالة إرسال الصورة للسيرفر واستقبال النتيجة
  Future<void> _uploadImageToServer(File imageFile) async {
    setState(() {
      _displayText = "Sending image to server ($_serverUrl)...";
    });
    
    try {
      var uri = Uri.parse(_serverUrl);
      var request = http.MultipartRequest('POST', uri)
        ..files.add(await http.MultipartFile.fromPath(
          'file', 
          imageFile.path,
        ));

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        String result = response.body; 
        
        setState(() {
          _displayText = "Result: $result";
        });
        
        await _tts.speak(result);
        
      } else {
        String errorMsg = "Server Error: Status ${response.statusCode}";
        setState(() => _displayText = errorMsg);
        await _tts.speak("Server connection successful, but got an error. Status code ${response.statusCode}");
      }
    } catch (e) {
      String errorMsg = "Connection Failed. Check IP or Network.";
      setState(() => _displayText = errorMsg);
      await _tts.speak("Connection failed. Please check the network and server address.");
      print("Connection Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    // نلف الشاشة بأكملها بـ GestureDetector لسهولة الوصول
    return GestureDetector(
      onTap: _startListening,          // ضغطة واحدة للبدء
      onDoubleTap: _stopListeningAndProcess, // ضغطتان للتنفيذ
      child: Scaffold(
        backgroundColor: _bgColor,
        appBar: AppBar(title: const Text("Vision Assistant"), centerTitle: true),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // عرض الصورة إذا تم التقاطها
              if (_imageFile != null)
                Container(
                  margin: const EdgeInsets.all(20),
                  height: 250,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(13),
                    child: Image.file(_imageFile!, fit: BoxFit.cover),
                  ),
                ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  _displayText,
                  style: const TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 50),

              // إشارة مرئية لحالة الاستماع
              Icon(
                _isListening ? Icons.hearing : Icons.mic_none, 
                size: 80,
                color: Colors.white,
              ),

              const SizedBox(height: 15),
              const Text(
                "Tap Anywhere to Speak\nDouble Tap to Process", 
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ),
      ),
    );
  }
}