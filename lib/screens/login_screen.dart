import 'package:flutter/material.dart';
import 'package:gradution_project/widgets/language_card.dart';
import 'package:gradution_project/widgets/signin_card.dart';
import 'package:gradution_project/widgets/welcome_card.dart';
class Login_screen extends StatelessWidget {
  const Login_screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xff243647),

        body: Column(
          children: [
            LanguageCard(),
            WelcomeCard(),
           SigninCard()
          ],
        ),
      );
  }
}