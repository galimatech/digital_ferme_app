import 'dart:convert';

import 'package:agri_galimatech/page/utilWidgets/TitleDynamic.dart';
import 'package:agri_galimatech/page/utilWidgets/labelDynamic.dart';

import '../../page/poultryWidgets/poultry.dart';
import '../../utils/poultry.dart';
import '../../utils/service.dart';
import '../../widget/external_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class PoultryOutPage extends StatefulWidget {
  final bool egg;
  final Poultry poultry;
  const PoultryOutPage(this.poultry, this.egg);

  @override
  _PoultryOutPageState createState() => _PoultryOutPageState(this.poultry, this.egg);
}

class _PoultryOutPageState extends State<PoultryOutPage> {
  bool egg;
  Poultry poultry;
  _PoultryOutPageState(this.poultry, this.egg);
  var _formKey = GlobalKey<FormState>();
  var _formKeyEgg = GlobalKey<FormState>();
  TextEditingController _controllerQty = new TextEditingController();
  TextEditingController _controllerVal = new TextEditingController();
  DateTime _dateTime = DateTime.now();
  late String formattedDate;
  bool isDead = false;

  @override
  void initState() {
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
              /* actions: <Widget>[IconButton(icon: const Icon(Icons.flutter_dash_outlined), onPressed: () {})], */
            )),
        body: Container(
          child: egg ? formularEgg() : formular(),
          // ignore: prefer_const_constructors
          decoration: BoxDecoration(
            image: const DecorationImage(
              image: AssetImage("images/poultry.png"),
              fit: BoxFit.cover,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        ));
  }

  Widget formular() {
    return SafeArea(
        top: false,
        bottom: false,
        child: Container(
            height: MediaQuery.of(context).size.height - 65,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Color.fromRGBO(255, 255, 255, 0.6),
            ),
            child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(35.0),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: <Widget>[
                    Padding(padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Text("Stockage de "+ poultry.categoryName, style: const TextStyle(fontSize: 24.0,fontWeight: FontWeight.bold),),),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        controller: this._controllerQty,
                        decoration: const InputDecoration(border: OutlineInputBorder(), icon: Icon(Icons.hourglass_bottom_outlined), labelText: "Nombre de poulets"),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "La quantité est obligatoire ";
                          } else
                            return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        controller: this._controllerVal,
                        decoration: const InputDecoration(border: OutlineInputBorder(), icon: Icon(Icons.money_outlined), labelText: "La valeur de la vente "),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "La valeur est obligatoire ";
                          } else
                            return null;
                        },
                      ),
                    ),
                    Padding(padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child:CheckboxListTile(
                        title: Text(
                          "Sortie pour décé",
                          style: TextStyle(
                              //color: Color(0xFF7ED957),
                              fontSize: 18,
                              fontWeight: FontWeight.normal),
                        ),
                        activeColor: Colors.black,
                        checkColor: Colors.white,
                        controlAffinity: ListTileControlAffinity.leading,
                        value: isDead,
                        onChanged: (bool? value) {
                          setState(() {
                            isDead = value!;
                          });
                        }),),
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Center(
                            child: TextButton(
                          child: Text(
                            formattedDate,
                            style: const TextStyle(fontSize: 20.0, color: Colors.black),
                          ),
                          onPressed: () {
                            DatePicker.showDatePicker(context,
                                showTitleActions: true,
                                theme: const DatePickerTheme(
                                    doneStyle: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF7ED957)), cancelStyle: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF7ED957))),
                                minTime: DateTime(2020, 1, 1),
                                maxTime: DateTime(2050, 12, 31),
                                onChanged: (date) {}, onConfirm: (date) {
                              setState(() {
                                _dateTime = date;
                                var formatter = new DateFormat.yMMMMEEEEd('fr');
                                formattedDate = formatter.format(date);
                              });
                            }, currentTime: DateTime.now(), locale: LocaleType.fr);
                          },
                        ))),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        const Padding(
                          padding: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 20),
                        ),
                        Expanded(
                          child: Center(
                              child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF00CC00)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 15, bottom: 15.0, left: 25.0, right: 25.0),
                              child: DynamicText(
                                'VALIDER',
                                  FontWeight.normal,
                                  Colors.white,
                              ),
                            ),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) _onSave();
                            },
                          )),
                        )
                      ],
                    ),
                  ]),
                ))));
  }

  Widget formularEgg() {
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
                key: _formKeyEgg,
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(35.0),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: <Widget>[
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Text("Ramassge d'oeuf",style: TextStyle(fontSize: 24.0,fontWeight: FontWeight.bold),),
                        ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.0),
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        controller: this._controllerQty,
                        decoration: InputDecoration(border: OutlineInputBorder(), icon: Icon(Icons.hourglass_bottom_outlined), labelText: "La quantité d'oeuf"),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "La quantité est obligatoire ";
                          } else
                            return null;
                        },
                      ),
                    ),              
                    Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: 10,
                                        bottom: 10,
                                        left: 10,
                                        right: 20),
                                  ),
                                  Expanded(
                                    child: Center(
                                        child: ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Color(0xFF00CC00)),
                                    ),
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            top: 15,
                                            bottom: 15.0,
                                            left: 25.0,
                                            right: 25.0),
                                        child: DynamicText(
                                          'VALIDER',
                                            FontWeight.normal,
                                            Colors.white,
                                        ),
                                      ),
                                      onPressed: () {
                                        if (_formKeyEgg.currentState!.validate()) {
                                          _onSaveEgg();
                                       }
                                      },
                                    )),
                                  )
                                ],
                              ),
                  ]),
                ))));
  }

  Future<void> _onSave() async {
    var formatter = new DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(_dateTime);
    DateTime created = DateTime.now();
    String createdOn = formatter.format(created);
    var data = {
      'id': null,
      'quantity': _controllerQty.text,
      'valeur': _controllerVal.text,
      'createdOn': createdOn,
      'updatedOn': createdOn,
      'date': formattedDate,
      'dead': isDead,
      'poultry': poultry.toMap()
    };

    var response = await CallApi().postData(data, "/api/v1/outPoultry");
    var body = jsonDecode(utf8.decode(response.bodyBytes));
    MyWidget().notification(context, body['message']);
    if (body['success']) {
      Navigator.pushAndRemoveUntil<void>(context,MaterialPageRoute<void>(builder: (BuildContext context) => PoultryPage(),
      ),ModalRoute.withName("/"));
    }
  }

  Future<void> _onSaveEgg() async {
    //print("on save egg");
    var formatter = new DateFormat('yyyy-MM-dd');
    DateTime created = DateTime.now();
    String createdOn = formatter.format(created);
    var data = {
      'id': null,
      'destination': "stock",
      'quantity': _controllerQty.text,
      'createdOn': createdOn,
      'updatedOn': createdOn,
      'poultry': poultry.toMap()
    };
     var response = await CallApi().postData(data, "/api/v1/egg");
    var body = jsonDecode(utf8.decode(response.bodyBytes));
    print(body);
    MyWidget().notification(context, body['message']);
    if (body['success']) {
      Navigator.pushAndRemoveUntil<void>(context,MaterialPageRoute<void>(builder: (BuildContext context) => PoultryPage(),
      ),ModalRoute.withName("/"));
    }
  }
}
