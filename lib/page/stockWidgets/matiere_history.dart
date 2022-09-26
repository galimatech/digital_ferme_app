import 'dart:convert';

import '../../utils/incomingStock.dart';
import '../../utils/service.dart';
import '../../widget/spinner_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class MatiereHistoryPage extends StatefulWidget {
  const MatiereHistoryPage({ Key? key }) : super(key: key);

  @override
  State<MatiereHistoryPage> createState() => _MatiereHistoryPageState();
}

class _MatiereHistoryPageState extends State<MatiereHistoryPage> {
  late bool load = true;
  List<IncomingStock> incomings = [];
  List<IncomingStock> showIncomings = [];
  late DateFormat dateFormat;
  
  @override
  void initState() {
    initializeDateFormatting(); 
    dateFormat = new DateFormat.yMMMMEEEEd('fr');
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
          actions: <Widget>[ IconButton(icon: const Icon(Icons.local_florist_outlined),onPressed: () {})],
        )),
      body: Container( child: load ? Center(child: SpinnerWidget()) : layout(),
        padding: EdgeInsets.symmetric(horizontal: 20.0,vertical: 10.0),)
    );
  }

  Widget layout(){
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: InputDecoration(border: OutlineInputBorder(),labelText: "Nom du produit"),
            onChanged: (value) => filterItem(value)),
        ),
        itemList()
      ],
    );
  }

  Widget itemList(){
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          decoration: BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0.6,),borderRadius: BorderRadius.all(Radius.circular(15))),
          dataTextStyle: TextStyle(color: Colors.white),
          headingTextStyle: TextStyle(color: Colors.green),
          columns: [
            DataColumn(label: Text('Produit',style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold) )),
            DataColumn(numeric: true, label: Text('Nombre',style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold) )),
            DataColumn(label: Text('Conditionnement',style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold) )),
            DataColumn(numeric: true, label: Text('Volume',style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold) )),
            DataColumn(label: Text('Unité',style: TextStyle(fontSize: 19,fontWeight: FontWeight.bold),)),
            DataColumn(numeric: true, label: Text('Total',style: TextStyle(fontSize: 19,fontWeight: FontWeight.bold),)),
            DataColumn(label: Text('Date',style: TextStyle(fontSize: 19,fontWeight: FontWeight.bold),)),
            DataColumn(label: Text('Auteur',style: TextStyle(fontSize: 19,fontWeight: FontWeight.bold),))
          ],
          rows: showIncomings.map((incoming) => DataRow(cells: [
            DataCell(Text(incoming.product, style: TextStyle(fontSize: 19, fontStyle: FontStyle.italic),)),
            DataCell(Text(incoming.value.toString())),
            DataCell(Text(incoming.unitValue)),
            DataCell(Text(incoming.volume.toString())),
            DataCell(Text(incoming.unitVolume)),
            DataCell(Text(incoming.quantity.toString())),
            DataCell(Text(formatDate(incoming.date))),
            DataCell(Text(incoming.user.name))
          ])).toList(),
        ),),
    );
  }

  void filterItem(String pattern){
    setState(() {
      showIncomings = incomings.where((element) => element.product.toUpperCase().startsWith(pattern.toUpperCase())).toList();
    });
  }

  Future<void> getData() async {
    var res = await CallApi().getData("/api/v1/incoming/byMe");
    var body = jsonDecode(utf8.decode(res.bodyBytes));
    if(body['success']){
      for(var json in body['object']){
        incomings.add(IncomingStock.fromJson(json));
      }
      showIncomings = incomings;
      setState(() {
        load = false;
      });
    }
  }

  String formatDate(String date){
   DateTime _dateTime = DateTime.parse(date);
    String formattedDate = dateFormat.format(_dateTime);
    return formattedDate;
  }
}