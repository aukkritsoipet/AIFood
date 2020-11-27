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
    "chili paste",
    "chinese kale",
    "crispy pork belly",
    "curry power",
    "egg",
    "egg tofu",
    "fish sauce",
    "garlic",
    "glass noodle",
    "instant noodle",
    "meat",
    "oil",
    "onion",
    "onion stalk",
    "pepper",
    "rice",
    "soy paste",
    "tomato",
    "tomato sauce",
  ];

  File _imageFile;
  String _photoMessage = "Last photo taken";

  double screenWidth;
  double padding;
  double imageWidth;

  bool _imgPickerInUse = false;

  final _imgPicker = ImagePicker();

  List<String> _ingredients = [
    // "basil leaves",
    // "carrot",
    // "chili",
    // "chilli paste",
    // "chinese kale",
    // "crispy pork belly",
    // "curry power",
    // "egg",
    // "egg tofu",
    // "fish sauce",
    // "garlic",
    // "glass noodle",
    // "instant noodle",
    // "meat",
    // "oil",
    // "onion",
    // "onion stalk",
    // "egg",
    // "pepper",
    // "rice",
    // "soy paste",
    // "tomato",
    // "tomato sauce",
  ];
  bool _hasIngredient = false;

  void _lockImgPicker() {
    setState(() {
      _imgPickerInUse = true;
    });
  }

  void _unlockImgPicker() {
    setState(() {
      _imgPickerInUse = false;
    });
  }

  void _checkIngredients() {
    setState(() {
      _hasIngredient = _ingredients.isNotEmpty;
    });
  }

  // List manipulating functions
  void _addIngredient({@required String ingreName}) {
    if (!_ingredients.contains(ingreName)) {
      setState(() {
        _ingredients.add(ingreName);
        _photoMessage = "Added $ingreName";
      });
    } else {
      setState(() {
        _photoMessage = "You already have $ingreName";
      });
    }
  }

  void _removeIngredient({@required String target}) {
    setState(() {
      _ingredients.removeWhere((element) => element == target);
    });
    _checkIngredients();

    print("Removed $target");
  }

  Future _getCameraPhoto() async {
    _lockImgPicker();
    PickedFile shotImage =
        await _imgPicker.getImage(source: ImageSource.camera);

    if (shotImage != null) {
      setState(() {
        _imageFile = File(shotImage.path);
      });

      String imageLabel = await _getPrediction();
      _addIngredient(ingreName: imageLabel);
    }
    _checkIngredients();
    _unlockImgPicker();
  }

  Future _getGalleryPhoto() async {
    _lockImgPicker();

    PickedFile shotImage =
        await _imgPicker.getImage(source: ImageSource.gallery);

    if (shotImage != null) {
      setState(() {
        _imageFile = File(shotImage.path);
      });

      String imageLabel = await _getPrediction();

      _addIngredient(ingreName: imageLabel);
    }
    _checkIngredients();
    _unlockImgPicker();
  }

  Future _getGalleryPhotoNoAI() async {
    _lockImgPicker();

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
    _checkIngredients();
    _unlockImgPicker();
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
                      child: Text(_photoMessage),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: _imgPickerInUse
                    ? Center(
                        child: Text("Processing..."),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: MyButton(
                                text: "From camera",
                                onpressed: _getCameraPhoto,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: MyButton(
                                text: "From gallery",
                                onpressed: _getGalleryPhotoNoAI,
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
              Expanded(
                flex: 5,
                child: ListView.builder(
                    itemCount: _ingredients.length,
                    itemBuilder: (context, index) {
                      return IngredientItem(
                          text: _ingredients[index],
                          removeFunction: () =>
                              _removeIngredient(target: _ingredients[index]));
                    }),
              ),
              Expanded(
                flex: 2,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Visibility(
                      visible: _hasIngredient,
                      child: MyButton(
                        text: "Get suggestions",
                        horizontalPadding: 40,
                        verticalPadding: 5,
                        onpressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ResultPage(_ingredients)));
                        },
                      ),
                    ),
                  ),
                ),
              )
            ],
          )),
    );
  }
}
