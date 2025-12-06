import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  // بيانات المستخدم
  final Map<String, String> userData = {
    'phone': '+20 100 000 0000',
    'Address': 'Cairo, Egypt',
    'Birthday': 'Jan 1, 2000',
    'Gender': 'Female/Male',
  };

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
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              print("Settings");
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
            const CircleAvatar(
              radius: 60,
              backgroundColor: Color(0xFF3B485C),
              child: Icon(Icons.person, size: 80, color: Colors.white),
            ),
            const SizedBox(height: 10),

            const Text(
              'User name',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),

            const Text(
              'username@example.com',
              style: TextStyle(fontSize: 16, color: Colors.white70),
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
                      onPressed: () {},
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: ProfileActionButton(
                      icon: Icons.phone_in_talk_outlined,
                      label: 'Emergency',
                      onPressed: () {},
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
}

// صف تفصيلة
class ProfileDetailRow extends StatelessWidget {
  final String label;
  final String value;

  const ProfileDetailRow({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
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
