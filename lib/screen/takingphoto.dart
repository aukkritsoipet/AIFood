import 'dart:convert';

import 'package:aiproject/screen/result.dart';
import 'package:aiproject/widget/ingredient_item.dart';
import 'package:aiproject/widget/my_button.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:dio/dio.dart';

// This import is for simulation only
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

      String imageLabel = await _getPrediction();
      _addIngredient(ingreName: imageLabel);
    }
  }

  Future _getGalleryPhoto() async {
    PickedFile shotImage =
        await _imgPicker.getImage(source: ImageSource.gallery);

    if (shotImage != null) {
      setState(() {
        _imageFile = File(shotImage.path);
      });

      String imageLabel = await _getPrediction();

      _addIngredient(ingreName: imageLabel);
    }
  }

  void _addIngredient({@required String ingreName}) {
    if (!ingredients.contains(ingreName)) {
      setState(() {
        ingredients.add(ingreName);
      });
    }
  }

  Future _getGalleryPhoto_noAI() async {
    PickedFile shotImage =
        await _imgPicker.getImage(source: ImageSource.gallery);

    if (shotImage != null) {
      setState(() {
        _imageFile = File(shotImage.path);
      });
      Random random = Random();
      String imageLabel = _dummyList[random.nextInt(_dummyList.length)];

      
      _addIngredient(ingreName: imageLabel);
    }
  }

  Future<String> _getPrediction() async {
    print("Uploading");
    String fileName = _imageFile.path.split('/').last;

    final url = Platform.isIOS ? "localhost" : '10.0.2.2';

    FormData data = FormData.fromMap({
      "file": await MultipartFile.fromFile(
        _imageFile.path,
        filename: fileName,
      ),
    });

    Dio dio = new Dio();

    print("Upload to $url");
    final res = await dio.post("http://$url:5000/upload", data: data);
    final predictObj = json.decode(res.data);

    print("We got $predictObj");
    return predictObj['class'];
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
                      padding: EdgeInsets.only(top: 10.0),
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
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: MyButton(
                          text: "From gallery",
                          onpressed: _getGalleryPhoto_noAI,
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
