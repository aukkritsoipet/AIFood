import 'package:aiproject/screen/takingphoto.dart';
import 'package:aiproject/widget/my_button.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
   
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Want some suggestions',
            ),
          MyButton(
            text: "Start",
            onpressed: (){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => TakePhoto()));
            },
          )
          ],
        ),
      ),
    );
  }
}