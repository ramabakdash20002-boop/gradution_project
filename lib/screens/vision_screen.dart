import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:vibration/vibration.dart';
import 'dart:developer';
import 'dart:io';

class VisionScreen extends StatefulWidget {
  const VisionScreen({super.key});

  @override
  State<VisionScreen> createState() => _VisionScreenState();
}

class _VisionScreenState extends State<VisionScreen> {
  CameraController? _controller;
  late ImageLabeler _imageLabeler;
  final FlutterTts _flutterTts = FlutterTts();
  
  bool _isProcessing = false;
  String _objectLabel = "Tap to Scan";
  bool _isCameraInitialized = false;

  // 💡 خريطة التصحيح: لتحويل مسميات جوجل المعقدة لأسماء بسيطة
  final Map<String, String> _labelFixer = {
    "Computer keyboard": "Laptop",
    "Personal computer": "Laptop",
    "Netbook": "Laptop",
    "Display device": "Screen",
    "Mobile phone": "Smartphone",
    "Tableware": "Cup or Plate",
    "Beverage": "Drink",
    "Furniture": "Chair or Table",
    "Footwear": "Shoes",
    "Writing instrument": "Pen",
    "Book": "Notebook",
    "Paper": "Document",
  };

  // 💡 القائمة السوداء: كلمات تسبب تشتيت للكفيف ولا نحتاجها
  final List<String> _blacklist = [
    "Musical instrument", "Hand", "Finger", "Rectangle", "Material", 
    "Line", "Parallel", "Vision care", "Electronics"
  ];

  @override
  void initState() {
    super.initState();
    _initializeDetector();
    _setupCamera();
    _setupTts();
  }

  void _initializeDetector() {
    // حساسية متوازنة (0.3) لضمان النطق بوضوح
    _imageLabeler = ImageLabeler(options: ImageLabelerOptions(confidenceThreshold: 0.3));
  }

  Future<void> _setupTts() async {
    try {
      await _flutterTts.setLanguage("en-US");
      await _flutterTts.setSpeechRate(0.5);
      await _flutterTts.speak("System ready. Tap the screen to scan.");
    } catch (e) {
      log("TTS Error: $e");
    }
  }

  Future<void> _setupCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) return;
      _controller = CameraController(cameras[0], ResolutionPreset.high, enableAudio: false);
      await _controller!.initialize();
      if (!mounted) return;
      setState(() => _isCameraInitialized = true);
    } catch (e) {
      log("Camera Error: $e");
    }
  }

  Future<void> _scanNow() async {
    if (_controller == null || !_controller!.value.isInitialized || _isProcessing) return;

    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(duration: 80);
    }

    setState(() {
      _isProcessing = true;
      _objectLabel = "Scanning...";
    });
    
    _flutterTts.speak("Scanning.");

    try {
      final XFile photo = await _controller!.takePicture();
      final inputImage = InputImage.fromFilePath(photo.path);
      final List<ImageLabel> labels = await _imageLabeler.processImage(inputImage);

      if (labels.isNotEmpty) {
        String? finalDecision;
        
        // البحث عن أول كلمة ليست في القائمة السوداء
        for (var l in labels) {
          String currentLabel = l.label;
          
          if (!_blacklist.contains(currentLabel)) {
            // تصحيح الاسم لو موجود في الخريطة
            finalDecision = _labelFixer[currentLabel] ?? currentLabel;
            break; 
          }
        }

        if (finalDecision != null) {
          log("🎯 AI Result: $finalDecision");
          setState(() => _objectLabel = finalDecision!);
          _flutterTts.speak("I see $finalDecision");
          Vibration.vibrate(pattern: [0, 100, 50, 100]);
        } else {
          _speakRetry();
        }
      } else {
        _speakRetry();
      }
      
      final file = File(photo.path);
      if (await file.exists()) await file.delete();
      
    } catch (e) {
      _flutterTts.speak("Camera busy.");
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  void _speakRetry() {
    setState(() => _objectLabel = "Not sure, try again");
    _flutterTts.speak("I am not sure. Please move the camera.");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: _scanNow,
        child: Stack(
          children: [
            if (_isCameraInitialized && _controller != null)
              Positioned.fill(child: CameraPreview(_controller!))
            else
              const Center(child: CircularProgressIndicator(color: Colors.blue)),
            
            Positioned(
              bottom: 50,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.blueAccent, width: 2),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_isProcessing) const LinearProgressIndicator(),
                    const SizedBox(height: 10),
                    Text(
                      _objectLabel.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    const Text("TAP ANYWHERE TO IDENTIFY", style: TextStyle(color: Colors.blueAccent, fontSize: 10)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    _imageLabeler.close();
    _flutterTts.stop();
    super.dispose();
  }
}