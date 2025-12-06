import 'package:flutter/material.dart';
import 'package:gradution_project/screens/home_screen.dart';

class NewContactScreen extends StatefulWidget {
  const NewContactScreen({super.key});

  @override
  State<NewContactScreen> createState() => _NewContactScreenState();
}

class _NewContactScreenState extends State<NewContactScreen> {
  String? _selectedRelationship;
  final List<String> _relationships = ['Family', 'Friend', 'Work', 'Emergency'];

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
            Navigator.pop(context);
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: Image.asset('lib/assets/image.png'),
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
            const TextField(
              decoration: InputDecoration(
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
            const TextField(
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
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
            Container(
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
                  },
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

            Container(
              height: MediaQuery.of(context).size.width * 0.8,
              decoration: BoxDecoration(
                color: const Color(0xFF88A07A),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.crop_square, size: 10, color: Colors.white54),
                        SizedBox(width: 2),
                        Icon(Icons.crop_square, size: 10, color: Colors.white54),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text(
                      '20501049',
                      style: TextStyle(color: Colors.white54, fontSize: 12),
                    ),
                    SizedBox(height: 8),
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

            const SizedBox(height: 30),

            // ==== Save Contact ====
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF007AFF),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
                    return HomeScreen();
                  }));
                },
                child: const Text('Save Contact')),
            ),
            const SizedBox(height: 16),

            // ==== Add Another Contact ====
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3B485C),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Add Another Contact'),
            ),
          ],
        ),
      ),
    );
  }
}
