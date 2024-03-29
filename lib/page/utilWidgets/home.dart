import 'dart:async';

import '../../page/shopWidgets/operation_list.dart';
import '../../page/shopWidgets/shop.dart';
import '../../page/stockWidgets/stock.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../speculationWidgets/farming.dart';
import 'login.dart';
import '../poultryWidgets/poultry.dart';

class HomePage extends StatefulWidget {
  //String role;
  //HomePage(this.role);
  const HomePage({Key, key}):super(key: key);
 //@required widget.role, 

  @override
  _HomePageState createState() => _HomePageState(); 

}

class _HomePageState extends State<HomePage> {
  String ? role;
  

  @override
  void initState() {
    
    Timer(Duration(seconds: 5), (() {
      getSharedPrefs();
    }));
    super.initState();
    

  }

   Stream<int> getRole() async* {
    getSharedPrefs();
    yield 1;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          actions: <Widget>[IconButton(icon: const Icon(Icons.settings_power_outlined), onPressed: () {logOut(context);})],
          title: ClipRect(
              child: Image.asset(
            'images/logoFarm.gif',
            width: 60.0,
            height: 60.0,
          ))),
      body: loading());

  Widget loading() {
    return menu(); // album(pictures);
  }

  Widget album(List data) {
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 10, vertical: 20),
        itemCount: data.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            elevation: 0,
            color: Colors.white, //green[100],
            child: ClipRRect(
              child: Image.network(
                data[index]['url'],
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
          );
        });
  }

  getSharedPrefs()async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    role =localStorage.getString("role") as String;
    //print(role);
    
  }

  Widget menu()  {

    return StreamBuilder<int>(
    stream: getRole(),
    //initialData: 0,
    builder: (
        BuildContext context,
        AsyncSnapshot<int> snapshot,
        ) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            Visibility(
              visible: snapshot.hasData,
              child: Text(
                snapshot.data.toString(),
                style: const TextStyle(color: Colors.black, fontSize: 24),
              ),
            ),
          ],
        );
      } else if (snapshot.connectionState == ConnectionState.active ||
          snapshot.connectionState == ConnectionState.done) {
            return (role=="admin") ? verifAdmin() : (role=="technician")? verifTechnician():verifCashier();
      } else {
        return Text('State: ${snapshot.connectionState}');
      }
    },
  );

   
  }

  Widget verifAdmin(){
    return GridView.count(
      crossAxisCount: 2,
      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 10, vertical: 20),
      children: <Widget>[
/*         GestureDetector(
          onTap: () {Navigator.pushAndRemoveUntil<void>(context,MaterialPageRoute<void>(builder: (BuildContext context) => CattlePage(),
      ),ModalRoute.withName("/"));},
          child: Card(
              elevation: 0,
              color: Colors.white, //green[100],
              child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("images/cattle.jpg"),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  child: Container(
                    decoration: BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0.7), borderRadius: BorderRadius.all(Radius.circular(30))),
                    child: Center(
                      child: Text(
                        "Elevage",
                        style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ))),
        ), */
        GestureDetector(
          onTap: () {Navigator.pushAndRemoveUntil<void>(context,MaterialPageRoute<void>(builder: (BuildContext context) => PoultryPage(),
      ),ModalRoute.withName("/"));},
          child: Card(
              elevation: 0,
              color: Colors.white, //green[100],
              child: Container(
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("images/poultry.png"),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  child: Container(
                    decoration: const BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0.7), borderRadius: BorderRadius.all(Radius.circular(30))),
                    child: Center(
                      child: Text(
                        "Aviculture",
                        style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ))),
        ),
/*         GestureDetector(
          onTap: () {Navigator.pushAndRemoveUntil<void>(context,MaterialPageRoute<void>(builder: (BuildContext context) => FishPage(),
      ),ModalRoute.withName("/"));},
          child: Card(
              elevation: 0,
              color: Colors.white, //green[100],
              child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("images/fish.jpg"),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  child: Container(
                    decoration: BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0.7), borderRadius: BorderRadius.all(Radius.circular(30))),
                    child: Center(
                      child: Text(
                        "Pisciculture",
                        style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ))),
        ), */
/*         GestureDetector(
          onTap: () {Navigator.pushAndRemoveUntil<void>(context,MaterialPageRoute<void>(builder: (BuildContext context) => TreePage(),
      ),ModalRoute.withName("/"));},
          child: Card(
              elevation: 0,
              color: Colors.white, //green[100],
              child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("images/tree.jpg"),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  child: Container(
                    decoration: BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0.7), borderRadius: BorderRadius.all(Radius.circular(30))),
                    child: Center(
                      child: Text(
                        "Arboculture",
                        style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ))),
        ), */
        GestureDetector(
          onTap: () {Navigator.pushAndRemoveUntil<void>(context,MaterialPageRoute<void>(builder: (BuildContext context) => FarmingPage(),
      ),ModalRoute.withName("/"));},
          child: Card(
              elevation: 0,
              color: Colors.white, //green[100],
              child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("images/speculation.jpg"),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  child: Container(
                    decoration: BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0.7), borderRadius: BorderRadius.all(Radius.circular(30))),
                    child: Center(
                      child: Text(
                        "Hortoculture",
                        style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ))),
        ),
        GestureDetector(
          onTap: () {Navigator.pushAndRemoveUntil<void>(context,MaterialPageRoute<void>(builder: (BuildContext context) => StockPage(0),
      ),ModalRoute.withName("/"));},
          child: Card(
              elevation: 0,
              color: Colors.white, //green[100],
              child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("images/stock.jpg"),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  child: Container(
                    decoration: BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0.7), borderRadius: BorderRadius.all(Radius.circular(30))),
                    child: Center(
                      child: Text(
                        "Stock",
                        style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ))),
        ),
        GestureDetector(
          onTap: () {Navigator.pushAndRemoveUntil<void>(context,MaterialPageRoute<void>(builder: (BuildContext context) => ShopPage(),
      ),ModalRoute.withName("/"));},
          child: Card(
              elevation: 0,
              color: Colors.white, //green[100],
              child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("images/shop.jpg"),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  child: Container(
                    decoration: BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0.7), borderRadius: BorderRadius.all(Radius.circular(30))),
                    child: Center(
                      child: Text(
                        "Vente",
                        style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ))),
        ),
         GestureDetector(
          onTap: () {Navigator.pushAndRemoveUntil<void>(context,MaterialPageRoute<void>(builder: (BuildContext context) => OperationPage(),
      ),ModalRoute.withName("/"));},
          child: Card(
              elevation: 0,
              color: Colors.white, //green[100],
              child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("images/operation.jpg"),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  child: Container(
                    decoration: BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0.7), borderRadius: BorderRadius.all(Radius.circular(30))),
                    child: Center(
                      child: Text(
                        "Finance",
                        style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ))),
        ) ,
      ],
    );
    
  }

