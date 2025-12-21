import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart'; // Import TTS library
import 'package:gradution_project/screens/add_contact_screen.dart';
import 'package:gradution_project/screens/home_screen.dart';

class CategoricalScreen extends StatefulWidget {
  const CategoricalScreen({super.key});

  @override
  State<CategoricalScreen> createState() => _CategoricalScreenState();
}

class _CategoricalScreenState extends State<CategoricalScreen> {
  final FlutterTts _flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    // Start voice assistant as soon as the screen opens
    Future.delayed(const Duration(milliseconds: 500), () {
      _initVoiceAndSpeak();
    });
  }

  // Initialize TTS in English and speak welcome message
  Future<void> _initVoiceAndSpeak() async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);
    await _flutterTts.setSpeechRate(0.5);

    await _flutterTts.speak(
      "Welcome. Please choose your category. You have three options: Elderly, Student, and Children. Tap any option to select."
    );
  }

  Future<void> _speak(String text) async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff243647),
      appBar: AppBar(
        backgroundColor: const Color(0xff243647),
        elevation: 0,
        title: Align(
          alignment: Alignment.centerRight,
          child: Image.asset("lib/assets/image.png", height: 38, width: 38),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 20),
              child: Align(
                alignment: Alignment.topCenter,
                child: Text(
                  "Choose Your Category",
                  style: TextStyle(
                    color: Colors.white, 
                    fontWeight: FontWeight.bold, 
                    fontSize: 26
                  ),
                ),
              ),
            ),
            const SizedBox(height: 50),
            
            // --- 1. Elderly Category ---
            _buildCategoryCard(
              title: "Elderly",
              imagePath: "lib/assets/eldry.png",
              voiceMsg: "Elderly category selected",
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
              },
            ),

            const SizedBox(height: 40),

            // --- 2. Student Category ---
            _buildCategoryCard(
              title: "Student",
              imagePath: "lib/assets/student.png",
              voiceMsg: "Student category selected",
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const NewContactScreen()));
              },
            ),

            const SizedBox(height: 40),

            // --- 3. Children Category ---
            _buildCategoryCard(
              title: "Children",
              imagePath: "lib/assets/child.png",
              voiceMsg: "Children category selected",
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const NewContactScreen()));
              },
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // Helper widget to build the category cards with voice feedback
  Widget _buildCategoryCard({
    required String title,
    required String imagePath,
    required String voiceMsg,
    required VoidCallback onTap,
  }) {
    return Center(
      child: GestureDetector(
        onTap: () {
          _speak(voiceMsg); // Speak when tapped
          onTap(); // Navigate to the next screen
        },
        child: Container(
          width: 290,
          height: 130,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: const Color(0xff3E5268),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 5),
              )
            ],
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage(imagePath),
                    ),
                    borderRadius: BorderRadius.circular(33),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white, 
                  fontSize: 32, 
                  fontWeight: FontWeight.w500
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _flutterTts.stop(); // Stop voice when leaving the screen
    super.dispose();
  }
}