import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../utils/categoryCompte.dart';
import '../utils/compte.dart';
import '../utils/service.dart';
import '../widget/spinner_widget.dart';
import 'package:flutter/material.dart';

class OperationWidget extends StatefulWidget {
  const OperationWidget({ Key? key }) : super(key: key);

  @override
  State<OperationWidget> createState() => _OperationWidgetState();
}

class _OperationWidgetState extends State<OperationWidget> {
  final TextEditingController _controllerLabel = new TextEditingController();
  TextEditingController _controllerComment = new TextEditingController();
  TextEditingController _controllerAmount = new TextEditingController();
  TextEditingController _controllerCompte = new TextEditingController();
  TextEditingController _controllerCategory = new TextEditingController();
  List<Compte> comptes = [];
  late Compte _selectedComptes;
  List<CategoryCompte>  categories = [];
  late CategoryCompte _selectedCategory;
  late bool load = true;
  var _key = GlobalKey<FormState>();

  @override
  void initState() {
    getData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actionsAlignment: MainAxisAlignment.spaceBetween,
      title: const Text("Enregistrement !",style: TextStyle(fontWeight: FontWeight.bold,fontStyle: FontStyle.italic,fontSize: 20.0),),
      actions: [
        ElevatedButton(child: Text("Effectuer"),
        onPressed: () => Navigator.of(context).pop(),),
        ElevatedButton(child: Text("Annuler"),
        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.red)),
          onPressed: () => Navigator.of(context).pop(), 
        ),
      ],
      content: load ? const Center(child: SpinnerWidget()) : form(),
    );
  }

  Widget form() {
    return Form(
      key: _key,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(padding: EdgeInsets.symmetric(vertical: 20.0,horizontal: 20.0),
            ),Padding(padding: EdgeInsets.symmetric(vertical: 20.0,horizontal: 20.0),
            ),Padding(padding: EdgeInsets.symmetric(vertical: 20.0,horizontal: 20.0),
            ),Padding(padding: EdgeInsets.symmetric(vertical: 20.0,horizontal: 20.0),
            ),Padding(padding: EdgeInsets.symmetric(vertical: 20.0,horizontal: 20.0),
            ),
          ],
        ),),
    );
  }

  Future<void> getData() async{
    var res = await CallApi().getData("/api/v1/categoryCompte");
    var body = jsonDecode(utf8.decode(res.bodyBytes));
    if(body['success']){
      for(var json in body['object'])
        comptes.add(Compte.fromJson(json));
      for(var json in body['objectArray'])
        categories.add(CategoryCompte.fromJson(json));

      setState(() {
        load = false;
      });
    }
    if (kDebugMode) {
      print('comptes : ${comptes.length}');
      print('categories : ${categories.length}');
    }
  }

}