Widget verifTechnician(){
    return GridView.count(
      crossAxisCount: 2,
      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 10, vertical: 20),
      children: <Widget>[
     GestureDetector(
          onTap: () {Navigator.pushAndRemoveUntil<void>(context,MaterialPageRoute<void>(builder: (BuildContext context) => PoultryPage(),
      ),ModalRoute.withName("/"));},
          child: Card(
              elevation: 0,
              color: Colors.white, //green[100],
              child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("images/poultry.png"),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  child: Container(
                    decoration: BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0.7), borderRadius: BorderRadius.all(Radius.circular(30))),
                    child: Center(
                      child: Text(
                        "Aviculture",
                        style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ))),
        ),
     GestureDetector(
          onTap: () {Navigator.pushAndRemoveUntil<void>(context,MaterialPageRoute<void>(builder: (BuildContext context) => FarmingPage(),
      ),ModalRoute.withName("/"));},
          child: Card(
              elevation: 0,
              color: Colors.white, //green[100],
              child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("images/speculation.jpg"),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  child: Container(
                    decoration: BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0.7), borderRadius: BorderRadius.all(Radius.circular(30))),
                    child: Center(
                      child: Text(
                        "Hortoculture",
                        style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ))),
        ),
        GestureDetector(
          onTap: () {Navigator.pushAndRemoveUntil<void>(context,MaterialPageRoute<void>(builder: (BuildContext context) => StockPage(0),
      ),ModalRoute.withName("/"));},
          child: Card(
              elevation: 0,
              color: Colors.white, //green[100],
              child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("images/stock.jpg"),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  child: Container(
                    decoration: BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0.7), borderRadius: BorderRadius.all(Radius.circular(30))),
                    child: Center(
                      child: Text(
                        "Stock",
                        style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ))),
        ),
        GestureDetector(
          onTap: () {Navigator.pushAndRemoveUntil<void>(context,MaterialPageRoute<void>(builder: (BuildContext context) => ShopPage(),
      ),ModalRoute.withName("/"));},
          child: Card(
              elevation: 0,
              color: Colors.white, //green[100],
              child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("images/shop.jpg"),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  child: Container(
                    decoration: BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0.7), borderRadius: BorderRadius.all(Radius.circular(30))),
                    child: Center(
                      child: Text(
                        "Vente",
                        style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ))),
        ),
      ],
    );
    
  }

Widget verifCashier(){
    return GridView.count(
      crossAxisCount: 2,
      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 10, vertical: 20),
      children: <Widget>[
     GestureDetector(
          onTap: () {Navigator.pushAndRemoveUntil<void>(context,MaterialPageRoute<void>(builder: (BuildContext context) => ShopPage(),
      ),ModalRoute.withName("/"));},
          child: Card(
              elevation: 0,
              color: Colors.white, //green[100],
              child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("images/shop.jpg"),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  child: Container(
                    decoration: BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0.7), borderRadius: BorderRadius.all(Radius.circular(30))),
                    child: Center(
                      child: Text(
                        "Vente",
                        style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ))),
        ),
       ],
    );
    
  }


    Future<void> logOut(BuildContext context) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var remove = await localStorage.remove("token");
    if(remove){
      
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) {
        return LoginPage();
      }),
    ); 

 

    
  }
  }

  
    
}
