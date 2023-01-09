
import 'dart:convert';

import '../../utils/calendary.dart';
import '../../utils/poultry.dart';
import '../../utils/service.dart';
import '../../widget/external_widget.dart';
import '../../widget/spinner_widget.dart';
import 'package:flutter/material.dart';
import '../utilWidgets/detailsContainer.dart';
import '../utilWidgets/TitleDynamic.dart';

class PoultryDetailPage extends StatefulWidget {
  final String nameSubject;
  PoultryDetailPage(this.nameSubject);

  @override
  _PoultryDetailPageState createState() => _PoultryDetailPageState(this.nameSubject);
}

class _PoultryDetailPageState extends State<PoultryDetailPage> {
  String nameSubject;
  _PoultryDetailPageState(this.nameSubject);
  bool load = true;
  late Poultry poultry;
  List<Calendary> calendarys = [];

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
          title: ClipRect(child: Image.asset('images/logoFarm.gif',width: 60.0,height: 60.0,)),
         /*  actions: <Widget>[ IconButton(icon: const Icon(Icons.flutter_dash_outlined),onPressed: () {})], */
        )),
      body: Container( child: load? Center(child: SpinnerWidget()) : screen(),
        decoration: BoxDecoration(image: DecorationImage(image: AssetImage("images/poultry.png"),fit: BoxFit.cover,),),)
    );
  }

  Future<void> getData() async {
    var response = await CallApi().getData('/api/v1/poultry/byName?name='+nameSubject);
    var body = jsonDecode(utf8.decode(response.bodyBytes));
    if (body['success']) {
      poultry = Poultry.fromJson(body['poultry']);
      //getDataFromCalendars(speculation.id);
      int id= poultry.id;
      var response2 = await CallApi().getData("/api/v1/calendar/poultry/$id");
      var body2 = jsonDecode(utf8.decode(response2.bodyBytes)); 
  
      for (var cal in body2['calendars']) {
          calendarys.add(Calendary.fromMap(cal));
        
          }
    }

    setState(() {
        load = false;
      }); 


/*     if(body['success']){
      poultry = Poultry.fromJson(body['poultry']);
      for (var item in body['poultry']['calendary']) {
        calendarys.add(Calendary.fromMap(item));
      }
      setState(() {
        load = false;
      });
    } */
  }

  Widget screen(){
    
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: ContainerDetails(headerDetail(),decorationDetails()
              )),
                  Expanded(
                   // height: MediaQuery.of(context).size.height -250,
                    child: itemList(),
                  )
        ]));
  }



  Widget itemList() {
    return ListView.builder(
        padding: const EdgeInsets.all(4),
        itemCount: calendarys.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onHorizontalDragEnd: (DragEndDetails details){
              showDialog(context: context, builder: (context){
                return AlertDialog(
                  backgroundColor: Color.fromRGBO(255, 255, 255, 0.5),
                  title: Text("Confirm !",style: TextStyle(fontSize: 50.0,fontWeight: FontWeight.bold,)),
                  content: calendarys[index].make ? Text("Dommage cette tache est deja effectuee ?",style: TextStyle(fontSize: 30.0,)): Text("Avez vous effectuez cette tache ?",style: TextStyle(fontSize: 30.0,)),
                  actions: [
                    IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.thumb_down),iconSize: 100,color: Colors.red),
                    SizedBox(width: 230,),
                   calendarys[index].make ? IconButton(icon: Icon(Icons.sentiment_very_dissatisfied),onPressed: (){onMake(calendarys[index].id);},iconSize: 100,) : IconButton(icon: Icon(Icons.thumb_up),onPressed: (){onMake(calendarys[index].id);},iconSize: 100,)
                  ],
                );
              },barrierDismissible: false);
            },
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: ContainerDetails(
                  //height: 200,
                  listDetails(index),decorationList(index)
                  )));
        });
  }

  Decoration decorationDetails(){
    return const BoxDecoration(
      color: Color.fromRGBO(0, 0, 0, 0.6), 
      borderRadius: BorderRadius.all(Radius.circular(15)),                
    );
  }
  
  Decoration decorationList(int index){
    return  BoxDecoration(color: calendarys[index].make ? Color.fromRGBO(128, 255, 0, 0.5): Color.fromRGBO(255, 0, 0, 0.5),
                   borderRadius: BorderRadius.all(Radius.circular(15)));

  }

  Widget listDetails(int index){
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                    Row(
                      children: [
                        Expanded(
                            child: Padding(
                                padding: EdgeInsets.only(left: 10.0),
                                child: Text(
                                  calendarys[index].name,
                                  style: TextStyle(fontSize: 30.0, color: Colors.white, fontWeight: FontWeight.bold),
                                ))),
                        Expanded(child: Text(calendarys[index].date, style: TextStyle(fontSize: 30.0, color: Colors.white)))
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: Padding(
                                padding: EdgeInsets.only(left: 10.0),
                                child: Text(
                                  calendarys[index].intervention,
                                  style: TextStyle(fontSize: 30.0, color: Colors.white, fontWeight: FontWeight.bold),
                                ))),
                      ],
                    )
                  ]);
  }

  

  Widget headerDetail(){
    return Column(

        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            children: [
              Expanded(
                  child: Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: DynamicText(
                        poultry.name,
                        FontWeight.bold,Colors.white))),
            ],
          ),
          Row(
            children: [
              Expanded(child: Padding(padding: EdgeInsets.only(left: 10.0), child: Text(poultry.quantity.toString()+"sujet", style: TextStyle(fontSize: 30.0, color: Colors.white)))),
              Expanded(child: Text(poultry.coopsName, style: TextStyle(fontSize: 30.0, color: Colors.white)))
            ],
          ),
          Row(
            children: [
              Expanded(child: Padding(padding: EdgeInsets.only(left: 10.0), child: Text(poultry.developmentTime.toString()+"jours", style: TextStyle(fontSize: 30.0, color: Colors.white)))),
              Expanded(child: Text(poultry.dateOfEntry, style: TextStyle(fontSize: 30.0, color: Colors.white)))
            ],
          )
        ],
      );

  }

  Future<void> onMake(int id) async{
    Navigator.pop(context);
    int index = calendarys.indexWhere((element) => element.id == id);
    if(calendarys[index].make == false){
      var response = await CallApi().getData("/api/v1/make/poultry/$id");
      var body = jsonDecode(utf8.decode(response.bodyBytes));
      if(body['success']){
          MyWidget().notification(context, body['message']);
          setState(() {
            calendarys[index].make = true;
          });
      }else{
        MyWidget().notification(context, body['message']);
      }
    }else{
      MyWidget().notification(context,"Déja effectué");
    }
  }

}