import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_tts/flutter_tts.dart'; 
import 'dart:developer';
import '../firebase_service.dart'; 
import 'categorical_screen.dart'; // Ensure correct import for the category screen

final _firebaseService = FirebaseService();

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  // TTS Engine Definition
  final FlutterTts _flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _firebaseService.initializeFirebase();
    
    // Start welcome message in English after a short delay
    Future.delayed(const Duration(milliseconds: 500), () {
      _initVoiceOver();
    });
  }

  // Initialize TTS and start the English welcome message
  Future<void> _initVoiceOver() async {
    await _flutterTts.setLanguage("en-US"); // Changed to English
    await _flutterTts.setPitch(1.0);
    await _flutterTts.setSpeechRate(0.5);

    String welcomeMessage = 
        "Welcome to the login screen. "
        "Please enter your email and password to continue, "
        "or tap on Create Account if you don't have one.";
    
    await _flutterTts.speak(welcomeMessage);
  }

  // Helper function for speech feedback
  Future<void> _speak(String text) async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.speak(text);
  }

  Future<void> _signInWithEmail(BuildContext context) async {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();
    
    if (email.isEmpty || password.isEmpty) {
      _speak("Please enter your email and password."); 
      _showErrorSnackBar(context, 'Please enter email and password.');
      return;
    }

    setState(() => _isLoading = true);
    _speak("Signing in, please wait.");

    try {
      final userCredential = await _firebaseService.auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      final String? uid = userCredential.user?.uid;
      _firebaseService.userId = uid;
      
      _speak("Login successful. Welcome back.");
      _showSuccessSnackBar(context, 'Login successful!');
      
      // Navigate to Categorical Screen after successful login
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const CategoricalScreen()),
        );
      }

    } on FirebaseAuthException catch (e) {
      String errorMsg = _getAuthErrorMessage(e.code);
      _speak(errorMsg); 
      _showErrorSnackBar(context, errorMsg);
    } catch (e) {
      _speak("An unexpected error occurred.");
      _showErrorSnackBar(context, 'Unexpected error. Please try again.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // Map Firebase errors to English messages
  String _getAuthErrorMessage(String code) {
    switch (code) {
      case 'user-not-found': return 'Account not found.';
      case 'wrong-password': return 'Incorrect password.';
      case 'invalid-email': return 'The email address is invalid.';
      case 'user-disabled': return 'This account has been disabled.';
      default: return 'Login failed. Please check your credentials.';
    }
  }

  // Modified TextField builder for voice feedback on tap
  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String voiceDescription,
    bool isPassword = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 14)),
          const SizedBox(height: 5),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextField(
              controller: controller,
              obscureText: isPassword,
              onTap: () => _speak(voiceDescription), 
              style: const TextStyle(color: Colors.black),
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 10),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            const SizedBox(height: 80),
            
            // Welcome Header Card
            Container(
              padding: const EdgeInsets.all(24),
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF26323F),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Welcome Back', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Text('Sign in to continue to your account.', style: TextStyle(color: Colors.white70)),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Sign In Credentials Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF26323F),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Sign In', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                      TextButton(
                        onPressed: _isLoading ? null : () {
                          _speak("Navigating to registration screen.");
                          Navigator.pushNamed(context, '/personal_data_screen'); 
                        },
                        child: const Text('New? Create Account', style: TextStyle(color: Colors.blueAccent)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  
                  _buildTextField(
                    label: 'Email', 
                    controller: _emailController,
                    voiceDescription: "Email field, please enter your email address.",
                  ),
                  
                  _buildTextField(
                    label: 'Password', 
                    controller: _passwordController, 
                    isPassword: true,
                    voiceDescription: "Password field.",
                  ),
                  
                  const SizedBox(height: 30),
                  
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : () => _signInWithEmail(context), 
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF9FA8DA),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: _isLoading 
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : const Text('Sign In', style: TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  
                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        _speak("Google sign in is currently not implemented.");
                        _showErrorSnackBar(context, 'Google Sign In Not Implemented');
                      },
                      icon: const Icon(Icons.g_mobiledata, color: Colors.white, size: 30),
                      label: const Text('Sign in with Google', style: TextStyle(color: Colors.white70)),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        side: const BorderSide(color: Colors.white54),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _flutterTts.stop(); 
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
  void _showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.green));
  }
}