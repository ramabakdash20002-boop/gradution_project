import 'package:flutter/material.dart';
import 'package:gradution_project/screens/resrt_password_screen.dart';


class ForgetPasswordScreen extends StatelessWidget {
  const ForgetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff243647),
      appBar: AppBar(
        backgroundColor: Color(0xff243647),
        title: Center(child: Text("Forget Password",style: TextStyle(color: Colors.white),)),
      ),
      body:Column(
        children: [
         Padding (
            padding:  EdgeInsets.symmetric(horizontal: 10),
            child: Container(
              width: double.infinity,
              height:50 ,
              decoration: BoxDecoration(
                color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
              ),
              child: Center(
                child: TextField(
                            decoration: InputDecoration(
                              hintText: "Email or phone number",
                            ),
                      ),
              )
                ),
          ),
          Spacer(),
          Padding(
            padding:  EdgeInsets.only(bottom: 20 ),
            child: Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.blue,
                            borderRadius: BorderRadius.circular(15),
            
              ),
              child: Center(child: GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
                    return ResrtPasswordScreen();
                  }));
                },
                child: Text("Reset Password",style: TextStyle(color: Colors.white,fontSize: 20),))),
            ),
          )
        ],
      ));
  }
}