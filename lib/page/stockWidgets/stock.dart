import 'dart:async';
import 'dart:convert';
import 'package:agri_galimatech/page/utilWidgets/TitleDynamic.dart';

import '../../page/stockWidgets/matiere_history.dart';
import '../../page/stockWidgets/stock_detail.dart';
import '../../page/stockWidgets/stock_history.dart';
import '../../page/stockWidgets/stock_product.dart';
import '../../utils/service.dart';
import '../../widget/external_widget.dart';
import '../../widget/new_matiere_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utilWidgets/home.dart';

class StockPage extends StatefulWidget {
  final int index;
  const StockPage(this.index);

  @override
  _StockPageState createState() => _StockPageState();
}

class _StockPageState extends State<StockPage> {
List stocks = [];
List products = [];
List shops = [];
TextEditingController qte = new TextEditingController();
TextEditingController val = new TextEditingController();
TextEditingController advance = new TextEditingController();
TextEditingController account = new TextEditingController();
var _formKey = GlobalKey<FormState>();
@override
  void initState() {
    getOutgoingStock();
    getProduct();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: widget.index,
      length: 2,
      child : Scaffold(
        backgroundColor: Colors.green[100],
        appBar:  AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          title: ClipRect(child: Image.asset('images/logoFarm.gif',width: 60.0,height: 60.0,)),
          actions: <Widget>[ IconButton(icon: const Icon(Icons.list_alt_outlined),onPressed: () {
            showDialog(context: context, builder: (_){
              return NewMatiere();
            },barrierDismissible: false);
          })],
          bottom:  const TabBar(
            isScrollable: true,
            indicatorColor: Color(0xFF7ED957),
            labelColor: Color(0xFF7ED957),
            tabs: <Widget>[
              Tab(icon: Icon(Icons.cloud_upload_outlined),text: "Stock Produit",),
              Tab(icon: Icon(Icons.cloud_download_outlined),text: "Stock Matière",)]),),
        floatingActionButton: SpeedDial(
          animatedIcon: AnimatedIcons.menu_close,
          overlayColor: Colors.black,
          overlayOpacity: 0.2,
          children: [
            SpeedDialChild(
              child: Icon(Icons.home_outlined,color: Colors.green,),
              label: "Accueil",
              labelStyle: TextStyle(color: Colors.green),
              onTap: () => Navigator.pushAndRemoveUntil<void>(context,MaterialPageRoute<void>(
                builder: (BuildContext context) => HomePage(),),ModalRoute.withName("/"))),
            SpeedDialChild(
              child:  Icon(Icons.local_florist_outlined,color: Colors.green,),
              label: "Stock nouveau matière",
              labelStyle: TextStyle(color: Colors.green),
              onTap: () => showDialog(context: context, builder: (_){
              return NewMatiere();
            },barrierDismissible: false)
            ),
            SpeedDialChild(
              child: Icon(Icons.local_florist_outlined,color: Colors.green),
              label: "Historique des matières",
              labelStyle: TextStyle(color: Colors.green),
              onTap: () => Navigator.push(context,MaterialPageRoute(builder: (_) => MatiereHistoryPage()))
            ),
            SpeedDialChild(
              child: Icon(Icons.spa_outlined,color: Colors.green),
              label: "Historique des stocks",
              labelStyle: TextStyle(color: Colors.green),
              onTap: () => Navigator.push(context,MaterialPageRoute(builder: (_) => StockHistoryPage()))
            )
          ],
        ),
         body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("images/stock.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: TabBarView(
          children: <Widget>[
            itemMerchandise(),
            itemProduct(),]),
        )));
  }

  Future<void> getOutgoingStock() async{
    var response = await CallApi().getData("/api/v1/outgoing/produit");
    var body = jsonDecode(utf8.decode(response.bodyBytes));
    if(body["success"]){
      setState(() {
        stocks = body["stocks"];
      });
    }
  }

  Future<void> getProduct() async{
    var response = await CallApi().getData("/api/v1/incoming");
    var body = jsonDecode(utf8.decode(response.bodyBytes));
    if(body["success"]){
      setState(() {
        products = body["stocks"];
      });
    }
  }

Widget itemProduct() {
    return GridView.builder(
      itemCount: products.length,
      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 15, vertical: 20),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,crossAxisSpacing: 10.0,mainAxisSpacing: 10.0),
      itemBuilder: (BuildContext context,int index){
        return GestureDetector(
          onTap: () { Navigator.of(context).push(MaterialPageRoute(builder: (_) => StockProduct(products[index]["product"],products[index]["category"],products[index]["unit"],products[index]["unitValue"])));},
          child: Card(
              elevation: 0,
              color: Color.fromRGBO(0, 0, 0, 0.5),
              child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      DynamicText(products[index]["product"], FontWeight.bold, Colors.white ,//textAlign: TextAlign.center,
                      ),
                      DynamicText(products[index]["quantity"].toString(), FontWeight.bold, Color(0xFF7ED957),),
                      DynamicText(products[index]["unit"], FontWeight.bold, Colors.white,),
                    ],))),);},);}

