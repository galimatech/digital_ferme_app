import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SpinnerWidget extends StatelessWidget {
  const SpinnerWidget({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SpinKitCircle(
      size: 180,
      itemBuilder: (context,index){
        final colors = [Colors.white, Colors.black, Colors.grey,Colors.green];
        final color = colors[index % colors.length];
        return DecoratedBox(
          decoration: BoxDecoration(color: color,shape: BoxShape.circle)
        );
      },
    );
  }
}