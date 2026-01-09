import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:async';
// تأكدي أن هذا المسار هو المسار الصحيح للشاشة الرئيسية في مشروعك
import '../main.dart'; 

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _initSequence();
  }

  // دالة لترتيب العمليات (النطق بالإنجليزية ثم الانتقال)
  void _initSequence() async {
    // 1. إعدادات الصوت باللغة الإنجليزية
    await flutterTts.setLanguage("en-US"); // تغيير اللغة للإنجليزية
    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(0.5); // سرعة نطق متوسطة
    
    // نطق النص بالإنجليزية
    await flutterTts.speak("Welcome to Odyssey"); 

    // 2. الانتظار لمدة 3 ثوانٍ للسماح للمستخدم برؤية اللوجو وسماع الصوت
    Timer(const Duration(seconds: 4), () {
      if (mounted) {
        // الانتقال التلقائي للشاشة الرئيسية (MainHomeScreen)
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const MainHomeScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // لون الخلفية أزرق غامق متناسق مع التصميم
      backgroundColor: const Color(0xFF22303F), 
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // عرض شعار التطبيق
            Image.asset(
              'assets/logo.png', 
              width: 220,
              errorBuilder: (context, error, stackTrace) {
                // عرض نص بديل في حال لم يتم العثور على ملف الصورة في assets
                return Column(
                  children: [
                    const Icon(Icons.visibility, color: Colors.blueAccent, size: 80),
                    const SizedBox(height: 20),
                    const Text(
                      'odyssey',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Your Smart Eye",
                      style: TextStyle(color: Colors.white54, fontSize: 16),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // إيقاف الصوت عند الانتقال لشاشة أخرى
    flutterTts.stop();
    super.dispose();
  }
}