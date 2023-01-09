import 'package:flutter/material.dart';

class DynamicLabel extends StatefulWidget {

  late String  labelText; 
  late FontWeight fontWeight;
  late Color col;
  DynamicLabel(this.labelText, this.fontWeight, this.col,{super.key});


  @override
  State<DynamicLabel> createState() => _DynamicLabelState();
}

class _DynamicLabelState extends State<DynamicLabel> { 
  late double fontSiz;


  @override
  Widget build(BuildContext context) {
    if(getWidth() <= 400){
      fontSiz =18;
    }
    else{
      fontSiz =20;
    }
    return Text(
        widget.labelText,
        style: TextStyle(
          fontSize: fontSiz,
          fontWeight: widget.fontWeight,
          color: widget.col
        )
      
    );
  }

  double getWidth(){
    return MediaQuery.of(context).size.width;
  }
  double getHeight(){
    return MediaQuery.of(context).size.height;
  }
}