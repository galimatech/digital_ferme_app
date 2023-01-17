import 'package:flutter/material.dart';
/* BuildContext context;  */

  double iconSizeMedia(BuildContext context){  
    if(MediaQuery.of(context).size.height <= 600) {
      return 60.0 ;
    } else {
      return 80.0;
    }
}