import 'dart:typed_data';
import 'dart:ui';
import 'package:barcode_widget/barcode_widget.dart';
import '../../page/speculationWidgets/farming.dart';
import '../../page/fishWidgets/fish.dart';
import '../../page/poultryWidgets/poultry.dart';
import '../../page/treeWidgets/tree.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import '../cattleWidgets/cattle.dart';

class GenerateCodePage extends StatefulWidget {
  final String data;
  final String page;
  const GenerateCodePage(this.data,this.page);

  @override
  _GenerateCodePageState createState() => _GenerateCodePageState(this.data,this.page);
}

class _GenerateCodePageState extends State<GenerateCodePage> {
    String data;
    String page;
    _GenerateCodePageState(this.data,this.page);
    GlobalKey globalKey = new GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
            preferredSize: Size.fromHeight(60.0), // here the desired height
            child: AppBar(
              backgroundColor: Colors.white,
              elevation: 0.0,
              title: ClipRect(
                  child: Image.asset(
                'images/logoFarm.gif',
                width: 60.0,
                height: 60.0,
              )),
              actions: <Widget>[
                IconButton(icon: const Icon(Icons.qr_code_2_outlined, size: 50), onPressed: () {}),
                SizedBox(
                  width: 10,
                )
              ],
            )),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child:  Center(
              child: RepaintBoundary(
                key: globalKey,
                child: Column(
                  children: [
                    BarcodeWidget(
                      barcode: Barcode.pdf417(),
                      backgroundColor: Colors.grey[200],
                      data: data,
                      width: 300,
                      height: 100,
                    ),
                    Padding(padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(data),)
                  ],
                )
              ),
            ),
                ),
            Padding(padding: EdgeInsets.symmetric(horizontal: 50),
            child: Row(children: [
              Expanded(flex: 2,child: ElevatedButton(child: Text("Sauvegarder le code",style: TextStyle(fontSize: 20),),onPressed: (){_captureAndSharePng();},)),
              Expanded(flex: 1,child: SizedBox(width: 1,)),
              Expanded(flex: 2,child: ElevatedButton(child: Text("Nom merci",style: TextStyle(fontSize: 20)),onPressed: (){ goBack();}),)
            ],),)
              ],),
    );
  }

  Future<void> _captureAndSharePng() async {
    try {
      final RenderRepaintBoundary boundary = globalKey.currentContext!.findRenderObject()! as RenderRepaintBoundary;
      final image = await boundary.toImage();
      final ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();
      var result = await   saveImage(pngBytes);
      print(result);
      goBack();
    } catch(e) {
      print(e.toString());
    } 
  }

  Future<String> saveImage(Uint8List bytes) async{
    await [Permission.storage].request();
       final result = await ImageGallerySaver.saveImage(bytes,name: data,quality: 100);
       return result['filePath'];
  }

  void goBack(){
    if(page=='cattle')
      Navigator.pushAndRemoveUntil<void>(context,MaterialPageRoute<void>(builder: (BuildContext context) => CattlePage(),
      ),ModalRoute.withName("/"));
     if(page=='poultry')
      Navigator.pushAndRemoveUntil<void>(context,MaterialPageRoute<void>(builder: (BuildContext context) => PoultryPage(),
      ),ModalRoute.withName("/"));
     if(page=='fish')
      Navigator.pushAndRemoveUntil<void>(context,MaterialPageRoute<void>(builder: (BuildContext context) => FishPage(),
      ),ModalRoute.withName("/"));
     if(page=='speculation')
      Navigator.pushAndRemoveUntil<void>(context,MaterialPageRoute<void>(builder: (BuildContext context) => FarmingPage(),
      ),ModalRoute.withName("/"));
     if(page=='tree')
      Navigator.pushAndRemoveUntil<void>(context,MaterialPageRoute<void>(builder: (BuildContext context) => TreePage(),
      ),ModalRoute.withName("/"));
  }
}