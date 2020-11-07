import 'package:flutter/material.dart';

class MenuCard extends StatelessWidget{
  final Map<String, dynamic> menu;
  final List<String> ownedIngredients;

  MenuCard({this.menu, this.ownedIngredients});

  List<Widget> _buildIngredientList(){
    List<Widget> out = [];
    List<dynamic> ingre = menu["ingredients"];
    ingre.forEach((element) {
      out.add(Text(element.toString()));
    });

    return out;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            title: Text(menu["name"]),
            subtitle: Column(
              children: _buildIngredientList(),
            ),
          ),
        ],
      ),
    );
  }
}