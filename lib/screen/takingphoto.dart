import 'package:aiproject/screen/result.dart';
import 'package:aiproject/widget/my_button.dart';
import 'package:flutter/material.dart';

class TakePhoto extends StatefulWidget {
  @override
  _TakePhotoState createState() => _TakePhotoState();
}

class _TakePhotoState extends State<TakePhoto> {
  GlobalKey _imageDisplay = GlobalKey();
  Widget _displayImage = Container();

  void test() {}

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double padding = width * 0.08;
    double imageWidth = width * 0.6;

    return Scaffold(
      body: Padding(
          padding: EdgeInsets.all(padding),
          child: Column(
            children: [
              Expanded(
                flex: 7,
                child: Column(
                  children: [
                    Container(
                      child: Center(child: Text("No preview")),
                      height: imageWidth,
                      width: imageWidth,
                      // decoration: BoxDecoration(
                      //   border: Border.all(width: 1),
                      // ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
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
                          text: "Button 1",
                          onpressed: () {},
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: MyButton(
                          text: "Button 2",
                          onpressed: () {},
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 5,
                child: ListView(
                  children: [
                    Text("eee"),
                    Text("eee"),
                    Text("eee"),
                    Text("eee"),
                    Text("eee"),
                    Text("eee"),
                    Text("eee"),
                    Text("eee"),
                    Text("eee"),
                    Text("eee"),
                    Text("eee"),
                    Text("eee"),
                    Text("eee"),
                    Text("eee"),
                    Text("eee"),
                    Text("eee"),
                    Text("eee"),
                    Text("eee"),
                    Text("eee"),
                    Text("eee"),
                    Text("eee"),
                    Text("eee"),
                    Text("eee"),
                    Text("eee"),
                    Text("eee"),
                    Text("eee"),
                    Text("eee"),
                    Text("eee"),
                    Text("eee"),
                    Text("eee"),
                    Text("eee"),
                    Text("eee"),
                    Text("eee"),
                    Text("eee"),
                    Text("eee"),
                    Text("eee"),
                    Text("eee"),
                    Text("eee"),
                    Text("eee"),
                    Text("eee"),
                    Text("eee"),
                    Text("eee"),
                    Text("eee"),
                    Text("eee"),
                    Text("eee"),
                    Text("eee"),
                    Text("eee"),
                    Text("eee"),
                  ],
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
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => ResultPage()));
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
