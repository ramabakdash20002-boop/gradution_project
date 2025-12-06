import 'package:flutter/material.dart';
import 'package:gradution_project/screens/add_contact_screen.dart';
import 'package:gradution_project/screens/home_screen.dart';

class CategoricalScreen extends StatelessWidget {
  const CategoricalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff243647),
      appBar: AppBar(
        backgroundColor:Color(0xff243647) ,
        title: Align(
          alignment: Alignment.centerRight,
          child: Image.asset("lib/assets/image.png",height: 38,width: 38,)),
      ),
    
      body: Column(
        children: [
          Padding(
            padding:  EdgeInsets.only(top: 20),
            child: Align(
              alignment: Alignment.topCenter,
              child: Text("Choose Your Category",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 26),)),
          ),
          SizedBox(height: 50,),
          Container(
            width: 290,
            height: 130,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Color(0xff3E5268),
            ),
            
            child: Row(
              children: [
                Padding(
                  padding:  EdgeInsets.only(left: 30),
                  child: GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
                        return HomeScreen();
                      }));
                    },
                    child: Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: AssetImage("lib/assets/eldry.png")),
                        borderRadius: BorderRadius.circular(33),
                        
                      ),
                      
                    ),
                  ),
                ),
                SizedBox(width: 10,),
                GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
                      return NewContactScreen();
                    }));
                  },
                  child: Text("Elderly",style: TextStyle(color: Colors.white,fontSize: 40),))
              ],
            ),
          ),
          SizedBox(height: 50,),
          Container(
            width: 290,
            height: 130,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Color(0xff3E5268),
            ),
            
            child: Row(
              children: [
                Padding(
                  padding:  EdgeInsets.only(left: 30),
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage("lib/assets/student.png")),
                      borderRadius: BorderRadius.circular(33),
                      
                    ),
                    
                  ),
                ),
                SizedBox(width: 10,),
                GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
                      return NewContactScreen();
                    }));
                  },
                  child: Text("Student",style: TextStyle(color: Colors.white,fontSize: 40),))
              ],
            ),
          ),
          SizedBox(height: 50,),
          Container(
            width: 290,
            height: 130,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Color(0xff3E5268),
            ),
            
            child: Row(
              children: [
                Padding(
                  padding:  EdgeInsets.only(left: 30),
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage("lib/assets/child.png")),
                      borderRadius: BorderRadius.circular(33),
                      
                    ),
                    
                  ),
                ),
                SizedBox(width: 10,),
                GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
                      return NewContactScreen();
                    }));
                  },
                  child: Text("Children",style: TextStyle(color: Colors.white,fontSize: 40),))
              ],
            ),
          )
        ],
      ),
      
    );
  }
}