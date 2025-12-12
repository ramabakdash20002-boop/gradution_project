import 'package:flutter/material.dart';
class texxtfile extends StatelessWidget {
   const texxtfile({super.key, this.text});
 final String? text;

  @override
  Widget build(BuildContext context) {
    return Padding(
                padding: EdgeInsets.only(top: 5, left: 10, right: 20),
                child: Container(
                  width: 280,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: text!,
                    ),
                  ),
                ),
              );
  }
}