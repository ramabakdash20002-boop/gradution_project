import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_tts/flutter_tts.dart'; 
import 'dart:developer';
import '../firebase_service.dart'; 
import 'package:cloud_firestore/cloud_firestore.dart'; 
import 'categorical_screen.dart'; // Import your category screen

class PersonalDataScreen extends StatefulWidget {
  const PersonalDataScreen({super.key});

  @override
  State<PersonalDataScreen> createState() => _PersonalDataScreenState();
}

class _PersonalDataScreenState extends State<PersonalDataScreen> {
  final _firebaseService = FirebaseService();
  bool _isLoading = false;

  // TTS Engine Definition
  final FlutterTts _flutterTts = FlutterTts();

  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _contactController = TextEditingController();
  final _emailController = TextEditingController(); 
  final _passwordController = TextEditingController(); 
  final _locationController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    // Delay to ensure UI stability
    Future.delayed(const Duration(milliseconds: 500), () {
      _initVoiceOver();
    });
  }

  // Initialize TTS and speak welcome message in English
  Future<void> _initVoiceOver() async {
    await _flutterTts.setLanguage("en-US"); // Changed to English
    await _flutterTts.setPitch(1.0);
    await _flutterTts.setSpeechRate(0.5); 

    String welcomeMessage = 
        "Welcome to the registration screen. "
        "Please fill in the following fields: Name, Age, Phone, Email, and Password. "
        "You can tap any field to hear its name.";
    
    await _flutterTts.speak(welcomeMessage);
  }

  // Helper function for quick feedback
  Future<void> _speak(String text) async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.speak(text);
  }

  // Logic to guarantee navigation (Demo/Bypass Mode)
  Future<void> _registerAndSaveData() async {
    // Check basic fields
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty || _nameController.text.isEmpty) {
      _speak("Please fill in Name, Email, and Password fields.");
      _showErrorSnackBar('Please complete required fields.');
      return;
    }
    
    setState(() => _isLoading = true);
    _speak("Saving your data, please wait.");

    try {
      // Attempt Firebase Registration
      final UserCredential userCredential = await _firebaseService.auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      
      final String? uid = userCredential.user?.uid;
      if (uid != null) {
        _firebaseService.userId = uid;
        final userData = {
          'name': _nameController.text.trim(),
          'age': int.tryParse(_ageController.text.trim()),
          'contactNumber': _contactController.text.trim(),
          'email': _emailController.text.trim(),
          'location': _locationController.text.trim(),
          'createdAt': FieldValue.serverTimestamp(),
        };
        await _firebaseService.savePrivateData('users', 'profile', userData); 
      }

      _speak("Data saved successfully.");
      _showSuccessSnackBar('Registration successful!');

    } on FirebaseAuthException catch (e) {
      log('Firebase Auth Error: ${e.code}');
      // Speech warning even if Firebase fails
      _speak("Note: Moving to demo mode.");
    } catch (e) {
      log('Unexpected Error: $e');
      _speak("Error occurred, entering demo mode.");
    } finally {
      setState(() => _isLoading = false);
      
      // ✅ Always Navigate to CategoricalScreen
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const CategoricalScreen()),
        );
      }
    }
  }

  String _getAuthErrorMessage(String code) {
    switch (code) {
      case 'email-already-in-use': return 'Email already registered.';
      case 'weak-password': return 'Password is too weak.';
      default: return 'Registration failed.';
    }
  }
  
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.green));
  }

  // Textfield Builder with Voice Feedback
  Widget _buildTextFieldWithLabel({
    required String label,
    required String hintText,
    required TextEditingController controller,
    required String voiceDescription, 
    TextInputType keyboardType = TextInputType.text,
    bool isPassword = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              color: const Color(0xFF26323F),
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
              controller: controller, 
              keyboardType: keyboardType,
              obscureText: isPassword,
              onTap: () => _speak(voiceDescription), 
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: const TextStyle(color: Colors.white54),
                border: InputBorder.none, 
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A232D),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            _speak("Going back");
            if (!_isLoading) Navigator.pop(context);
          },
        ),
        title: const Text(
          'Personal Data',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildTextFieldWithLabel(
              label: 'Name', 
              hintText: 'Enter your full name', 
              controller: _nameController,
              voiceDescription: "Name field, please enter your full name.",
            ),
            _buildTextFieldWithLabel(
              label: 'Age', 
              hintText: 'Enter your age', 
              controller: _ageController, 
              keyboardType: TextInputType.number,
              voiceDescription: "Age field, please enter your age in numbers.",
            ),
            _buildTextFieldWithLabel(
              label: 'Contact Number', 
              hintText: 'Enter your contact number', 
              controller: _contactController, 
              keyboardType: TextInputType.phone,
              voiceDescription: "Phone number field.",
            ),
            _buildTextFieldWithLabel(
              label: 'Email Address', 
              hintText: 'Enter your email address', 
              controller: _emailController, 
              keyboardType: TextInputType.emailAddress,
              voiceDescription: "Email field.",
            ),
            _buildTextFieldWithLabel(
              label: 'Password', 
              hintText: 'Choose your password', 
              controller: _passwordController, 
              isPassword: true,
              voiceDescription: "Password field, must be at least 6 characters.",
            ), 
            _buildTextFieldWithLabel(
              label: 'Location', 
              hintText: 'Enter your location', 
              controller: _locationController,
              voiceDescription: "Location field.",
            ),

            const SizedBox(height: 40),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                TextButton(
                  onPressed: () {
                    _speak("Action cancelled.");
                    if (!_isLoading) Navigator.pop(context);
                  },
                  child: const Text('Cancel', style: TextStyle(color: Colors.white70, fontSize: 16)),
                ),
                
                SizedBox(
                  width: 120,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _registerAndSaveData,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2196F3),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: _isLoading 
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Text('Save', style: TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                ),
              ],
            ),
          ],
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