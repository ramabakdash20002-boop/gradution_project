import 'package:flutter/material.dart';

class WelcomeCard extends StatelessWidget {
  const WelcomeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
              padding: EdgeInsets.only(top: 10, right: 50, left: 50),

              child: Container(
                width: 300,
                height: 310,
                decoration: BoxDecoration(
                  color: Color(0xff3E5268),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Image.asset(
                          "lib/assets/image.png",
                          width: 40,
                          height: 40,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Text(
                        "Welcome",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        "jhtdfvjuyfytuutyyhggggfdufriondyikbfyikbttjgfkgffi9864eegkoyrlkjhgfdszxcvbnm,.ulytvcbnvltyttdffxggkfkrr",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            );
  }
}