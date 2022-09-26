import 'dart:convert';

import '../../utils/calendary.dart';
import '../../utils/fish.dart';
import '../../utils/service.dart';
import '../../widget/external_widget.dart';
import 'package:flutter/material.dart';

class FishDetail extends StatefulWidget {
  final String nameSubject;
  FishDetail(this.nameSubject);

  @override
  _FishDetailState createState() => _FishDetailState(this.nameSubject);
}

class _FishDetailState extends State<FishDetail> {
  String nameSubject;
  _FishDetailState(this.nameSubject);
  bool load = true;
  List<Calendary> calendars = [];
  late Fish fish;

  @override
  void initState() {
    getData();
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
              actions: <Widget>[
                IconButton(icon: const Icon(Icons.set_meal_outlined, size: 50), onPressed: () {}),
                SizedBox(
                  width: 10,
                )
              ],
            )),
        body: Container(
          child: load
              ? Center(
                  child: Image.asset(
                    'images/loading.gif',
                    width: 300.0,
                    height: 300.0,
                  ),
                )
              : screen(),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("images/fish.jpg"),
              fit: BoxFit.cover,
            ),
          ),
        ));
  }

  Widget screen() {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          Expanded(
              flex: 1,
              child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Container(
                  //height: 200,
                  decoration: BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0.6), borderRadius: BorderRadius.all(Radius.circular(15))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        children: [
                          Expanded(
                              child: Padding(
                                  padding: EdgeInsets.only(left: 10.0),
                                  child: Text(
                                    fish.name,
                                    style: TextStyle(fontSize: 30.0, color: Colors.white, fontWeight: FontWeight.bold),
                                  ))),
                          Expanded(child: Text(fish.categoryName, style: TextStyle(fontSize: 30.0, color: Colors.white)))
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(child: Padding(padding: EdgeInsets.only(left: 10.0), child: Text(fish.quantity.toString(), style: TextStyle(fontSize: 30.0, color: Colors.white)))),
                          Expanded(child: Text(fish.bowlName, style: TextStyle(fontSize: 30.0, color: Colors.white)))
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(child: Padding(padding: EdgeInsets.only(left: 10.0), child: Text(fish.date, style: TextStyle(fontSize: 30.0, color: Colors.white)))),
                        ],
                      )
                    ],
                  )))),
          Expanded(flex: 4, child: itemList())
        ],
      ),
    );
  }

  Widget itemList() {
    return ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: calendars.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onHorizontalDragEnd: (DragEndDetails details){
              showDialog(context: context, builder: (context){
                return AlertDialog(
                  backgroundColor: Color.fromRGBO(255, 255, 255, 0.5),
                  title: Text("Confirm !",style: TextStyle(fontSize: 50.0,fontWeight: FontWeight.bold,)),
                  content: calendars[index].make ? Text("Dommage cette tache est deja effectuee ?",style: TextStyle(fontSize: 30.0,)): Text("Avez vous effectuez cette tache ?",style: TextStyle(fontSize: 30.0,)),
                  actions: [
                    IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.thumb_down),iconSize: 100,color: Colors.red),
                    SizedBox(width: 230,),
                   calendars[index].make ? IconButton(icon: Icon(Icons.sentiment_very_dissatisfied),onPressed: (){onMake(calendars[index].id);},iconSize: 100,) : IconButton(icon: Icon(Icons.thumb_up),onPressed: (){onMake(calendars[index].id);},iconSize: 100,)
                  ],
                );
              },barrierDismissible: false);
            },
          child:Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Container(
                  height: 200,
                  decoration: BoxDecoration(color: calendars[index].make ? Color.fromRGBO(128, 255, 0, 0.5): Color.fromRGBO(255, 0, 0, 0.5),
                   borderRadius: BorderRadius.all(Radius.circular(15))),
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                    Row(
                      children: [
                        Expanded(
                            child: Padding(
                                padding: EdgeInsets.only(left: 10.0),
                                child: Text(
                                  calendars[index].name,
                                  style: TextStyle(fontSize: 30.0, color: Colors.white, fontWeight: FontWeight.bold),
                                ))),
                        Expanded(child: Text(calendars[index].date, style: TextStyle(fontSize: 30.0, color: Colors.white)))
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: Padding(
                                padding: EdgeInsets.only(left: 10.0),
                                child: Text(
                                  calendars[index].intervention,
                                  style: TextStyle(fontSize: 30.0, color: Colors.white, fontWeight: FontWeight.bold),
                                ))),
                      ],
                    )
                  ]))));
        });
  }

  Future<void> getData() async {
    var response = await CallApi().getData("/api/v1/fish/byName?name=" + this.nameSubject);
    var body = jsonDecode(utf8.decode(response.bodyBytes));
    print(body);
    if (body['success']) {
      fish = Fish.fromJson(body['fish']);
      for (var cal in body['fish']['calendary']) {
        calendars.add(Calendary.fromMap(cal));
      }
      setState(() {
        load = false;
      });
    }
  }

  Future<void> onMake(int id) async{
    Navigator.pop(context);
    int index = calendars.indexWhere((element) => element.id == id);
    if(calendars[index].make == false){
      var response = await CallApi().getData("/api/v1/make/fish/$id");
      var body = jsonDecode(utf8.decode(response.bodyBytes));
      if(body['success']){
          MyWidget().notification(context, body['message']);
          setState(() {
            calendars[index].make = true;
          });
      }else{
        MyWidget().notification(context, body['message']);
      }
    }else{
      MyWidget().notification(context,"Déja effectué");
    }
  }
}