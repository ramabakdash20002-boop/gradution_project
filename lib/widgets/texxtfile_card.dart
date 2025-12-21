// lib/widgets/texxtfile_card.dart

import 'package:flutter/material.dart';

class texxtfile extends StatelessWidget {
  final String? text;
  final TextEditingController? controller; 
  final bool obscureText; 

  const texxtfile({
    super.key,
    this.text,
    this.controller,
    this.obscureText = false, 
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, left: 10, right: 20),
      child: Container(
        width: 280,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: TextFormField( 
          controller: controller, 
          obscureText: obscureText, 
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
            hintText: text ?? '', 
            hintStyle: const TextStyle(color: Colors.grey),
            border: InputBorder.none, 
            contentPadding: const EdgeInsets.only(bottom: 10, left: 10),
          ),
        ),
      ),
    );
  }
}