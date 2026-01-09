import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'firebase_options.dart'; 

import 'screens/login_screen.dart';

import 'screens/user_data_screen.dart'; 

import 'text_to_speech.dart';
import 'speech_to_text_manager.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
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
      
      home: const AuthWrapper(),

     
      routes: {
        '/personal_data_screen': (context) => const PersonalDataScreen(),
        
        '/home_screen': (context) => const MainHomeScreen(), 
        
        '/login_screen': (context) => const LoginScreen(),
      }
    );
  }
}


class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        
        
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        
        if (snapshot.hasData) {
          return const MainHomeScreen();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}


class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<MainHomeScreen> {
  final TextToSpeech _tts = TextToSpeech();
  final SpeechManager _stt = SpeechManager();
  final ImagePicker _picker = ImagePicker();

  String _displayText = "Initializing...";
  Color _bgColor = Colors.blueAccent;
  File? _imageFile;
  bool _isListening = false;
  String? _pendingCommand; 
  static const String _serverUrl = 'http://10.0.2.2:8000/detect';

  @override
  void initState() {
    super.initState();
    _setupTools();
  }
  
  Future<void> _signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      await _tts.speak("You have been signed out.");
    } catch (e) {
      await _tts.speak("Error signing out.");
      print(e);
    }
  }


  Future<void> _setupTools() async {
    await _tts.initTTS();

    bool initialized = await _stt.initSTT();

    if (initialized) {
      await _tts.speak("Welcome. Tap anywhere to start speaking.");
      setState(() {
        _displayText = "Tap Anywhere to Speak...";
      });
    } else {
      await _tts.speak("Warning! Speech recognition failed to initialize. Please check permissions.");
      setState(() {
        _displayText = "STT Failed! Check Permissions.";
        _bgColor = Colors.red;
      });
    }
  }

  void _startListening() async {
    if (_pendingCommand != null && _stt.isListening) {
      return;
    }

    if (_stt.isListening) {
      _stopListeningAndProcess();
      return;
    }

    setState(() {
      _isListening = true;
      _bgColor = Colors.redAccent;
      _displayText = _pendingCommand == null
          ? "Listening for command... Tap again to process."
          : "Waiting for confirmation (Yes or No)...";
    });

    _stt.startListening((result) {
      _processUserCommand(result);
    });

    await _tts.speak("Listening started. Speak now.");
  }

  void _stopListeningAndProcess() async {
    if (!_isListening) {
      await _tts.speak("Please tap once to start recording first.");
      return;
    }

    _stt.stopListening();

    setState(() {
      _isListening = false;
      _bgColor = Colors.blueAccent;
    });
  }

  void _processUserCommand(String text) async {
    String command = text.toLowerCase().trim();

    setState(() {
      _isListening = false;
      _bgColor = Colors.blueAccent;
    });

    if (_pendingCommand != null) {
      if (command.contains("yes") || command.contains("نعم") || command.contains("أجل")) {
        await _tts.speak("Command accepted. Executing now.");

        if (_pendingCommand == "scan_action") {
          await _tts.speak("Opening camera now.");
          _openCamera();
        } else if (_pendingCommand == "call_action") {
          await _tts.speak("Calling the emergency contact.");
        }

      } else if (command.contains("no") || command.contains("لا")) {
        await _tts.speak("Command cancelled.");
      } else {
        await _tts.speak("I didn't understand. Command cancelled.");
      }

      _pendingCommand = null;
      setState(() {
        _displayText = "Tap Anywhere to Speak...";
      });
      return;
    }

    if (command.contains("scan") || command.contains("detect") || command.contains("look")) {
      _pendingCommand = "scan_action";
      await _tts.speak("I heard scan. Do you want to open the camera and analyze the image? Please say yes or no.");
      _startListening(); 
    } else if (command.contains("time")) {
      String time = "${DateTime.now().hour}:${DateTime.now().minute}";
      await _tts.speak("The current time is $time");

    } else if (command.contains("call") || command.contains("اتصال")) {
      _pendingCommand = "call_action";
      await _tts.speak("Do you want to initiate a call? Please say yes or no.");
      _startListening();

    } else {
      await _tts.speak("I heard $command. This command is not recognized.");
      setState(() {
        _displayText = "I heard: $command";
      });
    }
  }

  Future<void> _openCamera() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);

    if (photo != null) {
      File capturedImage = File(photo.path);
      setState(() {
        _imageFile = capturedImage;
        _displayText = "Image captured. Analyzing...";
      });

      await _uploadImageToServer(capturedImage);
    } else {
      await _tts.speak("Camera closed without taking a photo.");
    }
  }

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
        await _tts.speak(
            "Server connection successful, but got an error. Status code ${response.statusCode}");
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
    return GestureDetector(
      onTap: _startListening,
      onDoubleTap: _stopListeningAndProcess,
      child: Scaffold(
        backgroundColor: _bgColor,
        appBar: AppBar(
            title: const Text("Vision Assistant"),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: _signOut,
                tooltip: 'Sign Out',
              ),
            ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
                  style: const TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 50),

              Icon(
                _isListening ? Icons.hearing : Icons.mic_none,
                size: 80,
                color: Colors.white,
              ),

              const SizedBox(height: 15),
              const Text(
                "Tap Anywhere to Speak\nDouble Tap to Process (or tap once)",
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