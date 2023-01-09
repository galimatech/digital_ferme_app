import 'package:flutter/material.dart';
class DynamicText extends StatefulWidget {

  late String  title; 
  late FontWeight fontWeight;
  late Color col;
 // late Widget child;
  DynamicText(this.title,this.fontWeight,this.col,{super.key});

  @override
  State<DynamicText> createState() => _DynamicTextState();
}

class _DynamicTextState extends State<DynamicText> {

  late double fontSiz;
  
  

  @override
  Widget build(BuildContext context) {
    if(getWidth() <= 400){
      fontSiz =20;
    }
    else{
      fontSiz =30;
    }
    return Text(
        widget.title,
        style: TextStyle(
          fontSize: fontSiz,
          fontWeight: widget.fontWeight,
          color: widget.col
        ),);
  }

  double getWidth(){
    return MediaQuery.of(context).size.width;
  }
  double getHeight(){
    return MediaQuery.of(context).size.height;
  }
}