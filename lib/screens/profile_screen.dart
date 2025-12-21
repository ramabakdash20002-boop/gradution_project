import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart'; // 1. استيراد مكتبة النطق

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // 2. تعريف محرك النطق
  final FlutterTts _flutterTts = FlutterTts();

  // بيانات المستخدم
  final Map<String, String> userData = {
    'الهاتف': '+20 100 000 0000',
    'العنوان': 'القاهرة، مصر',
    'تاريخ الميلاد': '1 يناير 2000',
    'الجنس': 'ذكر أو أنثى',
  };

  @override
  void initState() {
    super.initState();
    // 3. رسالة ترحيبية فور الدخول للشاشة
    Future.delayed(const Duration(milliseconds: 500), () {
      _initVoiceOver();
    });
  }

  Future<void> _initVoiceOver() async {
    await _flutterTts.setLanguage("ar-SA");
    await _flutterTts.setPitch(1.0);
    await _flutterTts.setSpeechRate(0.5);

    await _flutterTts.speak("أهلاً بك في شاشة ملفك الشخصي. يمكنك استعراض بياناتك أو الوصول إلى جهات الاتصال والطوارئ.");
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
        centerTitle: true,
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            _speak("العودة للخلف");
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              _speak("فتح الإعدادات");
            },
          )
        ],
      ),

      // ===== Body =====
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),

            // صورة البروفايل
            GestureDetector(
              onTap: () => _speak("صورة الملف الشخصي"),
              child: const CircleAvatar(
                radius: 60,
                backgroundColor: Color(0xFF3B485C),
                child: Icon(Icons.person, size: 80, color: Colors.white),
              ),
            ),
            const SizedBox(height: 10),

            GestureDetector(
              onTap: () => _speak("اسم المستخدم الحالي هو يوزر نيم"),
              child: const Text(
                'User name',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            const SizedBox(height: 4),

            GestureDetector(
              onTap: () => _speak("البريد الإلكتروني هو يوزر نيم آت إكزامبل دوت كوم"),
              child: const Text(
                'username@example.com',
                style: TextStyle(fontSize: 16, color: Colors.white70),
              ),
            ),
            const SizedBox(height: 30),

            // تفاصيل البروفايل
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: const Color(0xFF3B485C),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  children: userData.entries.map((entry) {
                    return ProfileDetailRow(
                      label: entry.key,
                      value: entry.value,
                      onTap: () => _speak("${entry.key} هو ${entry.value}"),
                    );
                  }).toList(),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // أزرار الإجراءات
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: ProfileActionButton(
                      icon: Icons.people_outline,
                      label: 'Contacts',
                      onPressed: () {
                        _speak("فتح قائمة جهات الاتصال");
                      },
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: ProfileActionButton(
                      icon: Icons.phone_in_talk_outlined,
                      label: 'Emergency',
                      onPressed: () {
                        _speak("فتح قائمة أرقام الطوارئ");
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _flutterTts.stop(); // إيقاف الصوت عند الخروج
    super.dispose();
  }
}

// صف تفصيلة معدل لدعم النطق
class ProfileDetailRow extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onTap;

  const ProfileDetailRow({
    super.key,
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 16, color: Colors.white70)),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// زر الإجراءات
class ProfileActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const ProfileActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF3B485C),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      child: Column(
        children: [
          const Icon(Icons.more_horiz, size: 16, color: Colors.white70),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
