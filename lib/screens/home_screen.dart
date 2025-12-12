import 'package:flutter/material.dart';
import 'package:gradution_project/screens/emergency_screen.dart';
import 'package:gradution_project/screens/profile_screen.dart';
import 'package:gradution_project/screens/setting_screen.dart';
import 'package:gradution_project/screens/student_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ImagePicker _picker = ImagePicker();
  XFile? _image;

  // دالة تشغيل الكاميرا
  Future<void> pickImageFromCamera() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);

    if (photo != null) {
      setState(() {
        _image = photo;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff243647),
      appBar: AppBar(
        backgroundColor: Color(0xFF1E2833),
        title: Center(
          child: Row(
            children: [
              GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext context) {
                      return ProfileScreen();
                    }));
                  },
                  child: CircleAvatar(child: Icon(Icons.person))),
              Spacer(),
              Image.asset(
                "lib/assets/image.png",
                width: 50,
                height: 50,
              ),
              Spacer(),
              GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext context) {
                      return SettingsScreen();
                    }));
                  },
                  child: Icon(
                    Icons.settings,
                    color: Colors.white,
                    size: 40,
                  ))
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(50),
            child: GestureDetector(
              onTap: pickImageFromCamera,
              child: Container(
                width: 290,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Color(0xff3E5268),
                ),
                child: Center(
                  child: _image != null
                      ? Image.file(
                          File(_image!.path),
                          width: 200,
                          height: 100,
                          fit: BoxFit.cover,
                        )
                      : Text(
                          "Camera",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                        ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(50),
            child: Container(
              width: 290,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Color(0xff3E5268),
              ),
              child: Center(
                  child: Text(
                "Indoor Navigation",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              )),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(50),
            child: Container(
              width: 290,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Color(0xff3E5268),
              ),
              child: Center(
                  child: GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext context) {
                    return EmergencyScreen();
                  }));
                },
                child: Text(
                  "Emergency",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
              )),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(50),
            child: Container(
              width: 290,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Color(0xff3E5268),
              ),
              child: Center(
                  child: GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext context) {
                    return StudentScreen();
                  }));
                },
                child: Text(
                  "other",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
              )),
            ),
          ),
        ],
      ),
    );
  }
}