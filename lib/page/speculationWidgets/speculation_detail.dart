
import 'dart:convert';
import '../../utils/calendary.dart';
import '../../utils/service.dart';
import '../../utils/speculation.dart';
import '../../widget/external_widget.dart';
import '../../widget/spinner_widget.dart';
import 'package:flutter/material.dart';
import '../utilWidgets/detailsContainer.dart';

class SpeculationDetailPage extends StatefulWidget {
  final String nameSubject;
  const SpeculationDetailPage(this.nameSubject);

  @override
  _SpeculationDetailPageState createState() => _SpeculationDetailPageState(this.nameSubject);
}

class _SpeculationDetailPageState extends State<SpeculationDetailPage> {
  String nameSubject;
  _SpeculationDetailPageState(this.nameSubject);
  bool load = true;
  List<Calendary> calendarys = [];
  late Speculation speculation;
  late TextEditingController _controllerDescription = new TextEditingController();

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
         /*  actions: <Widget>[ IconButton(icon: const Icon(Icons.set_meal_outlined),onPressed: () {})], */
        )),
      body: Container( child: load? Center(child: SpinnerWidget()) : screen(),
        decoration: BoxDecoration(image: DecorationImage(image: AssetImage("images/speculation.jpg"),fit: BoxFit.cover,),),)
    );
  }

  Widget screen() {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: ContainerDetails(headerDetail(),decorationDetail()
                   )),
          Expanded(child: itemList())
        ],
      ),
    );
  }

  Decoration decorationDetail(){
    return const BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0.6), borderRadius: BorderRadius.all(Radius.circular(15)));
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
                                  child: Text(
                                    speculation.name,
                                    style: TextStyle(
                                      fontSize: 30.0, 
                                      color: Colors.white, 
                                      fontWeight: FontWeight.bold),
                                  ))),
                          Expanded(child: Text(
                            speculation.seedName, 
                            style: TextStyle(
                              fontSize: 30.0, 
                              color: Colors.white)))
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(child: Padding(
                            padding: EdgeInsets.only(left: 10.0), 
                            child: Text(speculation.seedDate.toString(), 
                          style: TextStyle(fontSize: 30.0, color: Colors.white)))),
                          Expanded(child: Text(speculation.plantingName, style: TextStyle(fontSize: 30.0, color: Colors.white)))
                        ],
                      ),
                    ],
                  );
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
                  actionsAlignment: MainAxisAlignment.spaceBetween,
                  backgroundColor: Color.fromRGBO(255, 255, 255, 0.8),
                  title: Text("Confirm !",style: TextStyle(fontSize: 50.0,fontWeight: FontWeight.bold,)),
                  content: calendarys[index].make || calendarys[index].giveUp ? Text("Dommage cette tâche est deja effectuée ?",style: TextStyle(fontSize: 30.0,)): Text("Avez-vous effectuez cette tâche ?",style: TextStyle(fontSize: 30.0,)),
                  actions: [
                    IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.close_outlined),iconSize: 60,color: Colors.red),
                    calendarys[index].make || calendarys[index].giveUp ? IconButton(icon: Icon(Icons.sentiment_very_dissatisfied),onPressed: (){},iconSize: 1) : IconButton(onPressed: (){Navigator.pop(context); giveUpWidget(calendarys[index].id);}, icon: Icon(Icons.thumb_down),iconSize: 60,color: Colors.indigo),
                    calendarys[index].make || calendarys[index].giveUp ? IconButton(icon: Icon(Icons.sentiment_very_dissatisfied),onPressed: (){},iconSize: 1) : IconButton(icon: Icon(Icons.thumb_up),onPressed: (){onMake(calendarys[index].id);},iconSize: 60,)
                  ],
                );
              },barrierDismissible: false);
            },
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: ContainerDetails( 
                  listDetails(index),
                  decorationList(index),
                  
                  )));
        });
  }

 Decoration decorationList(int index){
    return BoxDecoration(color: calendarys[index].make ? const Color.fromRGBO(128, 255, 0, 1.0): calendarys[index].giveUp ? Colors.indigo:  const Color.fromRGBO(255, 0, 0, 1.0),
                         borderRadius:  const BorderRadius.all(Radius.circular(15)),

    );
    
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
                                  child: Text(calendarys[index].intervention,style: TextStyle(fontSize: 30.0, color: Colors.white, fontWeight: FontWeight.bold),
                                  ))),
                        ],
                      )]);
  }

  Future giveUpWidget(int id){
    return showDialog(context: context,barrierDismissible: false, builder: (context){
      return AlertDialog(
        actionsAlignment: MainAxisAlignment.spaceBetween,
        backgroundColor: Color.fromRGBO(255, 255, 255, 0.8),
        title: Text("Confirm !",style: TextStyle(fontSize: 50.0,fontWeight: FontWeight.bold,)),
        content: TextFormField(
          keyboardType: TextInputType.text,
          controller: this._controllerDescription,
          decoration: InputDecoration(border: OutlineInputBorder(), icon: Icon(Icons.comment_outlined), labelText: "Raison de l'annulation ?"),
        ),
        actions: [
          TextButton(onPressed: (){Navigator.pop(context);}, child: Text("ANNULER",style: TextStyle(fontSize: 20.0,color: Colors.red))),
          TextButton(onPressed: () { giveUp(id);}, child: Text("ENREGISTRER",style: TextStyle(fontSize: 20.0),))
        ],
      );
    });
  }

  Future<void> giveUp(int id) async {

    int index = calendarys.indexWhere((item) => item.id == id);
    Calendary cal = calendarys[index];
    cal.giveUp = true;
    cal.description = _controllerDescription.text;
    var response = await CallApi().postData(cal.toMap(),"/api/v1/giveUp/speculation");
    var body = jsonDecode(utf8.decode(response.bodyBytes));
    if(body['success']){
      MyWidget().notification(context, body['message']);
          setState(() {
            calendarys[index].giveUp = true;
          });
          Navigator.pop(context);
      }else{
        MyWidget().notification(context, body['message']);
      }
  }

  Future<void> getData() async {
    
    var response = await CallApi().getData("/api/v1/speculation/byName?name=$nameSubject");
    
    var body = jsonDecode(utf8.decode(response.bodyBytes));
    //int index = calendarys.indexWhere((element) => element.speculation_id ==id);
    //var response2 = await CallApi().getData("/api/v1/calendar/speculation/$id");
    if (body['success']) {
      speculation = Speculation.fromJson(body['speculation']);
      //getDataFromCalendars(speculation.id);
      int id= speculation.id;
      var response2 = await CallApi().getData("/api/v1/calendar/speculation/$id");
      var body2 = jsonDecode(utf8.decode(response2.bodyBytes)); 
  
      for (var cal in body2['calendars']) {
          calendarys.add(Calendary.fromMap(cal));
        
          }
    }

    setState(() {
        load = false;
      }); 

      /*     speculation = Speculation.fromJson(body['speculation']);
      for (var cal in body['speculation']['calendary']) {
        calendarys.add(Calendary.fromMap(cal));
      }
      setState(() {
        load = false;
      }); */
  }


  Future<void> onMake(int id) async{
    Navigator.pop(context);
    int index = calendarys.indexWhere((element) => element.id == id);
    if(calendarys[index].make == false){
      var response = await CallApi().getData("/api/v1/make/speculation/$id");
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