import 'package:flutter/material.dart';

class Info extends StatelessWidget {
  final String text;
  final IconData image;
  final double font;
  final double width;
  final double height;
  final Color color;
  final Color fontColor;

  Info({this.text, this.image, this.font, this.width, this.height, this.color, this.fontColor});

  @override
  Widget build(BuildContext context) {

    return Container(
      width: width,
        height: height,
        padding: EdgeInsets.symmetric(vertical: 25),
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.all(
              Radius.circular(15.0)
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(image, color: fontColor,),
            Padding(padding: EdgeInsets.all(5),),
            Text(text,
              textAlign: TextAlign.center,
              style:
              TextStyle(fontSize: font, color: fontColor,),
            )
          ],
        ),
    );
  }
}