Widget itemMerchandise() {
    return GridView.builder(
      itemCount: stocks.length,
      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 15, vertical: 20),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,crossAxisSpacing: 0.0,mainAxisSpacing: 10.0),
      itemBuilder: (BuildContext context,int index){
        return GestureDetector(
          onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => StockDeatilPage(stocks[index]["product"]))),
          child: Card(
              elevation: 0,
              color: Color.fromRGBO(0, 0, 0, 0.5),
              child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    
                    children: [
                      DynamicText(stocks[index]["product"],FontWeight.bold, Colors.white,//textAlign: TextAlign.center,
                      ),
                      DynamicText(stocks[index]["quantity"].toString(),FontWeight.bold,Color(0xFF7ED957), ),
                      DynamicText("En Boutique", FontWeight.bold, Colors.white,//textAlign: TextAlign.center,
                      ),
                      DynamicText(stocks[index]["inShop"].toString(), FontWeight.bold, Color(0xFF7ED957),),
                    ],))),);},);}

void formDialog(context,String subject) {
   showDialog(context: context, builder: (context){
     return AlertDialog(
                  backgroundColor: Color.fromRGBO(255, 255, 255, 1),
                  title: Text("Vendre "+subject,style: TextStyle(fontSize: 35.0,fontWeight: FontWeight.bold,)),
                  content: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                        padding: EdgeInsets.all(35.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 20.0),
                                child: TextFormField(
                                  keyboardType:TextInputType.number,controller:this.qte,
                                  decoration: InputDecoration(border:OutlineInputBorder(),
                                    icon: Icon(Icons.hourglass_bottom_outlined), labelText:"La quantite de la vente "),
                                  validator: (value) {if (value!.isEmpty) {return "La quantite est obligatoire ";}else return null; },),),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 20.0),
                                child: TextFormField(
                                  keyboardType:TextInputType.number,controller:this.val,
                                  decoration: InputDecoration(border:OutlineInputBorder(),
                                   icon: Icon(Icons.hourglass_bottom_outlined), labelText:"La valeur total de la vente "),
                                  validator: (value) { if (value!.isEmpty) { return "La valeur est obligatoire "; } else return null;},),),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 20.0),
                                child: TextFormField(
                                  keyboardType:TextInputType.number,controller:this.advance,
                                  decoration: InputDecoration(border:OutlineInputBorder(),
                                   icon: Icon(Icons.hourglass_bottom_outlined), labelText:"La valeur à l'avance "),
                                  validator: (value) { if (value!.isEmpty) { return "La valeur de l'avance est obligatoire sinon mettez 0"; } else return null;},),),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 20.0),
                                child: TextFormField(
                                  keyboardType:TextInputType.number,controller:this.account,
                                  decoration: InputDecoration(border:OutlineInputBorder(),
                                   icon: Icon(Icons.hourglass_bottom_outlined), labelText:"La valeur restante "),
                                  validator: (value) { if (value!.isEmpty) { return "La valeur restante est obligatoire sinon mettez 0"; } else return null;},),),
                            ]))),
                  actions: [
                    IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.thumb_down),iconSize: 100,color: Colors.red),
                    SizedBox(width: 100,),
                    IconButton(onPressed: ()  {if (_formKey.currentState!.validate())
                                       _onSave(subject, context);}, icon: Icon(Icons.save_alt_outlined),iconSize: 100,color: Colors.green),
                  ]
     );
   },barrierDismissible: false);

 }

 Future<void> _onSave(String subject,context) async{
   Navigator.pop(context);
   SharedPreferences localStorage = await SharedPreferences.getInstance();
   String? username = localStorage.getString("username");
   String? shopId = localStorage.getString("shopId");
   if(shopId == null || username == null){
     MyWidget().notification(context, "Veuillez ouvrir une caisse");
   }else{
    var data = {"shopId":shopId, "produit":subject, "price": int.tryParse(val.text),
      "quantity":int.tryParse(qte.text), "username":username,"advance":advance.text,"account":account.text};

      var response = await CallApi().postData(data, "/api/v1/outgoing/sale");
      var body = jsonDecode(utf8.decode(response.bodyBytes));
      if(body['success']){
        MyWidget().notification(context, body['message']);
        getOutgoingStock();}
      else{
        MyWidget().notification(context, body['message']);
      }
 }
 }

}