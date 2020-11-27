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

  List<Map<String, dynamic>> _menuList = [];

  Future<void> _loadMenuList() async {
    _ingreList = widget.ingredients;
    List<List<String>> ingreChunks = _splitIngredients();

    List<Map<String, dynamic>> totalList = [];

    for (var sublist in ingreChunks) {
      totalList.addAll(await _queryBySublist(sublist));
    }

    print("Initial ${totalList.length}\n\n$totalList\n\n");

    totalList.removeWhere((element){
      var reqList = List<String>.from(element['ingredients']);
      return !_isSubsetOf(reqList, _ingreList);
    });

    print("${totalList.length}\n$totalList");

    for(var menu in totalList){
      if(!_menuListContains(_menuList, menu)){
        _menuList.add(menu);
      }
    }

    print("${_menuList.length}");

    setState(() {
      _isLoading = false;
    });
  }

  Future<List<Map<String, dynamic>>> _queryBySublist(
      List<String> sublist) async {
    Query query = Firestore.instance
        .collection("cookbook")
        .where('ingredients', arrayContainsAny: sublist);
    QuerySnapshot qShot = await query.getDocuments();
    List<Map<String, dynamic>> out = [];
    List<DocumentSnapshot> docList = qShot.documents;
    for (var doc in docList) {
      out.add(doc.data);
    }

    return out;
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
          padding: EdgeInsets.symmetric(horizontal: padding, vertical: 7.0),
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
              child: _isLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : _menuList.isEmpty
                      ? Center(
                          child: Text(
                              "Looks like we don't have suggestions for you"),
                        )
                      : ListView.builder(
                          itemCount: _menuList.length,
                          itemBuilder: (context, index) {
                            return _buildMenuCard(context, index);
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  // Build funcitons
  Widget _buildMenuCard(context, index) {
    Map<String, dynamic> menuObj = _menuList[index];
    return MenuCard(menu: menuObj, ownedIngredients: _ingreList);
  }

  // Helper functions
  bool _isSubsetOf(List child, List parent) {
    if (child.length > parent.length) {
      return false;
    }
    for (var ele in child) {
      if (!parent.contains(ele)) {
        return false;
      }
    }
    return true;
  }

  List<List<String>> _splitIngredients() {
    List<List<String>> out = [];
    for (int i = 0; i < _ingreList.length; i += 10) {
      if (i + 10 < _ingreList.length) {
        out.add(_ingreList.sublist(i, i + 10));
      } else {
        out.add(_ingreList.sublist(i));
      }
    }
    return out;
  }

  bool _menuListContains(List<Map<String, dynamic>> list, Map<String, dynamic> menu){
    for(var item in list){
      String name1 = item['name'];
      String name2 = menu['name'];

      if(name1 == name2){
        return true;
      }
    }
    return false;
  }
}
