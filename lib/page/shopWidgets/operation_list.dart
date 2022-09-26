import 'dart:convert';

import '../../page/utilWidgets/home.dart';
import '../../utils/operation.dart';
import '../../utils/service.dart';
import '../../widget/operation_widget.dart';
import '../../widget/spinner_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class OperationPage extends StatefulWidget {
  const OperationPage({ Key? key }) : super(key: key);

  @override
  State<OperationPage> createState() => _OperationPageState();
}

class _OperationPageState extends State<OperationPage> {
  late bool load = true;
  List<Operation> operations = [];
  List<Operation> showOperations = [];
  late DateFormat dateFormat;
  late DateFormat timeFormat;
  
  @override
  void initState() {
    initializeDateFormatting(); 
    dateFormat = new DateFormat.yMMMMEEEEd('fr');
    timeFormat = new DateFormat.Hms('fr');
    getData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.07), // here the desired height
          child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          title: ClipRect(child: Image.asset('images/logoFarm.gif',width: 60.0,height: 60.0,)),
        )),
        floatingActionButton: SpeedDial(
          animatedIcon: AnimatedIcons.menu_close,
          overlayColor: Colors.black,
          overlayOpacity: 0.2,
          children: [
            SpeedDialChild(
              child: Icon(Icons.home_outlined,color: Colors.green,),
              label: "Accueil",
              labelStyle: TextStyle(color: Colors.green),
              onTap:() => Navigator.pushAndRemoveUntil<void>(context,MaterialPageRoute<void>(builder: (BuildContext context) => HomePage(),
            ),ModalRoute.withName("/"))),
            SpeedDialChild(
              child: Icon(Icons.add_box_outlined, color: Colors.green,),
              label: "Nouvelle opération",
              labelStyle: TextStyle(color: Colors.green),
              onTap: () => showDialog(barrierDismissible: false, context: context, builder: (_) => OperationWidget())
            )
          ],),
        body: load ? Center(child: SpinnerWidget(),) : layout()
    );
  }

  Widget layout(){
    return ListView(
        children: [
          Padding(padding: EdgeInsets.all(8.0),
          child: TextField(
            decoration: InputDecoration(border: OutlineInputBorder(),labelText: "recherche compte"),
            onChanged: (pattern) => filterItem(pattern),),),
            itemList(),
        ],
    );
  }

  filterItem(String pattern){
    setState(() {
      showOperations = operations.where((element) => element.compte.name.toLowerCase().startsWith(pattern.toLowerCase())).toList();
    });
  }

  String formatDate(String date){
   DateTime _dateTime = DateTime.parse(date);
    String formattedDate = dateFormat.format(_dateTime)+"   "+timeFormat.format(_dateTime);
    return formattedDate;
  }

  Widget itemList(){
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 7.5),  scrollDirection: Axis.vertical,
      child: SingleChildScrollView( scrollDirection: Axis.horizontal,
        child: DataTable(
          decoration: BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0.6,),borderRadius: BorderRadius.all(Radius.circular(15))),
          dataTextStyle: TextStyle(color: Colors.white),
          headingTextStyle: TextStyle(color: Colors.green),
          columns: [
            DataColumn(label: Text("Numéro du compte", style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold))),
            DataColumn(label: Text("Nom du compte", style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold))),
            DataColumn(numeric: true, label: Text("Montant", style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold))),
            DataColumn(label: Text("Libellé", style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold))),
            DataColumn(label: Text("Date", style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold))),
          ],
          rows: showOperations.map((operation) => DataRow(cells: [
            DataCell(Text(operation.compte.number.toString())),
            DataCell(Text(operation.compte.name)),
            DataCell(Text(operation.amount.toString(),style: TextStyle(color:operation.category==null?Colors.green:operation.category!.debitAccount?Colors.red:Colors.green),)),
            DataCell(Text(operation.label)),
            DataCell(Text(formatDate(operation.date)))
          ])).toList(),),),
    );
  }

  Future<void> getData() async{
    var res = await CallApi().getData("/api/v1/operation");
    if(res.statusCode == 401)
      CallApi().logOut(context);
    else{
    var body = jsonDecode(utf8.decode(res.bodyBytes));
    if(body['success']){
      for(var json in body['object'])
        operations.add(Operation.fromJson(json));
      setState(() {showOperations = operations; load = false;});
    }
  }}
}