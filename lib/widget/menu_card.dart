import 'package:flutter/material.dart';

class MenuCard extends StatelessWidget {
  final Map<String, dynamic> menu;
  final List<String> ownedIngredients;

  MenuCard({this.menu, this.ownedIngredients});

  String _capitalize(String text) {
    return text.substring(0, 1).toUpperCase() + text.substring(1, text.length);
  }

  List<Widget> _buildIngredientList() {
    List<Widget> out = [];
    out.add(Divider(
      thickness: 2.0,
    ));
    List<dynamic> ingre = menu["ingredients"];

    ingre.forEach((element) {
      String ingreName = element.toString();
      out.add(
        Padding(
            padding: EdgeInsets.symmetric(vertical: 5.0),
            child: Text(_capitalize(ingreName))),
      );
    });

    return out;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ListTile(
              title: Center(child: Text(menu["name"])),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _buildIngredientList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
