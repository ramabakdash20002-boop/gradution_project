import 'package:flutter/material.dart';
import 'package:gradution_project/screens/categorical_screen.dart';
import 'package:gradution_project/screens/forget_password_screen.dart';
import 'package:gradution_project/screens/user_data_screen.dart';
import 'package:gradution_project/widgets/texxtfile_card.dart';

class SigninCard extends StatelessWidget {
  const SigninCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 20, left: 50, right: 50),
      child: Container(
        width: 300,
        height: 350,
        decoration: BoxDecoration(
          color: Color(0xff3E5268),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "sign in",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return UserDataScreen();
                          },
                        ),
                      );
                    },
                    child: Text(
                      "New ? Create",
                      style: TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 28),
              Text(
                "Email",
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
              texxtfile(text: "  please enter your email"),
              SizedBox(height: 28),
              Text(
                "password",
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
              texxtfile(text: "  please enter password"),
              SizedBox(height: 20),
              Row(
                children: [
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
                        return ForgetPasswordScreen();                                
                      }));
                    },
                    child: Text(
                      "forget?",
                      style: TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 8, right: 20),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) {
                              return ForgetPasswordScreen();
                            },
                          ),
                        );
                      },
                      child: Container(
                        width: 200,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Color(0xff919AE9),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Center(
                          child: GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
                                return CategoricalScreen();
                              }));
                            },
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
                  ),
                ],
              ),
              SizedBox(height: 20),
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return UserDataScreen();
                        },
                      ),
                    );
                  },
                  child: Container(
                    width: 250,
                    height: 35,
                    decoration: BoxDecoration(
                      color: Color(0xff243647),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
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
