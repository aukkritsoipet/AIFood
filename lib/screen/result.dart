import 'package:aiproject/widget/my_button.dart';
import 'package:flutter/material.dart';

class ResultPage extends StatefulWidget {
  final List<String> ingredients;
  ResultPage(this.ingredients);

  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {

  @override
  Widget build(BuildContext context) {
    print(widget.ingredients);
    return Scaffold(
      body: Center(
     
        child: Column(
      
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'This is result page',
            ),
          MyButton(
            text: "Start",
            horizontalPadding: 10,
            verticalPadding: 10,
            onpressed: (){
              print("");
            },
          )
          ],
        ),
      ),
    );
  }
}