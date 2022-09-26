
import 'dart:convert';

import '../page/shopWidgets/shop_stock.dart';
import '../utils/service.dart';
import '../widget/external_widget.dart';
import '../widget/spinner_widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReverseForm extends StatefulWidget {
  final num shopId;
  const ReverseForm(this.shopId);

  @override
  State<ReverseForm> createState() => _ReverseFormState();
}

class _ReverseFormState extends State<ReverseForm> {
  TextEditingController _controller = new TextEditingController();
  var _key = GlobalKey<FormState>();
  String keepAmount = '0';
  late String message = "";
  late int myCash = 0;
  late bool load = true;

@override
  void initState() {
    getCashStatus();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Color.fromRGBO(255, 255, 255, 1),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      title: Text("Versement de liquidité",style: TextStyle(color: Colors.green,
      fontSize: 22.0,fontWeight: FontWeight.bold),),
      content: load ? Center(child: SpinnerWidget()) : Form(
                    key: _key,
                    child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(horizontal: 5.0,vertical: 20.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Padding(padding: EdgeInsets.symmetric(vertical: 10.0),
                              child: Text(message,style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.justify,),),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 20.0),
                                child: TextFormField(
                                  keyboardType:TextInputType.phone,
                                  controller:this._controller,
                                  decoration: InputDecoration(border:OutlineInputBorder(),
                                    icon: Icon(Icons.hourglass_bottom_outlined), labelText:"Montant à versé"),
                                    onChanged: (value) => calculKeepAmount(value),
                                  validator: (value) {if (value!.isEmpty) {return "Cette champ est obligatoire";}else return null; },),),
                              Padding(padding: EdgeInsets.symmetric(vertical: 20.0),
                                child: Text("Va rester en caisse : $keepAmount"),)
                            ]))),
      actions: [
                  ElevatedButton(onPressed: ()  {if (_key.currentState!.validate())
                                       _onSave(context);}, child: Text("Verser")),
                  ElevatedButton(onPressed: (){Navigator.pop(context);},child: Text("abandonner"),style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.red)),),
                    /* IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.thumb_down),iconSize: 75,color: Colors.red),
                    IconButton(onPressed: ()  {if (_key.currentState!.validate())
                                       _onSave(context);}, icon: Icon(Icons.save_alt_outlined),iconSize: 75,color: Colors.green), */
                  ]
    );
  }

  Future<void> _onSave(BuildContext context) async{
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String shopId = localStorage.getString("shopId")!;
    var data = {
      "shopId": shopId,
      //"payment": (int.parse(_controller.text) + int.parse(widget.currentAmount)).toString(),
      "cash": keepAmount
    };
    var res = await CallApi().postData(data, "/api/v1/makeInCompatability");
    if(res.statusCode == 401){
      CallApi().logOut(context);
    }else{
      var body = jsonDecode(utf8.decode(res.bodyBytes));
      if(body['success']){
        localStorage.setString("cash", keepAmount);
        Navigator.pushAndRemoveUntil<void>(context,MaterialPageRoute<void>(
          builder: (BuildContext context) => ShopStockPage(int.parse(shopId)),
      ),ModalRoute.withName("/"));
      }else{
        MyWidget().notifationAlert(context, body['message'], Colors.red);
      }
      
    }
  }

  void calculKeepAmount(String value){
    if (value.isNotEmpty) {
      setState(() {
        keepAmount = (myCash - int.parse(value)).toString();
      });
    }else{
      setState(() {
        keepAmount = '0';
      });
    }
  }

  Future<void> getCashStatus() async {
    var res = await CallApi().getData("/api/v1/amountToSave/"+widget.shopId.toString());
    var body = jsonDecode(utf8.decode(res.bodyBytes));
    if(body['success']){
      setState(() {
        myCash = body['object'];
        message = body['message'];
        load = false;
      });
    }
  }
}