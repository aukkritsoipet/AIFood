import 'package:aiproject/data/color_data.dart';
import 'package:flutter/material.dart';

class MyButton extends StatelessWidget{
  final String text;
  final double horizontalPadding;
  final double verticalPadding;
  final Function onpressed;

  MyButton({
    this.text, this.horizontalPadding = 10, this.verticalPadding = 10, this.onpressed
  });

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      color: ColorData.buttonColor,
      textColor: ColorData.buttonTextColor, 
      onPressed: onpressed,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0)
      ),
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding
      ),
      child: Text(
        text
      ),    
    );
  }
}