import 'package:aiproject/screen/result.dart';
import 'package:aiproject/widget/ingredient_item.dart';
import 'package:aiproject/widget/my_button.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'dart:math';

class TakePhoto extends StatefulWidget {
  @override
  _TakePhotoState createState() => _TakePhotoState();
}

class _TakePhotoState extends State<TakePhoto> {
  // Used for randomizing to simulate AI's work
  static const List<String> _dummyList = [
    "basil leaves",
    "carrot",
    "chili",
    "chinese kale",
    "crispy pork belly",
    "egg",
    "garlic",
    "meat",
    "oil",
    "onion",
    "onion stalk",
    "oyster sauce",
    "pepper",
    "rice",
    "soy paste",
    "soy sauce",
    "tomato"
  ];

  File _imageFile;

  double screenWidth;
  double padding;
  double imageWidth;

  final _imgPicker = ImagePicker();

  List<String> ingredients = [];

  Future _getCameraPhoto() async {
    PickedFile shotImage =
        await _imgPicker.getImage(source: ImageSource.camera);

    if (shotImage != null) {
      setState(() {
        _imageFile = File(shotImage.path);
      });

      String imageLabel = _simulateAI();
      // TODO: _simulateAI() will be replaced with actual model's response later
      _addIngredient(target: imageLabel);
    }
  }

  Future _getGalleryPhoto() async {
    PickedFile shotImage =
        await _imgPicker.getImage(source: ImageSource.gallery);

    if (shotImage != null) {
      setState(() {
        _imageFile = File(shotImage.path);
      });

      String imageLabel = _simulateAI();
      // TODO: _simulateAI() will be replaced with actual model's response later
      _addIngredient(target: imageLabel);
    }
  }

  void _addIngredient({@required String target}) {
    if (!ingredients.contains(target)) {
      setState(() {
        ingredients.add(target);
      });
    }
  }

  // this function will later have File as parameter
  String _simulateAI() {
    Random random = Random();
    return _dummyList[random.nextInt(_dummyList.length)];
  }

  void _removeIngredient({@required String target}) {
    setState(() {
      ingredients.removeWhere((element) => element == target);
    });

    print("Removed $target");
  }

  Widget _buildImagePreview(File image) {
    bool imageEmpty = image == null;

    return Container(
      child: imageEmpty
          ? Center(
              child: Text("No preview"),
            )
          : Image.file(
              image,
              fit: BoxFit.contain,
            ),
      width: imageWidth,
      height: imageWidth,
      decoration: imageEmpty
          ? BoxDecoration(
              border: Border.all(width: 1),
            )
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    padding = screenWidth * 0.08;
    imageWidth = screenWidth * 0.6;

    return Scaffold(
      body: Padding(
          padding: EdgeInsets.all(padding),
          child: Column(
            children: [
              Expanded(
                flex: 7,
                child: Column(
                  children: [
                    _buildImagePreview(_imageFile),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text("Last photo taken"),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: MyButton(
                          text: "From camera",
                          onpressed: _getCameraPhoto,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: MyButton(
                          text: "From gallery",
                          onpressed: _getGalleryPhoto,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ListView.builder(
                      itemCount: ingredients.length,
                      itemBuilder: (context, index) {
                        return IngredientItem(
                            text: ingredients[index],
                            removeFunction: () =>
                                _removeIngredient(target: ingredients[index]));
                      }),
                ),
              ),
              Expanded(
                flex: 2,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MyButton(
                      text: "Get suggestions",
                      horizontalPadding: 40,
                      verticalPadding: 5,
                      onpressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ResultPage(ingredients)));
                      },
                    ),
                  ),
                ),
              )
            ],
          )),
    );
  }
}
