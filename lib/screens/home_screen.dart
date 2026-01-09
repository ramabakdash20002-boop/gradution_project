import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
// التأكد من استيراد شاشة الرؤية لفتحها
import 'vision_screen.dart'; 

class CategoryHomeScreen extends StatefulWidget {
  final String categoryName; // Elderly, Student, Children

  const CategoryHomeScreen({super.key, required this.categoryName});

  @override
  State<CategoryHomeScreen> createState() => _CategoryHomeScreenState();
}

class _CategoryHomeScreenState extends State<CategoryHomeScreen> {
  final FlutterTts _flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _announceMode();
  }

  // 🔊 المساعد الصوتي يشرح الخيارات المتاحة في هذه الشاشة (تم التعديل لـ 4 خيارات)
  Future<void> _announceMode() async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setSpeechRate(0.5);

    String otherOption = _getOtherTitle();
    String message = "Welcome to ${widget.categoryName} home. "
        "You have four features available. "
        "First: AI Vision Camera. "
        "Second: Indoor Navigation. "
        "Third: Emergency SOS. "
        "And Fourth: $otherOption.";
    
    await _flutterTts.speak(message);
  }

  Future<void> _speak(String text) async {
    await _flutterTts.speak(text);
  }

  String _getOtherTitle() {
    if (widget.categoryName == "Children") return "Stories & Games";
    if (widget.categoryName == "Student") return "Study Materials";
    return "News & Daily Updates";
  }

  IconData _getOtherIcon() {
    if (widget.categoryName == "Children") return Icons.auto_stories;
    if (widget.categoryName == "Student") return Icons.menu_book;
    return Icons.newspaper;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A232D),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("${widget.categoryName} Mode"),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        children: [
          // 1. AI Vision Camera
          _buildFeatureButton(
            title: "AI Vision Camera",
            icon: Icons.camera_enhance,
            color: const Color(0xFF2196F3),
            voiceMsg: "Opening AI Vision Camera. Please point your phone forward.",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const VisionScreen()),
              );
            },
          ),

          // 2. Indoor Navigation
          _buildFeatureButton(
            title: "Indoor Navigation",
            icon: Icons.near_me,
            color: const Color(0xFF673AB7),
            voiceMsg: "Starting indoor guidance system.",
            onTap: () => _speak("This feature is coming soon."),
          ),

          // 3. Emergency SOS
          _buildFeatureButton(
            title: "Emergency SOS",
            icon: Icons.warning_rounded,
            color: const Color(0xFFE91E63),
            voiceMsg: "Activating Emergency SOS.",
            onTap: () => _speak("SOS signal ready."),
          ),

          // 4. Other Option (Dynamic based on category)
          _buildFeatureButton(
            title: _getOtherTitle(),
            icon: _getOtherIcon(),
            color: const Color(0xFFFF9800),
            voiceMsg: "Opening ${_getOtherTitle()}.",
            onTap: () => _speak("Opening extra features."),
          ),
          
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  // ودجت لبناء أزرار المميزات بشكل متسق
  Widget _buildFeatureButton({
    required String title,
    required IconData icon,
    required Color color,
    required String voiceMsg,
    required VoidCallback onTap,
  }) {
    return Container(
      height: 140,
      margin: const EdgeInsets.only(bottom: 20),
      child: GestureDetector(
        onTap: () {
          _speak(voiceMsg);
          onTap();
        },
        child: Container(
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: color, width: 2),
          ),
          child: Row(
            children: [
              const SizedBox(width: 30),
              Icon(icon, size: 50, color: color),
              const SizedBox(width: 30),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: color.withOpacity(0.5)),
              const SizedBox(width: 20),
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