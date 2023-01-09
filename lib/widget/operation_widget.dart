import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'external_widget.dart';
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
  TextEditingController _controllerOperation = new TextEditingController();
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
        ElevatedButton(child: const Text("Effectuer"),
        onPressed: () { if(_key.currentState!.validate()) _saveOperation();}),
        ElevatedButton(child: const Text("Annuler"),
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
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            Padding(padding: const EdgeInsets.symmetric(vertical: 20.0,horizontal: 20.0),
            child:TextFormField(
              controller:_controllerOperation, decoration: const InputDecoration(border: OutlineInputBorder(),
              labelText: "Opération"),
            ),),
            Padding(padding: const EdgeInsets.symmetric(vertical: 20.0,horizontal: 20.0),
            child: TextFormField(controller: _controllerAmount, decoration: const InputDecoration(border: OutlineInputBorder(),
            labelText: "Montant dépensé"), keyboardType: TextInputType.number,),), 
            Padding(padding: const EdgeInsets.symmetric(vertical: 20.0,horizontal: 20.0),
            child:buildCompte()),
            Padding(padding: EdgeInsets.symmetric(vertical: 20.0,horizontal: 20.0), 
            child: buildCategories(),
            ), 
            Padding(padding: EdgeInsets.symmetric(vertical: 20.0,horizontal: 20.0),
            child: TextFormField(controller: _controllerComment, decoration: InputDecoration(border: OutlineInputBorder(),
            labelText: "Description"),),
            ),
          ],
        ),),
    );
  }

  Widget buildCompte() =>TypeAheadFormField(
    textFieldConfiguration: TextFieldConfiguration(
      decoration: const InputDecoration(labelText: "Compte", border: OutlineInputBorder()), 
      controller: _controllerCompte,),
      suggestionsCallback: (pattern){
        List<Compte> matches = <Compte> [];
        matches.addAll(comptes);
        matches.retainWhere((element) => element.number.contains(pattern));
        return matches;
            }, 
      itemBuilder: (context, Compte compte)=> ListTile(
        title: Text(compte.number),
      ), 
      onSuggestionSelected: (Compte suggestion){
         _selectedComptes=suggestion;
         _controllerCompte.text=suggestion.number;
        validator: (value) {
            if (value.isEmpty) {
              return 'Le compte est obligatoire';
            }else{ return null;}
          };
          //onSaved: (value) => this._selectedComptes = value;
      }
  );


  Widget buildCategories() =>TypeAheadFormField(
    textFieldConfiguration: TextFieldConfiguration(
      decoration: const InputDecoration(labelText: "Catégorie", border: OutlineInputBorder()), 
      controller: _controllerCategory,),
      suggestionsCallback: (pattern){
        List<CategoryCompte> matches = <CategoryCompte> [];
        matches.addAll(categories);
        return matches;
            }, 
      itemBuilder: (context, CategoryCompte suggestion)=> ListTile(
        title: Text(suggestion.name),
      ), 
      onSuggestionSelected: (CategoryCompte categorie){
         _selectedCategory=categorie;
         _controllerCategory.text=categorie.name;
         validator: (value) {
            if (value.isEmpty) {
              return 'La catégorie est obligatoire';
            }else{ return null;}
          };
          //onSaved: (value) => this._controllerCategory = value;
            },   
  );

  Future<void> getData() async{
    var res = await CallApi().getData("/api/v1/categoryCompte");
    var body = jsonDecode(utf8.decode(res.bodyBytes));
    //print(body);
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

  Future<void> _saveOperation() async{
    DateTime dateCreated = DateTime.now();
    String formattedDate= new DateFormat("yyyy-MM-dd").format(dateCreated);
    var utc=DateTime.utc(1969,7,20,20,18,04);
    var localDate=dateCreated.toIso8601String();

    var data = Map<String, dynamic>();
    data['createdOn']=formattedDate;
    data['updatedOn']=formattedDate;
    data['amount']=_controllerAmount.text;
    data['comment']=_controllerComment.text;
    data['date']=localDate;
    data['label']=_controllerOperation.text;
    data['category']=_selectedCategory.toMap();
    data['compte']=_selectedComptes.toMap();
    print(data);
    var res= await CallApi().postData(data, "/api/v1/operation");
    var body = jsonDecode(utf8.decode(res.bodyBytes));
    print(body);
    if (body['success']) {
      MyWidget().notification(context, "Ajout d'une nouvelle  opération réussie");
      Navigator.of(context).pop();
      
    } else {
      MyWidget().notification(context, "Echec de l'enregistrement");
      Navigator.of(context).pop();
      
    }
  }
}