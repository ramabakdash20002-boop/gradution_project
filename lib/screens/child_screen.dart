import 'package:flutter/material.dart';

class ChildScreen extends StatelessWidget {
  const ChildScreen({super.key});

  // تعريف اللون الداكن المستخدم في الخلفية
  final Color _darkBackground = const Color(0xFF1A232F);
  // لون أغمق قليلاً للأزرار ليمنحها عمقاً
  final Color _buttonColor = const Color(0xFF283542);
  // لون أيقونة المستخدم (Blueish color)
  final Color _userIconColor = const Color(0xFF42A5F5);

  // دالة مساعدة لإنشاء الأزرار الكبيرة
  Widget _buildLargeButton(String text, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: _buttonColor, // لون خلفية الزر
          foregroundColor: Colors.white, // لون النص داخل الزر
          minimumSize: const Size(double.infinity, 80), // عرض كامل وارتفاع 80
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15), // زوايا مستديرة
          ),
          elevation: 5, // ظل خفيف للزر
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _darkBackground, // خلفية داكنة
      appBar: AppBar(
        backgroundColor: _darkBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            // كود العودة للخلف
            // Navigator.pop(context);
          },
        ),
        title: const Text(
          'Child',
          style: TextStyle(
              color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            // أيقونة المستخدم في الزاوية العلوية اليمنى
            child: CircleAvatar(
              backgroundColor: _userIconColor,
              child: const Icon(Icons.person, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // زر Courses
            _buildLargeButton('Subjects', () {
              print('Subjects Button Tapped');
              // أضف كود التنقل هنا
            }),

            // زر Books
            _buildLargeButton('Stories', () {
              print('Stories Button Tapped');
              // أضف كود التنقل هنا
            }),

            // زر Podcast
            _buildLargeButton('Games', () {
              print('Games Button Tapped');
              // أضف كود التنقل هنا
            }),
          ],
        ),
      ),
    );
  }
}