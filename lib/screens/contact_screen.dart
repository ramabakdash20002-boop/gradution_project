import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart'; // 1. استيراد المكتبة
import 'package:gradution_project/screens/home_screen.dart';
import 'package:gradution_project/main.dart';

class NewContactScreen extends StatefulWidget {
  const NewContactScreen({super.key});

  @override
  State<NewContactScreen> createState() => _NewContactScreenState();
}

class _NewContactScreenState extends State<NewContactScreen> {
  String? _selectedRelationship;
  final List<String> _relationships = ['Family', 'Friend', 'Work', 'Emergency'];
  
  // 2. تعريف محرك النطق
  final FlutterTts _flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    // 3. رسالة ترحيبية عند فتح الشاشة
    Future.delayed(const Duration(milliseconds: 500), () {
      _initVoiceOver();
    });
  }

  Future<void> _initVoiceOver() async {
    await _flutterTts.setLanguage("ar-SA");
    await _flutterTts.setPitch(1.0);
    await _flutterTts.setSpeechRate(0.5);

    await _flutterTts.speak("شاشة إضافة جهة اتصال جديدة. يرجى إدخال الاسم، رقم الهاتف، واختيار صلة القرابة.");
  }

  Future<void> _speak(String text) async {
    await _flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2E3B4E),

      // ===== AppBar =====
      appBar: AppBar(
        backgroundColor: const Color(0xFF2E3B4E),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () {
            _speak("إلغاء وإغلاق الشاشة");
            Navigator.pop(context);
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () => _speak("الصورة الشخصية للمستخدم"),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: Image.asset('lib/assets/image.png', errorBuilder: (context, error, stackTrace) => const Icon(Icons.person)),
              ),
            ),
          ),
        ],
      ),

      // ===== Body =====
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ==== Name ====
            TextField(
              onTap: () => _speak("حقل الاسم، يرجى كتابة اسم جهة الاتصال"),
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                filled: true,
                fillColor: Color(0xFF3B485C),
                hintText: 'Name',
                hintStyle: TextStyle(color: Colors.white70),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              ),
            ),
            const SizedBox(height: 16),

            // ==== Phone ====
            TextField(
              keyboardType: TextInputType.phone,
              onTap: () => _speak("حقل رقم الهاتف"),
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                filled: true,
                fillColor: Color(0xFF3B485C),
                hintText: 'Phone Number',
                hintStyle: TextStyle(color: Colors.white70),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              ),
            ),
            const SizedBox(height: 16),

            // ==== Relationship (Dropdown) ====
            GestureDetector(
              onTap: () => _speak("قائمة اختيار صلة القرابة"),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF3B485C),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedRelationship,
                    hint: const Text('Relationship', style: TextStyle(color: Colors.white70)),
                    icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white70),
                    isExpanded: true,
                    dropdownColor: const Color(0xFF3B485C),
                    style: const TextStyle(color: Colors.white),
                    items: _relationships.map((value) {
                      return DropdownMenuItem(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedRelationship = newValue;
                      });
                      _speak("تم اختيار $newValue");
                    },
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // ==== Add Photos ====
            const Text(
              'Add Photos',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),

            GestureDetector(
              onTap: () => _speak("معرض الصور المضافة"),
              child: Container(
                height: MediaQuery.of(context).size.width * 0.8,
                decoration: BoxDecoration(
                  color: const Color(0xFF88A07A),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'ANTIARIC SAFE WORK',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // ==== Save Contact ====
            ElevatedButton(
              onPressed: () {
                _speak("جاري حفظ جهة الاتصال والعودة للقائمة الرئيسية");
                Navigator.push(context, MaterialPageRoute(builder: (context) => const MainHomeScreen()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF007AFF),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Save Contact'),
            ),
            const SizedBox(height: 16),

            // ==== Add Another Contact ====
            ElevatedButton(
              onPressed: () {
                _speak("تم الحفظ، يمكنك الآن إضافة جهة اتصال أخرى");
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3B485C),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Add Another Contact'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _flutterTts.stop(); // إيقاف الصوت عند الخروج من الشاشة
    super.dispose();
  }
}