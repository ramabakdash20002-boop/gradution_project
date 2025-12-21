import 'package:flutter/material.dart';
import 'package:gradution_project/screens/forget_password_screen.dart';

import 'package:gradution_project/widgets/texxtfile_card.dart'; // تم افتراض أن هذا هو الـ TextFormField الخاص بكِ

class SigninCard extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback onSignIn;
  final VoidCallback onSignUp;

  const SigninCard({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.onSignIn,
    required this.onSignUp,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 50, right: 50),
      child: Container(
        width: 300,
        height: 350,
        decoration: BoxDecoration(
          color: const Color(0xff3E5268),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "sign in",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  
                  GestureDetector(
                    onTap: onSignUp, // استدعاء دالة التسجيل
                    child: const Text(
                      "New ? Create",
                      style: TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              
              const Text(
                "Email",
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
              texxtfile(
                text: "  please enter your email",
                controller: emailController, // تمرير المتحكم
              ),
              const SizedBox(height: 28),
              
              const Text(
                "password",
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
              texxtfile(
                text: "  please enter password",
                controller: passwordController, // تمرير المتحكم
                obscureText: true, // مهم لإخفاء كلمة المرور
              ),
              const SizedBox(height: 20),
              
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                        return const ForgetPasswordScreen();
                      }));
                    },
                    child: const Text(
                      "forget?",
                      style: TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                  ),
                  
                  Padding(
                    padding: const EdgeInsets.only(left: 8, right: 20),
                    child: GestureDetector(
                      onTap: onSignIn, // 4. ربط الزر بدالة onSignIn
                      child: Container(
                        width: 200,
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xff919AE9),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Center(
                          child: Text(
                            "sign in",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 19.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              
              Center(
                child: GestureDetector(
                  onTap: () {
                    
                  },
                  child: Container(
                    width: 250,
                    height: 35,
                    decoration: BoxDecoration(
                      color: const Color(0xff243647),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.g_mobiledata, color: Colors.white),
                        Text(
                          "sign in your google accounte",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
