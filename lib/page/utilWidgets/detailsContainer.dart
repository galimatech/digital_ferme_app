import 'package:flutter/material.dart';
//import 'package:flutter/src/widgets/container.dart';
//import 'package:flutter/src/widgets/framework.dart';

class ContainerDetails extends StatefulWidget {
  late Widget child;
  late Decoration decoration;

  ContainerDetails(this.child,this.decoration,{super.key});

  @override
  State<ContainerDetails> createState() => _ContainerDetailsState();

  
  
}

class _ContainerDetailsState extends State<ContainerDetails> {

  late double screenWidth;
  late double scrennHeight;

  @override
  Widget build(BuildContext context) {

    if(getWidth() <= 400){
      screenWidth = 320;

    }
    else{
      screenWidth = 500;
    }
    if(getHeight() <= 600){
      scrennHeight=148;
    }
    else{
        scrennHeight=300;
    }
    return Container(
      width: screenWidth,
      height: scrennHeight,
      decoration:  widget.decoration,
      child:  widget.child,
    );
  }

  double getWidth(){
    return MediaQuery.of(context).size.width;
  }
  double getHeight(){
    return MediaQuery.of(context).size.height;
  }
}