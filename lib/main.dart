import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'text_to_speech.dart';
import 'speech_to_text_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(), // هنا استدعينا الشاشة الجديدة
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextToSpeech _tts = TextToSpeech();
  final SpeechManager _stt = SpeechManager();
  
  String _displayText = "Loading...";
  Color _bgColor = Colors.blueAccent;

  @override
  void initState() {
    super.initState();
    _startAppFlow();
  }

  void _startAppFlow() async {
    await _tts.initTTS();
    bool isSttAvailable = await _stt.initSTT();

    if (isSttAvailable) {
      setState(() {
        _displayText = "Welcome to TEAN Mate";
      });
      
      // نطق الترحيب بالإنجليزي
      await _tts.speak("Welcome to TEAN Mate. I am listening, please speak.");

      // فتح الميكروفون بعد انتهاء الكلام
      _startListening();
    } else {
      setState(() => _displayText = "Voice service not available");
      await _tts.speak("Sorry, voice service is not available on your device.");
    }
  }

  void _startListening() {
    setState(() {
      _displayText = "I'm listening...";
      _bgColor = Colors.green; // تغيير اللون للأخضر عند الاستماع
    });

    _stt.startListening((result) {
      setState(() {
        _displayText = result;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: _bgColor,
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.mic, size: 100, color: Colors.white),
            SizedBox(height: 30),
            Text(
              _displayText,
              style: TextStyle(
                fontSize: 28, 
                color: Colors.white, 
                fontWeight: FontWeight.bold
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}