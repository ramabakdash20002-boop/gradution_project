import 'package:flutter/material.dart';

class StudentScreen extends StatelessWidget {
  const StudentScreen({super.key});

  // ألوان
  final Color _darkBackground = const Color(0xFF1A232F); 
  final Color _buttonColor = const Color(0xFF283542); 
  final Color _userIconColor = const Color(0xFF42A5F5); 

  // دالة مساعدة لإنشاء الأزرار الكبيرة
  Widget _buildLargeButton(String text, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: _buttonColor,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 80),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 5,
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
      backgroundColor: _darkBackground,
      appBar: AppBar(
        backgroundColor: _darkBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // <- هذا هو السطر اللي يفعل الرجوع
          },
        ),
        title: const Text(
          'Student',
          style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
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
            _buildLargeButton('Courses', () {
              print('Courses Button Tapped');
              // مثال على التنقل لشاشة أخرى:
              // Navigator.push(context, MaterialPageRoute(builder: (context) => CoursesScreen()));
            }),

            // زر Books
            _buildLargeButton('Books', () {
              print('Books Button Tapped');
              // مثال على التنقل لشاشة أخرى:
              // Navigator.push(context, MaterialPageRoute(builder: (context) => BooksScreen()));
            }),

            // زر Podcast
            _buildLargeButton('Podcast', () {
              print('Podcast Button Tapped');
              // مثال على التنقل لشاشة أخرى:
              // Navigator.push(context, MaterialPageRoute(builder: (context) => PodcastScreen()));
            }),
          ],
        ),
      ),
    );
  }
}
