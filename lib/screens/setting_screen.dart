import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // --- حالة الشرائح المنزلقة ---
  double _speechRate = 0.5;
  double _volume = 0.7;
  double _fontSize = 0.6;

  // --- حالة اللغة ---
  String _selectedLanguage = 'English';

  // --- حالة المفاتيح ---
  bool _hapticFeedbackEnabled = true;
  bool _highContrastEnabled = false;
  bool _iconDescriptionEnabled = true;

  // ألوان
  final Color _darkBackground = const Color(0xFF1A232F);
  final Color _sliderActiveColor = const Color(0xFF42A5F5);

  // دوال المساعدة لبناء الشرائح والمفاتيح
  Widget _buildSliderSetting(String title, double value, Function(double) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.white70, fontSize: 16)),
          Slider(
            value: value,
            min: 0.0,
            max: 1.0,
            divisions: 100,
            activeColor: _sliderActiveColor,
            inactiveColor: Colors.white30,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchSetting(String title, bool value, Function(bool) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500)),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: _sliderActiveColor,
            inactiveThumbColor: Colors.white30,
            inactiveTrackColor: Colors.white12,
          ),
        ],
      ),
    );
  }

  Widget _buildRadioOption(String lang) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Radio<String>(
          value: lang,
          groupValue: _selectedLanguage,
          onChanged: (String? value) {
            setState(() {
              _selectedLanguage = value!;
            });
          },
          activeColor: _sliderActiveColor,
        ),
        Text(lang, style: const TextStyle(color: Colors.white, fontSize: 16)),
      ],
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
            Navigator.pop(context); // <- هاد بيخلي السهم يرجع للصفحة السابقة
          },
        ),
        title: const Text(
          'Settings',
          style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundColor: Color(0xFF42A5F5),
              child: Icon(Icons.person, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Voice & Audio ---
            const Padding(
              padding: EdgeInsets.only(left: 16.0, top: 16.0, bottom: 8.0),
              child: Text('Voice & Audio', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            _buildSliderSetting('Speech Rate', _speechRate, (v) => setState(() => _speechRate = v)),
            _buildSliderSetting('Volume', _volume, (v) => setState(() => _volume = v)),
            _buildSliderSetting('Font size', _fontSize, (v) => setState(() => _fontSize = v)),

            const Divider(color: Colors.white24, height: 1),

            // --- Language ---
            Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 16.0, bottom: 8.0),
              child: Row(
                children: [
                  const Icon(Icons.language, color: Colors.white70, size: 24),
                  const SizedBox(width: 8),
                  const Text('Language', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500)),
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildRadioOption('English'),
                      _buildRadioOption('Arabic'),
                    ],
                  ),
                  const SizedBox(width: 16),
                ],
              ),
            ),

            const Divider(color: Colors.white24, height: 1),

            // --- Switches ---
            _buildSwitchSetting('Haptic Feedback', _hapticFeedbackEnabled, (v) => setState(() => _hapticFeedbackEnabled = v)),
            _buildSwitchSetting('High Contrast', _highContrastEnabled, (v) => setState(() => _highContrastEnabled = v)),
            _buildSwitchSetting('Icon Description', _iconDescriptionEnabled, (v) => setState(() => _iconDescriptionEnabled = v)),

            const Divider(color: Colors.white24, height: 1),

            // --- Sign Out ---
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
              child: InkWell(
                onTap: () {
                  print('Sign Out Tapped');
                },
                child: const Text('Sign out', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
