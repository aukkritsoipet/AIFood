import 'package:aiproject/data/color_data.dart';
import 'package:aiproject/widget/menu_card.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ResultPage extends StatefulWidget {
  final List<String> ingredients;
  ResultPage(this.ingredients);

  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  double screenWidth;
  double padding;
  List<String> _ingreList;

  bool _isLoading = true;

  List<Map<String, dynamic>> menuList = [];

  Future<void> _loadMenuList() async {
    menuList = [];
    
    _ingreList = widget.ingredients;


    Query query = Firestore.instance
        .collection("cookbook")
        .where("ingredients", arrayContainsAny: _ingreList);
    QuerySnapshot qShot = await query.getDocuments();
    print(qShot.documents.length);
    qShot.documents.forEach((element) {
      print(element.data);
      menuList.add(element.data);
    });

    setState(() {
       _isLoading = false;
    });
   
  }

  Widget _buildMenuItem(context, index) {
    Map<String, dynamic> menuObj = menuList[index];
    return MenuCard(menu: menuObj, ownedIngredients: _ingreList);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      _loadMenuList();
    }

    screenWidth = MediaQuery.of(context).size.width;
    padding = screenWidth * 0.08;

    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        color: ColorData.buttonColor,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: padding, vertical: 10.0),
          child: Row(
            children: [
              Expanded(child: SizedBox()),
              FlatButton(
                child: Text("Back"),
                color: ColorData.buttonTextColor,
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(padding),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                'Your suggestions',
              ),
            ),
            Divider(
              height: 5,
              color: ColorData.buttonColor,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: menuList.length,
                itemBuilder: (context, index) {
                  return _buildMenuItem(context, index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
