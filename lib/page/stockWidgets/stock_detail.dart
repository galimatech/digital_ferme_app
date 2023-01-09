import 'dart:convert';
import 'package:agri_galimatech/page/utilWidgets/TitleDynamic.dart';
import 'package:agri_galimatech/page/utilWidgets/labelDynamic.dart';

import '../../utils/service.dart';
import '../../utils/shop.dart';
import '../../widget/spinner_widget.dart';
import 'package:flutter/material.dart';

class StockDeatilPage extends StatefulWidget {
  final String inStore;
  final String product;
  const StockDeatilPage(this.inStore,this.product);

  @override
  State<StockDeatilPage> createState() => _StockDeatilPageState(this.inStore,this.product);
}

class _StockDeatilPageState extends State<StockDeatilPage> {
  String inStore;
  String product;
  _StockDeatilPageState(this.inStore,this.product);
  bool load = true;
  List stocks = [];
  @override
  void initState() {
    getStock(this.product);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
         appBar:  AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          title: ClipRect(child: Image.asset('images/logoFarm.gif',width: 60.0,height: 60.0,)),
      /*     actions: <Widget>[ IconButton(icon: const Icon(Icons.list_alt_outlined),onPressed: () {})] ,*/),
          body:
           Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("images/stock.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: load ? Center( child: SpinnerWidget() ): screen(),
        ));
  }

  Future<void> getStock(String product) async{
    var res = await CallApi().getData("/api/v1/outgoing/product/detail/"+product);
    var body = jsonDecode(utf8.decode(res.bodyBytes));
    if(body["success"])
      setState(() {
        stocks = body["stocks"];
        load = false;
      });
  }

   Widget screen() {
    return  Column(
        children: <Widget>[
          Expanded(
              flex: 1,
              child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Container(
                width: MediaQuery.of(context).size.width - 60,
                padding: EdgeInsets.symmetric(vertical: 7.0),
                  decoration: BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0.6), borderRadius: BorderRadius.all(Radius.circular(15))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      DynamicText("Stock de "+product, FontWeight.bold,Colors.white),
                      DynamicText("En entrepot : "+inStore, FontWeight.bold, Colors.white,)
                    ]
                  )))),
          Expanded(
            flex: 5,
            child: itemGrid())]);
   }
   
   Widget itemGrid(){
    return GridView.builder(
      itemCount: stocks.length,
      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 20, vertical: 20),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,crossAxisSpacing: 10.0,mainAxisSpacing: 10.0),
      itemBuilder: (BuildContext context,int index){
        return GestureDetector(
          onTap: () {moveDirection(Shop.fromJson(stocks[index]["shop"]), product); },
            //MyWidget().formReverse(context,product,stocks[index]["shop"]["id"].toString(),stocks[index]["shop"]["name"]);},
          child: Card(
              elevation: 0,
              color: Color.fromRGBO(0, 0, 0, 0.5),
              child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      DynamicText(stocks[index]["shop"]["name"], FontWeight.bold, Colors.white //textAlign: TextAlign.center,
                      ),
                      Text(stocks[index]["shop"]["adress"].toString(),style: TextStyle(color: Colors.white, fontSize: 25,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                      Text(stocks[index]["quantity"].toString(),style: TextStyle(color: Color(0xFF7ED957), fontSize: 25,fontWeight: FontWeight.bold),),
                    ],))),);},);}



 void moveDirection(Shop shop,String product){
   TextEditingController controller = new TextEditingController();
   controller.text="0";
    showDialog(context: context, builder: (context){
      return AlertDialog(
        title: Text("Déplacer des "+product,style: TextStyle(fontSize: 20),),
        content: Container(height: 200.0, child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextFormField(
              controller:controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(border: OutlineInputBorder(),
              icon: Icon(Icons.hourglass_bottom_outlined),
              labelText: "La quantité")),
              ElevatedButton(onPressed: (){postStock(product,controller.text,"in",shop.id);}, child: DynamicLabel("De "+shop.name+" vers l'entrepot", FontWeight.normal, Colors.white)),
            ElevatedButton(onPressed: (){postStock(product,controller.text,"out",shop.id);}, child: DynamicLabel("De l'entrepot vers "+shop.name, FontWeight.normal,Colors.white))
          ],
        ),
      ));
    });
 }

 Future<void> postStock(String product, String quantity, String type, num shopId) async{

   var data = {
     "product":product,
     "quantity":quantity,
     "username":"nodefind",
     "shopId":shopId,
     "type":type
   };
   var res = await CallApi().postData(data, "/api/v1/reverse");
   var body = jsonDecode(utf8.decode(res.bodyBytes));
   if(body["success"]){
     if(type == "out"){
       setState(() {
          inStore = (int.parse(inStore) - int.parse(quantity)).toString();
       });
     }else{
       setState(() {
          inStore = (int.parse(inStore) + int.parse(quantity)).toString();
       });
     }
     getStock(product);
   }
   Navigator.of(context).pop();
 }
}