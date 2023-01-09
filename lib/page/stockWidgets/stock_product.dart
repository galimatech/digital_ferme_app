import 'dart:convert';

import 'package:agri_galimatech/page/utilWidgets/TitleDynamic.dart';
import 'package:agri_galimatech/page/utilWidgets/iconSizeAccueil.dart';

import '../../page/stockWidgets/stock.dart';
import '../../utils/service.dart';
import '../../widget/external_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import '../utilWidgets/labelDynamic.dart';

class StockProduct extends StatefulWidget {
  final String productName;
  final String category;
  final String unitVolume;
  final String unitValue;
  const StockProduct(this.productName,this.category,this.unitVolume,this.unitValue);

  @override
  _StockProductState createState() => _StockProductState(this.productName);
}

class _StockProductState extends State<StockProduct> {
  String productName;
  _StockProductState(this.productName);
  String type = "in";
  DateTime _dateTime = DateTime.now();
  late String formattedDate;
  TextEditingController _controllerQuantity = new TextEditingController();
  TextEditingController _controllerVolume = new TextEditingController();
  TextEditingController _controllerDescription = new TextEditingController();
  var _key = GlobalKey<FormState>();

  @override
  initState(){
    initializeDateFormatting();
    var formatter = new DateFormat.yMMMMEEEEd('fr');
    formattedDate = formatter.format(_dateTime);
    super.initState();
  }

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
              /* actions: <Widget>[IconButton(icon: const Icon(Icons.storage), onPressed: () {})], */
            )),
            
        body: Container(
          child: formular(),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("images/stock.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        ));
  }

  Widget formular() {
    return SafeArea(
        top: false,
        bottom: false,
        child: Container(
            height: MediaQuery.of(context).size.height - 65,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Color.fromRGBO(255, 255, 255, 0.6),
            ),
            child: Form(
        key: _key,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          padding: EdgeInsets.symmetric(vertical: 5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Row(
                          children: [
                            Expanded(
                                  child: ListTile(title: const Text('Entrée'),leading: Radio(value: "in",groupValue: type,
                                            onChanged: (value) {
                                              setState(() {
                                                type = value.toString();
                                              }); },),),),
                            Expanded(
                              child: ListTile(title: const Text('Sortie'), leading: Radio( value: "out", groupValue: type,
                                  onChanged: (value) {
                                    setState(() {
                                      type = value.toString();
                                    }); },), ), ),],)),
              Padding(padding: EdgeInsets.symmetric(vertical: 20.0,horizontal: 20.0),
              child: TextFormField(
                enabled: false,
              initialValue: productName,
              decoration: InputDecoration(border: OutlineInputBorder(),
              labelText: widget.category,icon: Icon(Icons.spa_outlined)),),),
              Padding(padding: EdgeInsets.symmetric(vertical: 20.0,horizontal: 20.0),
              child: TextFormField(controller: _controllerQuantity,keyboardType: TextInputType.number,
              decoration: InputDecoration(border: OutlineInputBorder(),
              labelText: "Nombre de "+widget.unitValue,icon: Icon(Icons.spa_outlined)),
              validator: (value) {
                if (value!.isEmpty) return "La quantité est obligatoire"; else return null;
              },),),
              Padding(padding: EdgeInsets.symmetric(vertical: 20.0,horizontal: 20.0),
              child: TextFormField(controller: _controllerVolume,keyboardType: TextInputType.number,
              decoration: InputDecoration(border: OutlineInputBorder(),
              labelText: "Poids / Volume unitaire en "+widget.unitVolume,icon: Icon(Icons.spa_outlined)),
              validator: (value) {
                if (value!.isEmpty) return "Le poid est obligatoire"; else return null;
              },),),
              Padding(padding: EdgeInsets.symmetric(vertical: 20.0),
              child: TextFormField(controller: _controllerDescription,keyboardType: TextInputType.multiline,maxLines: 3,
              decoration: InputDecoration(border: OutlineInputBorder(),
              labelText: "Description",icon: const Icon(Icons.spa_outlined)),),),
              Padding(padding: EdgeInsets.all(8.0),
              child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 20),
                        ),
                        Expanded(
                          child: Center(
                              child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF00CC00)),
                            
                            ),
                           child: Padding(
                              padding: EdgeInsets.only(top: 15, bottom: 15.0, left: 25.0, right: 25.0),
                              child: DynamicText(
                                'VALIDER',
                                FontWeight.normal,
                              Colors.white
                              ),
                           ),
                            onPressed: () {
                              if (_key.currentState!.validate()) _onSave(context);
                            },
                          )),
                        )
                      ],
                    ),)
            ],
          ),)),));
  }

  Future<void> _onSave(BuildContext context) async {
    var formatter = new DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(_dateTime);
    DateTime created = DateTime.now();
    String createdOn = formatter.format(created);

    var data = {
      'id': null,
      'type': type,
      'value': _controllerQuantity.text,
      'unitVolume': widget.unitVolume,
      'unitValue': widget.unitValue,
      'volume': _controllerVolume.text,
      'description': _controllerDescription.text,
      'createdOn': createdOn,
      'updatedOn': createdOn,
      'date': formattedDate,
      'product': productName,
      'category': widget.category,
      'user': null
    };
    var response = await CallApi().postData(data, "/api/v1/incoming");
    var body = jsonDecode(utf8.decode(response.bodyBytes));
    if (body['success']) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => StockPage(1)));
    }else{
      MyWidget().notification(context, body['message']);
    } 
    }
}