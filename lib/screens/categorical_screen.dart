import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart'; 
// 💡 استيراد الشاشات المطلوبة للربط الصحيح
import 'home_screen.dart'; 
import 'add_contact_screen.dart';

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
    // بدء المساعد الصوتي بمجرد فتح الشاشة
    Future.delayed(const Duration(milliseconds: 500), () {
      _initVoiceAndSpeak();
    });
  }

  // تهيئة الصوت بالإنجليزية ونطق التعليمات
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
        centerTitle: true,
        title: const Text(
          "Choose Your Category",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),
            
            // --- 1. Elderly Category (الربط الصحيح) ---
            _buildCategoryCard(
              title: "Elderly",
              imagePath: "lib/assets/eldry.png",
              voiceMsg: "Elderly category selected. Opening your features menu.",
              onTap: () {
                // ✅ التعديل: ننتقل لـ CategoryHomeScreen وليس MainHomeScreen
                Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => const CategoryHomeScreen(categoryName: 'Elderly'))
                );
              },
            ),

            const SizedBox(height: 30),

            // --- 2. Student Category ---
            _buildCategoryCard(
              title: "Student",
              imagePath: "lib/assets/student.png",
              voiceMsg: "Student category selected.",
              onTap: () {
                Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => const CategoryHomeScreen(categoryName: 'Student'))
                );
              },
            ),

            const SizedBox(height: 30),

            // --- 3. Children Category ---
            _buildCategoryCard(
              title: "Children",
              imagePath: "lib/assets/child.png",
              voiceMsg: "Children category selected.",
              onTap: () {
                Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => const CategoryHomeScreen(categoryName: 'Children'))
                );
              },
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // ودجت بناء الكروت مع تفعيل النطق عند اللمس
  Widget _buildCategoryCard({
    required String title,
    required String imagePath,
    required String voiceMsg,
    required VoidCallback onTap,
  }) {
    return Center(
      child: GestureDetector(
        onTap: () {
          _speak(voiceMsg); 
          onTap(); 
        },
        child: Container(
          width: 320,
          height: 140,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: const Color(0xff3E5268),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5))
            ],
          ),
          child: Row(
            children: [
              const SizedBox(width: 25),
              // أيقونة الفئة
              Container(
                width: 70, height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(image: AssetImage(imagePath), fit: BoxFit.cover),
                ),
              ),
              const SizedBox(width: 25),
              Text(
                title,
                style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _flutterTts.stop(); 
    super.dispose();
  }
}