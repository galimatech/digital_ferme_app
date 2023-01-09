import 'dart:convert';

import '../../page/utilWidgets/home.dart';
import '../../utils/service.dart';
import '../../utils/shop.dart';
import '../../widget/external_widget.dart';
import '../../widget/spinner_widget.dart';
import "package:flutter/material.dart";
import 'package:shared_preferences/shared_preferences.dart';

import 'shop_stock.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({ Key? key }) : super(key: key);

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  List<Shop> shops = [];
  bool load = true;
  num imOpen = 0;
  TextEditingController _controller = new TextEditingController();
  @override
  void initState() {
    getShop();
    super.initState();
    getOpenShop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60.0), // here the desired height
          child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          title: ClipRect(child: Image.asset('images/logoFarm.gif',width: 60.0,height: 60.0,)),
          /* actions: <Widget>[ IconButton(icon: const Icon(Icons.home_outlined),onPressed: () {})], */
        )),
        floatingActionButton: IconButton(onPressed: (){Navigator.pushAndRemoveUntil<void>(context,MaterialPageRoute<void>(builder: (BuildContext context) => HomePage(),
      ),ModalRoute.withName("/"));}, icon: const Icon(Icons.home,size: 35.0,)),
        body: Container( child: load? Center(child: SpinnerWidget()) : itemStock(),
        decoration: const BoxDecoration(image: DecorationImage(image: AssetImage("images/shop.jpg"),fit: BoxFit.cover,),),),
    );
  }

  Widget itemStock() {
    return GridView.builder(
      itemCount: shops.length,
      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 10, vertical: 20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,crossAxisSpacing: 10.0,mainAxisSpacing: 10.0),
       itemBuilder: (BuildContext context,int index){
        return GestureDetector(
          onTap: () { handleShop(context,shops[index]);},
          child: Card(
              elevation: 0,
              color: const Color.fromRGBO(0, 0, 0, 0.5),
              child: Container(
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(shops[index].name,style: const TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                      const SizedBox(height: 15.0,),
                      const Icon(Icons.shopping_cart_outlined,size: 50),
                      imOpen == shops[index].id ? const Icon(Icons.lock_open_rounded): SizedBox(height: 1.0,)
                    ],))),);},);}

  Future<void> getShop() async {
    var res = await CallApi().getData("/api/v1/shop");
    if (res.statusCode == 401) {
      CallApi().logOut(context);
    } else if(res.statusCode == 200){
      var body = jsonDecode(utf8.decode(res.bodyBytes));
      if(body['success']){
      for(var data in body['shops'])
        shops.add(Shop.fromJson(data));
      setState(() {
        load = false;
      });
    }
    } else{
       MyWidget().notifationAlert(context, "Il y'a une erreur au seveur principal revenez plus tard.", Colors.amber);
    }
  }

  Future<void> getOpenShop() async{
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var shopId = localStorage.getString("shopId");
    if(shopId != null)
      if(num.tryParse(shopId) != null){
        imOpen = num.parse(shopId);
      }
  }

  Future<void> handleShop(context,Shop shop) async{
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var shopId = localStorage.getString("shopId");
    var shopName = localStorage.getString("shopName");
    if(shopId == null){
          getStatus(shop);
    }else if(shopId == shop.id.toString()){
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => ShopStockPage(shop.id.toInt())));
    }
    else{
        MyWidget().notifationAlert(context, "Veuillez fermer la boutique "+shopName!, Colors.amber);
    }
  }

  Future<void> getStatus(Shop shop) async{
    showDialog(barrierDismissible: false, context: context, builder: (_){
      return AlertDialog(
        actionsAlignment: MainAxisAlignment.spaceBetween,
        title: const Text("Votre code SVP!",style: TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),),
        content: TextField(
          controller: _controller,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(border: OutlineInputBorder(),labelText: "Saisir code"),
        ),
        actions: [
          ElevatedButton(onPressed: () async {
            var data = {
              "shopId": shop.id,
              "access": _controller.text
            };
            var res = await CallApi().postData(data,"/api/v1/shopStatus") ;
            var body = jsonDecode(utf8.decode(res.bodyBytes));
            if(body['success'])
             confirm(body['message'], shop,body['object']['status'],body['object']['cash']);
             else
              MyWidget().notifationAlert(context, body['message'], Colors.red);
          }, 
          child: const Text("Soumettre",style: TextStyle(color: Colors.white),)),
          ElevatedButton(onPressed: (){Navigator.of(context).pop();},
           style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.red)),
           child: const Text("Abandonner",style: TextStyle(color: Colors.white),)),
        ],
      );
    });

  }

  Future<void> confirm(String message,Shop shop,bool status,int cash) async{
    Navigator.of(context).pop();
    showDialog(barrierDismissible: false, context: context, builder: (_){
      return AlertDialog(
        actionsAlignment: MainAxisAlignment.spaceBetween,
        content: Text(message,style: TextStyle(fontSize: 20.0,),),
        actions: [
          ElevatedButton(onPressed: () async {
            var data = {"shopId": shop.id,"cash":cash};
            if(status){
                Navigator.of(context).pop();
                var res = await CallApi().postData(data,"/api/v1/shopStatus/close");
                var body = jsonDecode(utf8.decode(res.bodyBytes));
                if(body['success']){
                    SharedPreferences localStorage = await SharedPreferences.getInstance();
                    localStorage.remove("shopId");
                    localStorage.remove("shopName");
                    localStorage.remove("reimburse");
                    Navigator.pushAndRemoveUntil<void>(context,MaterialPageRoute<void>(builder: (context) => ShopPage()),
                    ModalRoute.withName("/"));
                }
                else MyWidget().notifationAlert(context, body['message'], Colors.red);
            }else{
              var res = await CallApi().postData(data,"/api/v1/shopStatus/open");
              var body = jsonDecode(utf8.decode(res.bodyBytes));
              if(body['success']){
                SharedPreferences localStorage = await SharedPreferences.getInstance();
                localStorage.setString("shopId", shop.id.toString());
                localStorage.setString("shopName", shop.name);
                localStorage.setString("cash", cash.toString());
                localStorage.setString("reimburse", "0");
                Navigator.pushAndRemoveUntil<void>(context,MaterialPageRoute<void>(builder: (BuildContext context) => ShopStockPage(shop.id.toInt()),
                ),ModalRoute.withName("/"));
              }
              else
                MyWidget().notifationAlert(context, body['message'], Colors.red);
            }
          },
           child: Text("Oui",style: TextStyle(color: Colors.white),)),
          ElevatedButton(onPressed: (){Navigator.of(context).pop();},
           style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.red)),
           child: Text("Annuler",style: TextStyle(color: Colors.white),))
        ],
      );
    });
  }
}