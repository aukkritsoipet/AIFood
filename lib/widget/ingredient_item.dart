import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class IngredientItem extends StatelessWidget{
  final String text;
  final Function removeFunction;

  IngredientItem({this.text, this.removeFunction});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1),
        ),
      ),
      child: Row(
        children: [
          Expanded(child: Text(text)),
          IconButton(icon: Icon(CupertinoIcons.clear_circled), onPressed: removeFunction)
        ],
      ),
    );
  }
}